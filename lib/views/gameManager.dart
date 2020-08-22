import 'dart:ui';

import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/playSettings.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/positions/sprint.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/saveUtil.dart';
import 'package:CyclingEscape/views/menus/creditsView.dart';
import 'package:CyclingEscape/views/menus/helpMenu.dart';
import 'package:CyclingEscape/views/menus/menuBackground.dart';
import 'package:CyclingEscape/views/menus/pauseMenu.dart';
import 'package:CyclingEscape/views/menus/settingsMenu.dart';
import 'package:CyclingEscape/views/menus/tourInBetweenRaces.dart';
import 'package:CyclingEscape/views/menus/tourSelect.dart';
import 'package:CyclingEscape/views/menus/tutorialView.dart';
import 'package:CyclingEscape/views/resultsView.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

import 'baseView.dart';
import 'cyclingView.dart';
import 'menus/courseSelect.dart';
import 'menus/mainMenu.dart';

class GameManager extends Game with ScaleDetector, TapDetector {
  int playerTeam;
  bool loading = true;
  bool resultsViewEndsRace = true;
  Size currentSize;
  double loadingPercentage = 0;
  MainMenu mainmenu;
  HelpMenu helpMenu;
  BaseView currentView;
  Settings settings = Settings();
  PauseMenu pauseMenu;
  ActiveTour activeTour;
  CreditsView credits;
  CyclingView cyclingView;
  ResultsView resultsView;
  TutorialView tutorial;
  SettingsMenu settingsMenu;
  SpriteManager spriteManager;
  MenuBackground menuBackground;
  TourSelectMenu tourSelectMenu;
  TutorialsViewed tutorialsViewed = TutorialsViewed();
  GameManagerState state;
  CourseSelectMenu courseSelectMenu;
  TourInBetweenRacesMenu tourInBetweenRacesMenu;

