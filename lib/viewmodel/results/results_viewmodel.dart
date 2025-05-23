import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/career/career_repository.dart';
import 'package:cycling_escape/repository/name/name_repository.dart';
import 'package:cycling_escape/repository/tour/tour_repository.dart';
import 'package:cycling_escape/util/extension/list_sprint_extensions.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResultsViewModel with ChangeNotifierEx {
  late final ResultsNavigator _navigator;
  late final controller = PageController();
  final NameRepository _nameRepository;
  final TourRepository _tourRepository;
  final CareerRepository _careerRepository;
  final _names = <int, String>{};
  late final bool _isTour;
  late final bool _isCareer;
  List<Results>? _results;

  List<Results> get results => _results ?? [];

  String numberToName(int number) => _nameRepository.names[number] ?? '';

  ResultsViewModel(
    this._nameRepository,
    this._tourRepository,
    this._careerRepository,
  );

  Future<void> init(ResultsNavigator navigator, ResultsArguments arguments) async {
    _navigator = navigator;
    _isTour = arguments.isTour;
    _isCareer = arguments.isCareer;
    Results? results;
    if (_isTour) results = await _tourRepository.currentResults;
    final combinedResults = arguments.sprints.calculateResults(currentResults: results)..removeWhere((element) => element.data.isEmpty);
    _results = combinedResults.where((element) => element.type != ResultsType.combined).toList();
    _names.addAll(_nameRepository.names);
    if (_isTour && combinedResults.any((element) => element.type == ResultsType.combined)) {
      _tourRepository.completedRaces++;
      await _tourRepository.saveResults(combinedResults.firstWhere((element) => element.type == ResultsType.combined));
    }
    notifyListeners();
    if (_isCareer && (!_isTour || _tourRepository.completedRaces == _tourRepository.playSettings?.totalRaces)) {
      await _careerRepository.updateResults(combinedResults);
    }
  }

  void onClosePressed() {
    if (_isTour) return _navigator.goToActiveTour();
    if (_isCareer) return _navigator.goToCareerOverview();
    _navigator.goToMainMenu();
  }
}

mixin ResultsNavigator {
  void goToMainMenu();

  void goToCareerOverview();

  void goToActiveTour();
}

class ResultsArguments {
  final List<Sprint> sprints;
  final bool isTour;
  final bool isCareer;

  ResultsArguments(
    this.sprints,
    this.isTour,
    this.isCareer,
  );
}
