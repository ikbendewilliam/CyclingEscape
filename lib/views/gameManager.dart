import 'dart:ui';

import 'package:app_review/app_review.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cycling_escape/components/data/activeTour.dart';
import 'package:cycling_escape/components/data/playSettings.dart';
import 'package:cycling_escape/components/data/resultData.dart';
import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:cycling_escape/components/data/team.dart';
import 'package:cycling_escape/components/positions/sprint.dart';
import 'package:cycling_escape/utils/canvasUtils.dart';
import 'package:cycling_escape/utils/saveUtil.dart';
import 'package:cycling_escape/views/menus/careerMenu.dart';
import 'package:cycling_escape/views/menus/creditsView.dart';
import 'package:cycling_escape/views/menus/helpMenu.dart';
import 'package:cycling_escape/views/menus/info.dart';
import 'package:cycling_escape/views/menus/menuBackground.dart';
import 'package:cycling_escape/views/menus/pauseMenu.dart';
import 'package:cycling_escape/views/menus/settingsMenu.dart';
import 'package:cycling_escape/views/menus/tourInBetweenRaces.dart';
import 'package:cycling_escape/views/menus/tourSelect.dart';
import 'package:cycling_escape/views/menus/tutorialView.dart';
import 'package:cycling_escape/views/resultsView.dart';

import '../components/data/activeTour.dart';
import 'baseView.dart';
import 'cyclingView.dart';
import 'menus/careerUpgrades.dart';
import 'menus/courseSelect.dart';
import 'menus/mainMenu.dart';

class GameManager extends Game with ScaleDetector, TapDetector {
  int? playerTeam;
  bool loading = true;
  bool? inCareer = false;
  bool resultsViewEndsRace = true;
  Size? currentSize;
  double loadingPercentage = 0;
  Career career = Career();
  MainMenu? mainmenu;
  HelpMenu? helpMenu;
  InfoView? info;
  BaseView? currentView;
  Settings settings = Settings();
  PauseMenu? pauseMenu;
  ActiveTour? activeTour;
  CareerMenu? careerMenu;
  CreditsView? credits;
  CyclingView? cyclingView;
  ResultsView? resultsView;
  TutorialView? tutorial;
  SettingsMenu? settingsMenu;
  late SpriteManager spriteManager;
  MenuBackground? menuBackground;
  TourSelectMenu? tourSelectMenu;
  CareerUpgradesMenu? careerUpgrades;
  TutorialsViewed tutorialsViewed = TutorialsViewed();
  GameManagerState? state;
  CourseSelectMenu? courseSelectMenu;
  TourInBetweenRacesMenu? tourInBetweenRacesMenu;
  late AppLocalizations appLocalizations;

  GameManager() {
    spriteManager = SpriteManager();
    state = GameManagerState.MAIN_MENU;
  }

  Future<void> loadSettings() async {
    // get settings
    SaveUtil.loadSettings().then((_settings) {
      if (_settings != null) {
        settings.autofollowAsk = _settings.autofollowAsk;
        settings.autofollowThreshold = _settings.autofollowThreshold;
        settings.cameraMovement = _settings.cameraMovement;
        settings.cyclistMovement = _settings.cyclistMovement;
        settings.difficulty = _settings.difficulty;
      }
    });
    SaveUtil.loadTutorialsViewed().then((_tutorialsViewed) {
      if (_tutorialsViewed != null) {
        tutorialsViewed.typesViewed = _tutorialsViewed.typesViewed;
      }
      openTutorial(TutorialType.FIRST_OPEN);
    });
    SaveUtil.loadCareer().then((_career) {
      if (_career != null) {
        career.riders = _career.riders;
        career.rankingTypes = _career.rankingTypes;
        career.raceTypes = _career.raceTypes;
        career.cash = _career.cash;
      }
    });
  }