  GameManager() {
    spriteManager = new SpriteManager();
    cyclingView = new CyclingView(
        spriteManager, cyclingEnded, navigate, settings, openTutorial);
    resultsView = new ResultsView(spriteManager, navigate);
    mainmenu = new MainMenu(spriteManager, navigate);
    helpMenu = new HelpMenu(spriteManager, navigate);
    credits = new CreditsView(spriteManager, navigate);
    pauseMenu = new PauseMenu(spriteManager, navigate);
    tutorial = new TutorialView(spriteManager, navigate);
    courseSelectMenu = new CourseSelectMenu(spriteManager, navigate);
    settingsMenu = new SettingsMenu(spriteManager, navigate, settings);
    tourInBetweenRacesMenu =
        new TourInBetweenRacesMenu(spriteManager, navigate);
    tourSelectMenu = new TourSelectMenu(spriteManager, navigate);
    currentView = mainmenu;
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
      // if (_tutorialsViewed != null) {
      //   tutorialsViewed.typesViewed = _tutorialsViewed.typesViewed;
      // }
      openTutorial(TutorialType.FIRST_OPEN);
    });
  }

  openTutorial(TutorialType type) {
    if (!tutorialsViewed.hasViewed(type)) {
      this.navigate(GameManagerState.TUTORIAL, tutorialType: type);
    }
  }

  void load() {
    spriteManager.loadSprites().whenComplete(() {
      currentView.onAttach();
      // cyclingView.onAttach();
      // resultsView.onAttach();
      // mainmenu.onAttach();
      // credits.onAttach();
      // pauseMenu.onAttach();
      // courseSelectMenu.onAttach();
      // settingsMenu.onAttach();
      // tourInBetweenRacesMenu.onAttach();
      // tourSelectMenu.onAttach();
      if (menuBackground == null) {
        menuBackground = MenuBackground(this.spriteManager);
      }
      loadSettings();
      loading = false;
    });
  }

  @override
  void render(Canvas canvas) {
    if (loading) {
      // print(loadingPercentage);
      Paint bgPaint = Paint()..color = Colors.green[200];
      canvas.drawRect(
          Rect.fromLTRB(0, 0, currentSize.width, currentSize.height), bgPaint);
      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'),
          text: 'Loading... '); // ${loadingPercentage.toStringAsFixed(2)}%
      Offset position = Offset(currentSize.width / 2, currentSize.height / 2);
      CanvasUtils.drawText(canvas, position, 0, span);
    } else {
      switch (state) {
        case GameManagerState.MAIN_MENU:
        case GameManagerState.CREDITS:
        case GameManagerState.RESULTS:
        case GameManagerState.COURSE_SELECT_MENU:
        case GameManagerState.SETTINGS_MENU:
        case GameManagerState.HELP_MENU:
        case GameManagerState.TOUR_SELECT_MENU:
        case GameManagerState.TOUR_BETWEEN_RACES:
        case GameManagerState.TUTORIAL:
          menuBackground.render(canvas, currentSize);
          break;
        case GameManagerState.PAUSED:
        case GameManagerState.PAUSED_RESULTS:
          cyclingView.render(canvas);
          break;
        default:
        // No special rendering
      }
      currentView.render(canvas);
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
        SaveUtil.saveTour(activeTour);
      }
      if (cyclingView != null &&
          !cyclingView.ended &&
          cyclingView.map != null) {
        SaveUtil.saveCyclingView(cyclingView);
      }
    }
  }

  @override
  void update(double t) {
    if (loading) {
      loadingCheck();
      return;
    } else {
      currentView.update(t);
      if (state == GameManagerState.MAIN_MENU ||
          state == GameManagerState.CREDITS ||
          state == GameManagerState.COURSE_SELECT_MENU ||
          state == GameManagerState.SETTINGS_MENU ||
          state == GameManagerState.HELP_MENU ||
          state == GameManagerState.TOUR_SELECT_MENU ||
          state == GameManagerState.TOUR_BETWEEN_RACES ||
          state == GameManagerState.RESULTS) {
        menuBackground.update(t);
      }
    }
  }

  @override
  void onTapUp(TapUpDetails details) {
    if (loading) {
      return;
    }
    currentView.onTapUp(details);
  }

  @override
  void onTapDown(TapDownDetails details) {
    if (loading) {
      return;
    }
    currentView.onTapDown(details);
  }

  @override
  void resize(Size size) {
    currentSize = size;
    currentView.resize(size);
  }

  @override
  void onScaleStart(ScaleStartDetails details) {
    if (loading) {
      return;
    }
    currentView.onScaleStart(details);
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
    if (loading) {
      return;
    }
    currentView.onScaleUpdate(details);
  }

  void navigate(GameManagerState newState,
      {PlaySettings playSettings,
      Tour tourSettings,
      bool deleteActiveTour: false,
      int team,
      bool continueing: false,
      bool save: false,
      bool load: false,
      TutorialType tutorialType}) async {
    if (deleteActiveTour) {
      this.activeTour = null;
      this.tourSelectMenu.selectedTour = null;
      SaveUtil.clearTour();
    }
    if (team != null) {
      playerTeam = team;
    }
    if (save) {
      continueing = true;
    }
    if (this.activeTour != null) {
      SaveUtil.saveTour(activeTour);
    }
    if (this.cyclingView != null &&
        !this.cyclingView.ended &&
        cyclingView.map != null) {
      SaveUtil.saveCyclingView(this.cyclingView);
    }
    if (load) {
      CyclingView newCyclingView = await SaveUtil.loadCyclingView(
          spriteManager, cyclingEnded, navigate, settings, openTutorial);
      if (newCyclingView != null) {
        print('load successful');
        this.cyclingView = newCyclingView;
        newState = GameManagerState.PLAYING;
        continueing = true;
      } else {
        return;
      }
    }
    if (tutorialType != null) {
      newState = GameManagerState.TUTORIAL;
      tutorialsViewed.addViewed(tutorialType);
      tutorial.previousState = this.state;
      tutorial.previousView = this.currentView;
      tutorial.tutorialType = tutorialType;
      tutorial.setText();
    }
    this.state = newState;
    switch (newState) {
      case GameManagerState.MAIN_MENU:
        if (activeTour != null &&
            activeTour.racesDone >= activeTour.tour.races) {
          activeTour = null;
        }
        currentView = mainmenu;
        mainmenu.onAttach();
        break;
      case GameManagerState.CREDITS:
        currentView = credits;
        credits.onAttach();
        break;
      case GameManagerState.COURSE_SELECT_MENU:
        currentView = courseSelectMenu;
        courseSelectMenu.onAttach();
        openTutorial(TutorialType.SINGLE_RACE);
        break;
      case GameManagerState.SETTINGS_MENU:
        currentView = settingsMenu;
        settingsMenu.onAttach();
        openTutorial(TutorialType.SETTINGS);
        break;
      case GameManagerState.HELP_MENU:
        currentView = helpMenu;
        helpMenu.onAttach();
        break;
      case GameManagerState.TOUR_SELECT_MENU:
        this.activeTour = await SaveUtil.loadTour(spriteManager);
        if (activeTour != null) {
          navigate(GameManagerState.TOUR_BETWEEN_RACES);
        } else {
          currentView = tourSelectMenu;
          tourSelectMenu.onAttach();
        }
        openTutorial(TutorialType.TOUR);
        break;
      case GameManagerState.PLAYING:
        currentView = cyclingView;
        resultsViewEndsRace = true;
        if (!continueing) {
          if (tourSettings != null) {
            activeTour = ActiveTour(tourSettings);
          }
          if (playSettings != null) {
            activeTour = null;
            cyclingView.onAttach(playSettings: playSettings, team: playerTeam);
          } else if (activeTour != null) {
            cyclingView.onAttach(activeTour: activeTour, team: playerTeam);
          }
        } else {
          cyclingView.onAttach();
        }
        openTutorial(TutorialType.OPEN_RACE);
        break;
      case GameManagerState.TOUR_BETWEEN_RACES:
        currentView = tourInBetweenRacesMenu;
        tourInBetweenRacesMenu.onAttach(activeTour: activeTour);
        break;
      case GameManagerState.RESULTS:
        currentView = resultsView;
        resultsViewEndsRace = false;
        resultsView.onAttach();
        openTutorial(TutorialType.RANKINGS);
        break;
      case GameManagerState.PAUSED:
        currentView = pauseMenu;
        pauseMenu.onAttach();
        break;
      case GameManagerState.PAUSED_RESULTS:
        currentView = resultsView;
        resultsView.isPaused = true;
        resultsView.onAttach();
        break;
      case GameManagerState.TUTORIAL:
        currentView = tutorial;
        tutorial.onAttach();
        break;
      case GameManagerState.CLOSE_TUTORIAL:
        this.state = tutorial.previousState;
        this.currentView = tutorial.previousView;
        this.currentView.onAttach();
        break;
      default:
      // Do nothing
    }
    resize(currentSize);
  }

  void cyclingEnded(List<Sprint> sprints) {
    this.state = GameManagerState.RESULTS;
    currentView = resultsView;
    resultsView.isPaused = false;
    resultsView.sprints = sprints;
    resultsView.lastResultsAdded = false;
    if (activeTour != null) {
      activeTour.racesDone++;
      resultsView.activeTour = activeTour;
      SaveUtil.saveTour(activeTour);
    }
    resultsView.onAttach();
    resize(currentSize);
    cyclingView = new CyclingView(spriteManager, cyclingEnded, navigate,
        settings, openTutorial); // Clean the CyclingView to be safe
    SaveUtil.clearCyclingView();
  }
}

enum GameManagerState {
  MAIN_MENU,
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
