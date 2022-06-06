import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/repository/calendar/calendar_repository.dart';
import 'package:cycling_escape/repository/career/career_repository.dart';
import 'package:cycling_escape/repository/name/name_repository.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerStandingsViewModel with ChangeNotifierEx {
  late final CareerStandingsNavigator _navigator;
  final CareerRepository _careerRepository;
  final CalendarRepository _calendarRepository;
  final NameRepository _nameRepository;
  final List<ResultData> _currentResults = [];
  final List<ResultData> _teamResults = [];
  late final controller = PageController();

  int get racesCompleted => _calendarRepository.eventsCompleted;

  List<ResultData> get currentResults => _currentResults;

  List<ResultData> get teamResults => _teamResults;

  CareerStandingsViewModel(
    this._careerRepository,
    this._calendarRepository,
    this._nameRepository,
  );

  Future<void> init(CareerStandingsNavigator navigator) async {
    _navigator = navigator;
    _currentResults
      ..addAll(await _careerRepository.currentResults)
      ..sort((a, b) => b.points.compareTo(a.points));
    _calculateTeamResults();
    notifyListeners();
  }

  String numberToName(int? number) => (number == null ? null : _nameRepository.names[number]) ?? '-';

  void _calculateTeamResults() {
    final teams = _currentResults.map((element) => element.team).toList();
    for (final team in teams) {
      if (_teamResults.where((element) => element.team == team).isEmpty) {
        final resultData = ResultData();
        _currentResults.where((element) => element.team == team).forEach((element) => resultData.points += element.points);
        resultData.team = team;
        _teamResults.add(resultData);
      }
    }
    _teamResults
      ..sort((a, b) => b.points.compareTo(a.points))
      ..asMap().forEach((key, value) => value.rank = key);
  }

  void onClosePressed() => _navigator.goBack<void>();
}

mixin CareerStandingsNavigator implements BackNavigator {}
