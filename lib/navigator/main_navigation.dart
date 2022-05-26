import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

abstract class MainNavigation {
  void goToSplash();

  void goToHome();

  void goToDebugPlatformSelector();

  void goToThemeModeSelector();

  void goToDebug();

  void goToLicense();

  void closeDialog();

  void goToDatabase(GeneratedDatabase db);

  void goBack<T>({T? result});

  void goToSettings();

  void goToResults(List<Sprint> sprints);

  void goToGame(PlaySettings playSettings);

  void goToSingleRaceMenu();

  void goToTourMenu();

  void showCustomDialog<T>({required WidgetBuilder builder});
}

mixin MainNavigationMixin<T extends StatefulWidget> on State<T> implements MainNavigation {}
