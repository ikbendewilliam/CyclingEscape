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

  void goToV2dialog();

  void goToInformation();

  void goToCareerFinish();

  void goToCareerReset();

  void goToCareerSelectRiders();

  void goToCareerCalendar();

  void goToCareerStandings();

  Future<void> goToCareerOverview();

  Future<void> goToTourInProgress();

  void goToActiveTour();

  Future<void> goToTourSelect();

  void goToChangeCyclistNames();

  void goToCredits();

  void goToSettings();

  void goToResults(List<Sprint> sprints, bool isTour, bool isCareer);

  Future<void> goToGame(PlaySettings playSettings);

  Future<void> goToSingleRaceMenu();

  Future<String?> showEditNameDialog(String value);

  void showCustomDialog<T>({required WidgetBuilder builder});
}

mixin MainNavigationMixin<T extends StatefulWidget> on State<T> implements MainNavigation {}
