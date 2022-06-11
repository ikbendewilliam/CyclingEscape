import 'package:collection/collection.dart';
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

enum MapType {
  flat(LocalizationKeys.raceTypeFlat),
  cobble(LocalizationKeys.raceTypeCobbled),
  hills(LocalizationKeys.raceTypeHilled),
  heavy(LocalizationKeys.raceTypeHeavy);

  final String localizationKey;

  const MapType(this.localizationKey);

  static MapType fromMap(String map) => MapType.values.firstWhereOrNull((element) => element.toString() == map) ?? MapType.flat;
}

enum ResultsType {
  combined(Colors.white, ThemeAssets.iconRank, []),
  race(Colors.blue, ThemeAssets.iconRank, ResultsColumn.all),
  time(Colors.yellow, ThemeAssets.iconTime, [ResultsColumn.rank, ResultsColumn.number, ResultsColumn.name, ResultsColumn.time]),
  young(Colors.black, ThemeAssets.iconYoung, [ResultsColumn.rank, ResultsColumn.number, ResultsColumn.name, ResultsColumn.time]),
  points(Colors.green, ThemeAssets.iconPoints, [ResultsColumn.rank, ResultsColumn.number, ResultsColumn.name, ResultsColumn.points]),
  mountain(Colors.red, ThemeAssets.iconMountain, [ResultsColumn.rank, ResultsColumn.number, ResultsColumn.name, ResultsColumn.mountain]),
  team(Colors.purple, ThemeAssets.iconTeam, [ResultsColumn.rank, ResultsColumn.team, ResultsColumn.time]);

  final Color color;
  final String icon;
  final List<ResultsColumn> columns;

  const ResultsType(this.color, this.icon, this.columns);
}

enum ResultsColumn {
  rank(ThemeAssets.iconRank),
  number(ThemeAssets.iconNumber),
  name(null, flex: 3, textAlign: TextAlign.start, useFittedBox: true),
  time(ThemeAssets.iconTime),
  team(ThemeAssets.iconTeam),
  points(ThemeAssets.iconPoints),
  mountain(ThemeAssets.iconMountain);

  static const all = [
    rank,
    number,
    name,
    time,
    points,
    mountain,
  ];

  final String? icon;
  final int flex;
  final TextAlign textAlign;
  final bool useFittedBox;

  const ResultsColumn(
    this.icon, {
    this.flex = 1,
    this.textAlign = TextAlign.center,
    this.useFittedBox = false,
  });
}

enum MapLength {
  short(10, LocalizationKeys.raceDurationShort),
  medium(20, LocalizationKeys.raceDurationMedium),
  long(30, LocalizationKeys.raceDurationLong),
  veryLong(40, LocalizationKeys.raceDurationVeryLong);

  final int segments;
  final String localizationKey;

  const MapLength(this.segments, this.localizationKey);

  static MapLength fromMap(String map) => MapLength.values.firstWhereOrNull((element) => element.toString() == map) ?? MapLength.short;
}

enum DifficultyType {
  easy(1, LocalizationKeys.settingsDifficultyEasy),
  normal(0, LocalizationKeys.settingsDifficultyNormal),
  hard(-1, LocalizationKeys.settingsDifficultyHard);

  final int diceAddition;
  final String localizationKey;

  const DifficultyType(this.diceAddition, this.localizationKey);

  static DifficultyType fromJson(String? value) => DifficultyType.values.firstWhereOrNull((element) => element.toString() == value) ?? DifficultyType.normal;
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