  openTutorial(TutorialType type) {
    if (type == TutorialType.TOUR_FIRST_FINISHED) {
      tutorialsViewed.toursFinished++;
      tutorialsViewed.save();
      if (tutorialsViewed.toursFinished == 5) {
        AppReview.requestReview.then((_) {});
      }
    }
    if (!tutorialsViewed.hasViewed(type)) {
      this.navigate(GameManagerState.TUTORIAL, tutorialType: type);
    }
  }

  void load(AppLocalizations appLocalizations) async {
    this.appLocalizations = appLocalizations;
    cyclingView = CyclingView(spriteManager, cyclingEnded, navigate, settings, appLocalizations, openTutorial);
    resultsView = ResultsView(spriteManager, navigate, career, appLocalizations);
    mainmenu = MainMenu(spriteManager, navigate, appLocalizations);
    careerMenu = CareerMenu(spriteManager, navigate, career, appLocalizations);
    careerUpgrades = CareerUpgradesMenu(spriteManager, navigate, career, appLocalizations);
    info = InfoView(spriteManager, navigate, appLocalizations);
    helpMenu = HelpMenu(spriteManager, navigate, appLocalizations);
    credits = CreditsView(spriteManager, navigate, appLocalizations);
    pauseMenu = PauseMenu(spriteManager, navigate, appLocalizations);
    tutorial = TutorialView(spriteManager, navigate, appLocalizations);
    courseSelectMenu = CourseSelectMenu(spriteManager, navigate, appLocalizations);
    settingsMenu = SettingsMenu(spriteManager, navigate, settings, appLocalizations);
    tourInBetweenRacesMenu = TourInBetweenRacesMenu(spriteManager, navigate, appLocalizations);
    tourSelectMenu = TourSelectMenu(spriteManager, navigate, appLocalizations);
    currentView = mainmenu;
    currentView?.resize(currentSize);

    await spriteManager.loadSprites();
    currentView?.onAttach();
    menuBackground ??= MenuBackground(this.spriteManager);
    loadSettings();
    loading = false;
  }

