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

  List<Results> get results => _results;

  ResultsViewModel();

  Future<void> init(ResultsNavigator navigator, List<Sprint> sprints) async {
    _navigator = navigator;
    _results = sprints.calculateResults()..removeWhere((element) => element.data.isEmpty);
  }

  void onClosePressed() => _navigator.goToMainMenu();
}

mixin ResultsNavigator {
  void goToMainMenu();
}
