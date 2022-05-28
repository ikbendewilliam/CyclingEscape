import 'package:cycling_escape/repository/name/name_repository.dart';
import 'package:cycling_escape/util/extension/list_sprint_extensions.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResultsViewModel with ChangeNotifierEx {
  late final ResultsNavigator _navigator;
  late final List<Results> _results;
  late final controller = PageController();
  final NameRepository _nameRepository;
  final _names = <int, String>{};

  List<Results> get results => _results;

  String numberToName(int number) => _nameRepository.names[number] ?? '';

  ResultsViewModel(
    this._nameRepository,
  );

  Future<void> init(ResultsNavigator navigator, List<Sprint> sprints) async {
    _navigator = navigator;
    _results = sprints.calculateResults()..removeWhere((element) => element.data.isEmpty);
    _names.addAll(_nameRepository.names);
  }

  void onClosePressed() => _navigator.goToMainMenu();
}

mixin ResultsNavigator {
  void goToMainMenu();
}
