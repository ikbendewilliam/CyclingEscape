import 'package:cycling_escape/util/locale/localization_keys.dart';

enum CyclistMovementType { fast, normal, slow, skip }

enum CameraMovementType { auto, selectOnly, none }

enum FollowType { follow, autoFollow, leave }

enum MapType { flat, cobble, hills, heavy }

enum MapLength { short, medium, long, veryLong }

enum DifficultyType {
  easy(1),
  normal(0),
  hard(-1);

  final int diceAddition;

  const DifficultyType(this.diceAddition);
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