  @override
  void render(Canvas canvas) {
    if (loading) {
      // print(loadingPercentage);
      Paint bgPaint = Paint()..color = Colors.green[200]!;
      canvas.drawRect(Rect.fromLTRB(0, 0, currentSize!.width, currentSize!.height), bgPaint);
      TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: 'Loading... '); // ${loadingPercentage.toStringAsFixed(2)}%
      Offset position = Offset(currentSize!.width / 2, currentSize!.height / 2);
      CanvasUtils.drawText(canvas, position, 0, span);
    } else {
      switch (state) {
        case GameManagerState.MAIN_MENU:
        case GameManagerState.INFO:
        case GameManagerState.CLOSE_INFO:
        case GameManagerState.CAREER_MENU:
        case GameManagerState.CAREER_UPGRADES_MENU:
        case GameManagerState.CREDITS:
        case GameManagerState.RESULTS:
        case GameManagerState.COURSE_SELECT_MENU:
        case GameManagerState.SETTINGS_MENU:
        case GameManagerState.HELP_MENU:
        case GameManagerState.TOUR_SELECT_MENU:
        case GameManagerState.TOUR_BETWEEN_RACES:
        case GameManagerState.TUTORIAL:
          menuBackground!.render(canvas, currentSize);
          break;
        case GameManagerState.PAUSED:
        case GameManagerState.PAUSED_RESULTS:
          cyclingView!.render(canvas);
          break;
        default:
        // No special rendering
      }
      currentView!.render(canvas);
    }
  }

  loadingCheck() {
    if (loading) {
      loadingPercentage = this.spriteManager.checkLoadingPercentage();
      if (loadingPercentage.isNaN) {
        loadingPercentage = 0;
      }
      if (loadingPercentage >= 99.999) {
        loadingPercentage = 100;
      }
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      if (this.activeTour != null) {
        SaveUtil.saveTour(activeTour!);
      }
      if (cyclingView != null && !cyclingView!.ended! && cyclingView!.map != null) {
        SaveUtil.saveCyclingView(cyclingView!);
      }
    }
  }

  @override
  void update(double t) {
    if (loading) {
      loadingCheck();
      return;
    } else {
      currentView!.update(t);
      if (state == GameManagerState.MAIN_MENU ||
          state == GameManagerState.INFO ||
          state == GameManagerState.CLOSE_INFO ||
          state == GameManagerState.CAREER_MENU ||
          state == GameManagerState.CAREER_UPGRADES_MENU ||
          state == GameManagerState.CREDITS ||
          state == GameManagerState.COURSE_SELECT_MENU ||
          state == GameManagerState.SETTINGS_MENU ||
          state == GameManagerState.HELP_MENU ||
          state == GameManagerState.TOUR_SELECT_MENU ||
          state == GameManagerState.TOUR_BETWEEN_RACES ||
          state == GameManagerState.RESULTS) {
        menuBackground!.update(t);
      }
    }
  }

  @override
  void onTapUp(TapUpDetails details) {
    if (loading) {
      return;
    }
    currentView!.onTapUp(details);
  }

  @override
  void onTapDown(TapDownDetails details) {
    if (loading) {
      return;
    }
    currentView!.onTapDown(details);
  }

  @override
  void onResize(Vector2 size) {
    currentSize = Size(size.x, size.y);
    currentView?.resize(Size(size.x, size.y));
    super.onResize(size);
  }

  @override
  void onScaleStart(ScaleStartDetails details) {
    if (loading) {
      return;
    }
    currentView!.onScaleStart(details);
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
    if (loading) {
      return;
    }
    currentView!.onScaleUpdate(details);
  }

  void navigate(GameManagerState newState,
      {PlaySettings? playSettings,
      Tour? tourSettings,
      bool deleteActiveTour: false,
      int? team,
      bool continueing: false,
      bool save: false,
      bool load: false,
      String infoText: '',
      RaceType? careerRaceType,
      TutorialType? tutorialType}) async {
    if (deleteActiveTour) {
      this.activeTour = null;
      this.tourSelectMenu!.selectedTour = null;
      SaveUtil.clearTour();
    }
    if (team != null) {
      playerTeam = team;
    }
    if (save) {
      continueing = true;
    }
    if (this.activeTour != null) {
      SaveUtil.saveTour(activeTour!);
    }
    if (this.cyclingView != null && !this.cyclingView!.ended! && cyclingView!.map != null) {
      SaveUtil.saveCyclingView(this.cyclingView!);
    }
    if (load) {
      CyclingView? newCyclingView = await SaveUtil.loadCyclingView(spriteManager, cyclingEnded, navigate, settings, appLocalizations, openTutorial);
      if (newCyclingView != null) {
        this.cyclingView = newCyclingView;
        newState = GameManagerState.PLAYING;
        continueing = true;
        inCareer = cyclingView!.inCareer;
        if (cyclingView!.careerRaceType != null) {
          careerRaceType = cyclingView!.careerRaceType;
          activeTour = ActiveTour(careerRaceType!.tour, careerRaceType);
        }
      } else {
        return;
      }
    }
    if (tutorialType != null) {
      newState = GameManagerState.TUTORIAL;
      tutorialsViewed.addViewed(tutorialType);
      tutorial = TutorialView(spriteManager, navigate, appLocalizations);
      tutorial!.previousState = this.state;
      tutorial!.previousView = this.currentView;
      tutorial!.tutorialType = tutorialType;
      tutorial!.setText();
    }
    this.state = newState;
    switch (newState) {
      case GameManagerState.MAIN_MENU:
        currentView = mainmenu;
        mainmenu!.onAttach();
        if (activeTour != null && activeTour!.racesDone >= activeTour!.tour!.races) {
          if (inCareer == true) {
            int earnings = calculateEarnings(activeTour!.currentResults!.data, activeTour!.raceType!);
            career.cash += earnings;
            SaveUtil.saveCareer(career);
            navigate(GameManagerState.CAREER_MENU);
            navigate(GameManagerState.INFO, infoText: '${appLocalizations.careerFinishedEarnings} \$$earnings.');
          }
          inCareer = false;
          this.activeTour = null;
          this.tourSelectMenu!.selectedTour = null;
          SaveUtil.clearTour();
          openTutorial(TutorialType.TOUR_FIRST_FINISHED);
        }
        break;
      case GameManagerState.INFO:
        info = InfoView(spriteManager, navigate, appLocalizations);
        info!.previousState = this.state;
        info!.previousView = this.currentView;
        info!.splitLongText(infoText);
        currentView = info;
        info!.onAttach();
        break;
      case GameManagerState.CLOSE_INFO:
        this.state = info!.previousState;
        this.currentView = info!.previousView;
        this.currentView!.onAttach();
        if (this.currentView is InfoView) {
          info = this.currentView as InfoView?;
        }
        break;
      case GameManagerState.CAREER_MENU:
        currentView = careerMenu;
        careerMenu!.onAttach();
        break;
      case GameManagerState.CAREER_UPGRADES_MENU:
        currentView = careerUpgrades;
        careerUpgrades!.onAttach();
        break;
      case GameManagerState.CREDITS:
        currentView = credits;
        credits!.onAttach();
        break;
      case GameManagerState.COURSE_SELECT_MENU:
        currentView = courseSelectMenu;
        courseSelectMenu!.onAttach();
        openTutorial(TutorialType.SINGLE_RACE);
        break;
      case GameManagerState.SETTINGS_MENU:
        currentView = settingsMenu;
        settingsMenu!.onAttach();
        openTutorial(TutorialType.SETTINGS);
        break;
      case GameManagerState.HELP_MENU:
        currentView = helpMenu;
        helpMenu!.onAttach();
        break;
      case GameManagerState.TOUR_SELECT_MENU:
        this.activeTour = await SaveUtil.loadTour(spriteManager);
        if (activeTour != null && !inCareer!) {
          navigate(GameManagerState.TOUR_BETWEEN_RACES);
        } else {
          currentView = tourSelectMenu;
          tourSelectMenu!.onAttach();
        }
        openTutorial(TutorialType.TOUR);
        break;
      case GameManagerState.PLAYING:
        currentView = cyclingView;
        resultsViewEndsRace = true;
        if (!continueing) {
          if (careerRaceType != null) {
            activeTour = ActiveTour(careerRaceType.tour, careerRaceType);
            inCareer = true;
          } else {
            inCareer = false;
          }
          if (tourSettings != null) {
            activeTour = ActiveTour(tourSettings, null);
          }
          if (playSettings != null) {
            activeTour = null;
            cyclingView!.onAttach(playSettings: playSettings, team: playerTeam);
          } else if (activeTour != null) {
            cyclingView!.onAttach(activeTour: activeTour, team: playerTeam, playerRiders: inCareer! ? career.riders : -1);
          }
          cyclingView!.inCareer = inCareer;
        } else {
          cyclingView!.onAttach();
        }
        openTutorial(TutorialType.OPEN_RACE);
        break;
      case GameManagerState.TOUR_BETWEEN_RACES:
        currentView = tourInBetweenRacesMenu;
        tourInBetweenRacesMenu!.onAttach(activeTour: activeTour);
        break;
      case GameManagerState.RESULTS:
        currentView = resultsView;
        resultsViewEndsRace = false;
        resultsView!.onAttach(inCareer);
        openTutorial(TutorialType.RANKINGS);
        break;
      case GameManagerState.PAUSED:
        currentView = pauseMenu;
        pauseMenu!.onAttach();
        break;
      case GameManagerState.PAUSED_RESULTS:
        currentView = resultsView;
        resultsView!.isPaused = true;
        resultsView!.onAttach(inCareer);
        break;
      case GameManagerState.TUTORIAL:
        currentView = tutorial;
        tutorial!.onAttach();
        break;
      case GameManagerState.CLOSE_TUTORIAL:
        this.state = tutorial!.previousState;
        this.currentView = tutorial!.previousView;
        this.currentView!.onAttach();
        if (this.currentView is TutorialView) {
          tutorial = this.currentView as TutorialView?;
        }
        break;
      default:
      // Do nothing
    }
    onResize(Vector2(currentSize!.width, currentSize!.height));
  }

  void cyclingEnded(List<Sprint?> sprints) {
    this.state = GameManagerState.RESULTS;
    currentView = resultsView;
    resultsView!.isPaused = false;
    resultsView!.sprints = sprints;
    resultsView!.lastResultsAdded = false;
    if (activeTour != null) {
      activeTour!.racesDone++;
      resultsView!.activeTour = activeTour;
      SaveUtil.saveTour(activeTour!);
    }
    resultsView!.onAttach(inCareer);
    onResize(Vector2(currentSize!.width, currentSize!.height));
    cyclingView = CyclingView(spriteManager, cyclingEnded, navigate, settings, appLocalizations, openTutorial); // Clean the CyclingView to be safe
    SaveUtil.clearCyclingView();
  }

  int calculateEarnings(List<ResultData?> data, RaceType raceType) {
    data.sort((a, b) => a!.time - b!.time);

    List<ResultData?> timeResults = data;

    List<ResultData> youngResults =
        career.rankingTypes > 4 ? timeResults.where(((element) => element.number! % 10 <= 2) as bool Function(ResultData?)).map((e) => e!.copy()).toList() : [];
    youngResults.sort((a, b) => a.time - b.time);

    List<ResultData> pointsResults =
        career.rankingTypes > 1 ? timeResults.where(((element) => element.points! > 0) as bool Function(ResultData?)).map((e) => e!.copy()).toList() : [];
    pointsResults.sort((a, b) => b.points - a.points);

    List<ResultData> mountainResults =
        career.rankingTypes > 3 ? timeResults.where(((element) => element.mountain! > 0) as bool Function(ResultData?)).map((e) => e!.copy()).toList() : [];
    mountainResults.sort((a, b) => b.mountain - a.mountain);

    List<ResultData> teamResults = [];
    if (career.rankingTypes > 2) {
      List<Team?> teams = timeResults.map((element) => element!.team).toList();
      teams.forEach((team) {
        if (teamResults.where((element) => element.team == team).length == 0) {
          ResultData resultData = ResultData();
          timeResults.where((element) => element!.team == team).forEach((element) => resultData.time += element!.time);
          resultData.team = team;
          teamResults.add(resultData);
        }
      });
    }
    teamResults.sort((a, b) => a.time - b.time);

    int earnings = 0;
    earnings += calculateResultDataEarnings(timeResults, (1 * raceType.earnings!).floor());
    earnings += career.rankingTypes > 4 ? calculateResultDataEarnings(youngResults, (0.5 * raceType.earnings!).floor()) : 0;
    earnings += career.rankingTypes > 1 ? calculateResultDataEarnings(pointsResults, (0.5 * raceType.earnings!).floor()) : 0;
    earnings += career.rankingTypes > 3 ? calculateResultDataEarnings(mountainResults, (0.25 * raceType.earnings!).floor()) : 0;
    earnings += career.rankingTypes > 2 ? calculateResultDataEarnings(teamResults, (0.75 * raceType.earnings!).floor()) : 0;
    return earnings;
  }

  int calculateResultDataEarnings(List<ResultData?> data, int maxEarnings) {
    int earnings = 0;
    data.asMap().forEach((key, element) {
      if (element!.team!.isPlayer!) {
        earnings += (1.0 * maxEarnings / (key + 1)).floor();
      }
    });
    return earnings;
  }
}

enum GameManagerState {
  MAIN_MENU,
  INFO,
  CLOSE_INFO,
  CAREER_MENU,
  CAREER_UPGRADES_MENU,
  COURSE_SELECT_MENU,
  SETTINGS_MENU,
  HELP_MENU,
  TOUR_SELECT_MENU,
  TOUR_BETWEEN_RACES,
  PLAYING,
  PAUSED,
  PAUSED_RESULTS,
  CLOSE_TUTORIAL,
  TUTORIAL,
  RESULTS,
  CREDITS
}
