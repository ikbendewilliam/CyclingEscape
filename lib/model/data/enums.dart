import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/util/locale/localization_keys.dart';
import 'package:flutter/material.dart';

enum CyclistMovementType {
  slow(2, LocalizationKeys.settingsCyclistMoveSpeedSlow),
  normal(1, LocalizationKeys.settingsCyclistMoveSpeedNormal),
  fast(0.5, LocalizationKeys.settingsCyclistMoveSpeedFast),
  skip(0.01, LocalizationKeys.settingsCyclistMoveSpeedSkip);

  final double timerDuration;
  final String localizationKey;

  const CyclistMovementType(this.timerDuration, this.localizationKey);
}

enum CameraMovementType {
  none(LocalizationKeys.settingsCameraAutoMoveDisabled),
  selectOnly(LocalizationKeys.settingsCameraAutoMoveSelectOnly),
  auto(LocalizationKeys.settingsCameraAutoMoveSelectAndFollow);

  final String localizationKey;

  const CameraMovementType(this.localizationKey);
}

enum FollowType { follow, autoFollow, leave }

enum MapType { flat, cobble, hills, heavy }

enum ResultsType {
  race(Colors.blue, ThemeAssets.iconRank, ResultsColumn.all),
  time(Colors.yellow, ThemeAssets.iconTime, [ResultsColumn.rank, ResultsColumn.number, ResultsColumn.time]),
  young(Colors.black, ThemeAssets.iconYoung, [ResultsColumn.rank, ResultsColumn.number, ResultsColumn.time]),
  points(Colors.green, ThemeAssets.iconPoints, [ResultsColumn.rank, ResultsColumn.number, ResultsColumn.points]),
  mountain(Colors.red, ThemeAssets.iconMountain, [ResultsColumn.rank, ResultsColumn.number, ResultsColumn.mountain]),
  team(Colors.purple, ThemeAssets.iconTeam, [ResultsColumn.rank, ResultsColumn.team, ResultsColumn.time]);

  final Color color;
  final String icon;
  final List<ResultsColumn> columns;

  const ResultsType(this.color, this.icon, this.columns);
}

enum ResultsColumn {
  rank(ThemeAssets.iconRank),
  number(ThemeAssets.iconNumber),
  time(ThemeAssets.iconTime),
  team(ThemeAssets.iconTeam),
  points(ThemeAssets.iconPoints),
  mountain(ThemeAssets.iconMountain);

  static const all = [
    rank,
    number,
    time,
    points,
    mountain,
  ];

  final String icon;

  const ResultsColumn(this.icon);
}

enum MapLength {
  short(1),
  medium(20),
  long(30),
  veryLong(40);

  final int segments;

  const MapLength(this.segments);
}

enum DifficultyType {
  easy(1, LocalizationKeys.settingsDifficultyEasy),
  normal(0, LocalizationKeys.settingsDifficultyNormal),
  hard(-1, LocalizationKeys.settingsDifficultyHard);

  final int diceAddition;
  final String localizationKey;

  const DifficultyType(this.diceAddition, this.localizationKey);
}

enum TutorialType {
  firstOpen(LocalizationKeys.tutorialWelcomeTitle, LocalizationKeys.tutorialWelcomeDescription),
  career(LocalizationKeys.tutorialCareerTitle, LocalizationKeys.tutorialCareerDescription),
  careerFirstFinished(LocalizationKeys.tutorialFirstCareerTitle, LocalizationKeys.tutorialFirstCareerDescription),
  careerUpgrades(LocalizationKeys.tutorialUpgradesTitle, LocalizationKeys.tutorialUpgradesDescription),
  singleRace(LocalizationKeys.tutorialSingleRaceTitle, LocalizationKeys.tutorialSingleRaceDescription),
  tour(LocalizationKeys.tutorialTourTitle, LocalizationKeys.tutorialTourDescription),
  openRace(LocalizationKeys.tutorialOpenRaceTitle, LocalizationKeys.tutorialOpenRaceDescription),
  throwDice(LocalizationKeys.tutorialThrowDiceTitle, LocalizationKeys.tutorialThrowDiceDescription),
  selectPosition(LocalizationKeys.tutorialSelectPositionTitle, LocalizationKeys.tutorialSelectPositionDescription),
  follow(LocalizationKeys.tutorialFollowOrNotTitle, LocalizationKeys.tutorialFollowOrNotDescription),
  noFollowAvailable(LocalizationKeys.tutorialCantFollowTitle, LocalizationKeys.tutorialCantFollowDescription),
  followAfterAutoFollow(LocalizationKeys.tutorialStillFollowTitle, LocalizationKeys.tutorialStillFollowDescription),
  fieldValue(LocalizationKeys.tutorialDifficultTerrainTitle, LocalizationKeys.tutorialDifficultTerrainDescription),
  fieldValuePositive(LocalizationKeys.tutorialDownhillTitle, LocalizationKeys.tutorialDownhillDescription),
  sprint(LocalizationKeys.tutorialSprintTitle, LocalizationKeys.tutorialSprintDescription),
  finish(LocalizationKeys.tutorialFinishTitle, LocalizationKeys.tutorialFinishDescription),
  rankings(LocalizationKeys.tutorialRankingsTitle, LocalizationKeys.tutorialRankingsDescription),
  settings(LocalizationKeys.tutorialSettingsTitle, LocalizationKeys.tutorialSettingsDescription),
  tourFirstFinished(LocalizationKeys.tutorialFirstTourFinishedTitle, LocalizationKeys.tutorialFirstTourFinishedDescription);

  final String titleKey;
  final String descriptionKey;

  const TutorialType(this.titleKey, this.descriptionKey);
}
