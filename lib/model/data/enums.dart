enum CyclistMovementType { fast, normal, slow, skip }

enum CameraMovementType { auto, selectOnly, none }

enum FollowType { follow, autoFollow, leave }

enum MapType { flat, cobble, hills, heavy }

enum MapLength { short, medium, long, veryLong }

enum DifficultyType { easy, normal, hard }

extension DifficultyTypeExtension on DifficultyType {
  int get diceAddition {
    switch (this) {
      case DifficultyType.easy:
        return 1;
      case DifficultyType.normal:
        return 0;
      case DifficultyType.hard:
        return -1;
    }
  }
}

enum TutorialType {
//   firstOpen(LocalizationKeys.tutorialWelcomeTitle, LocalizationKeys.tutorialWelcomeDescription),
//   career(LocalizationKeys.tutorialCareerTitle, LocalizationKeys.tutorialCareerDescription),
//   careerFirstFinished(LocalizationKeys.tutorialFirstCareerTitle, LocalizationKeys.tutorialFirstCareerDescription),
//   careerUpgrades(LocalizationKeys.tutorialUpgradesTitle, LocalizationKeys.tutorialUpgradesDescription),
//   singleRace(LocalizationKeys.tutorialSingleRaceTitle, LocalizationKeys.tutorialSingleRaceDescription),
//   tour(LocalizationKeys.tutorialTourTitle, LocalizationKeys.tutorialTourDescription),
//   openRace(LocalizationKeys.tutorialOpenRaceTitle, LocalizationKeys.tutorialOpenRaceDescription),
//   throwDice(LocalizationKeys.tutorialThrowDiceTitle, LocalizationKeys.tutorialThrowDiceDescription),
//   selectPosition(LocalizationKeys.tutorialSelectPositionTitle, LocalizationKeys.tutorialSelectPositionDescription),
//   follow(LocalizationKeys.tutorialFollowOrNotTitle, LocalizationKeys.tutorialFollowOrNotDescription),
//   noFollowAvailable(LocalizationKeys.tutorialCantFollowTitle, LocalizationKeys.tutorialCantFollowDescription),
//   followAfterAutoFollow(LocalizationKeys.tutorialStillFollowTitle, LocalizationKeys.tutorialStillFollowDescription),
//   fieldValue(LocalizationKeys.tutorialDifficultTerrainTitle, LocalizationKeys.tutorialDifficultTerrainDescription),
//   fieldValuePositive(LocalizationKeys.tutorialDownhillTitle, LocalizationKeys.tutorialDownhillDescription),
//   sprint(LocalizationKeys.tutorialSprintTitle, LocalizationKeys.tutorialSprintDescription),
//   finish(LocalizationKeys.tutorialFinishTitle, LocalizationKeys.tutorialFinishDescription),
//   rankings(LocalizationKeys.tutorialRankingsTitle, LocalizationKeys.tutorialRankingsDescription),
//   settings(LocalizationKeys.tutorialSettingsTitle, LocalizationKeys.tutorialSettingsDescription),
//   tourFirstFinished(LocalizationKeys.tutorialFirstTourFinishedTitle, LocalizationKeys.tutorialFirstTourFinishedDescription);
  firstOpen,
  career,
  careerFirstFinished,
  careerUpgrades,
  singleRace,
  tour,
  openRace,
  throwDice,
  selectPosition,
  follow,
  noFollowAvailable,
  followAfterAutoFollow,
  fieldValue,
  fieldValuePositive,
  sprint,
  finish,
  rankings,
  settings,
  tourFirstFinished,

//   final String titleKey;
//   final String descriptionKey;

//   const TutorialType(this.titleKey, this.descriptionKey);
}
