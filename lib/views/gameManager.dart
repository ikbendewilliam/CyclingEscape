import 'dart:ui';

import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/playSettings.dart';
import 'package:CyclingEscape/components/data/results.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/positions/sprint.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/views/menus/menuBackground.dart';
import 'package:CyclingEscape/views/menus/pauseMenu.dart';
import 'package:CyclingEscape/views/menus/tourInBetweenRaces.dart';
import 'package:CyclingEscape/views/menus/tourSelect.dart';
import 'package:CyclingEscape/views/resultsView.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'baseView.dart';
import 'cyclingView.dart';
import 'menus/courseSelect.dart';
import 'menus/mainMenu.dart';

class GameManager extends Game with ScaleDetector, TapDetector {
  int playerTeam;
  bool loading = true;
  Size currentSize;
  double loadingPercentage = 0;
  MainMenu mainmenu;
  BaseView currentView;
  PauseMenu pauseMenu;
  ActiveTour activeTour;
  CyclingView cyclingView;
  ResultsView resultsView;
  SpriteManager spriteManager;
  MenuBackground menuBackground;
  TourSelectMenu tourSelectMenu;
  GameManagerState state;
  CourseSelectMenu courseSelectMenu;
  TourInBetweenRacesMenu tourInBetweenRacesMenu;

  GameManager() {
    spriteManager = new SpriteManager();
    cyclingView = new CyclingView(spriteManager, cyclingEnded, menuPressed);
    resultsView = new ResultsView(spriteManager, menuPressed);
    mainmenu = new MainMenu(spriteManager, menuPressed);
    pauseMenu = new PauseMenu(spriteManager, menuPressed);
    courseSelectMenu = new CourseSelectMenu(spriteManager, menuPressed);
    tourInBetweenRacesMenu =
        new TourInBetweenRacesMenu(spriteManager, menuPressed);
    tourSelectMenu = new TourSelectMenu(spriteManager, menuPressed);
    currentView = mainmenu;
    state = GameManagerState.MAIN_MENU;
  }

  void load() {
    spriteManager.loadSprites().whenComplete(() {
      cyclingView.onAttach();
      resultsView.onAttach();
      mainmenu.onAttach();
      pauseMenu.onAttach();
      courseSelectMenu.onAttach();
      tourInBetweenRacesMenu.onAttach();
      tourSelectMenu.onAttach();
      if (menuBackground == null) {
        menuBackground = MenuBackground();
      }
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
        case GameManagerState.RESULTS:
        case GameManagerState.COURSE_SELECT_MENU:
        case GameManagerState.TOUR_SELECT_MENU:
        case GameManagerState.TOUR_BETWEEN_RACES:
          menuBackground.render(canvas, currentSize);
          break;
        case GameManagerState.PAUSED:
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
  void update(double t) {
    if (loading) {
      loadingCheck();
      return;
    } else {
      currentView.update(t);
      if (state == GameManagerState.MAIN_MENU ||
          state == GameManagerState.COURSE_SELECT_MENU ||
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

  void menuPressed(GameManagerState newState,
      {PlaySettings playSettings,
      Tour tourSettings,
      bool deleteActiveTour,
      Results currentResults,
      int team,
      bool continueing}) {
    // Can be null
    if (deleteActiveTour == true) {
      this.activeTour = null;
      this.tourSelectMenu.selectedTour = null;
    }
    if (team != null) {
      playerTeam = team;
    }
    if (this.activeTour != null && currentResults != null) {
      activeTour.currentResults = currentResults;
      activeTour.racesDone++;
      if (activeTour.racesDone < activeTour.tour.races) {
        newState = GameManagerState.TOUR_BETWEEN_RACES;
      } else {
        activeTour = null;
      }
    }
    this.state = newState;
    switch (newState) {
      case GameManagerState.MAIN_MENU:
        currentView = mainmenu;
        mainmenu.onAttach();
        break;
      case GameManagerState.COURSE_SELECT_MENU:
        currentView = courseSelectMenu;
        courseSelectMenu.onAttach();
        break;
      case GameManagerState.TOUR_SELECT_MENU:
        if (activeTour != null) {
          menuPressed(GameManagerState.TOUR_BETWEEN_RACES);
        } else {
          currentView = tourSelectMenu;
          tourSelectMenu.onAttach();
        }
        break;
      case GameManagerState.PLAYING:
        currentView = cyclingView;
        if (continueing != true) {
          if (tourSettings != null) {
            activeTour = ActiveTour(tourSettings);
          }
          if (playSettings != null) {
            activeTour = null;
            cyclingView.onAttach(playSettings: playSettings, team: playerTeam);
          } else if (activeTour != null) {
            cyclingView.onAttach(activeTour: activeTour, team: playerTeam);
          }
        }
        break;
      case GameManagerState.TOUR_BETWEEN_RACES:
        currentView = tourInBetweenRacesMenu;
        tourInBetweenRacesMenu.onAttach(activeTour: activeTour);
        break;
      case GameManagerState.PAUSED:
        currentView = pauseMenu;
        pauseMenu.onAttach();
        break;
      default:
      // Do nothing
    }
    resize(currentSize);
  }

  void cyclingEnded(List<Sprint> sprints) {
    this.state = GameManagerState.RESULTS;
    currentView = resultsView;
    resultsView.sprints = sprints;
    resultsView.lastResultsAdded = false;
    if (activeTour != null) {
      resultsView.previousResults = activeTour.currentResults;
    }
    resultsView.onAttach();
    resize(currentSize);
    cyclingView = new CyclingView(spriteManager, cyclingEnded,
        menuPressed); // Clean the CyclingView to be safe
  }
}

enum GameManagerState {
  MAIN_MENU,
  COURSE_SELECT_MENU,
  TOUR_SELECT_MENU,
  TOUR_BETWEEN_RACES,
  PLAYING,
  PAUSED,
  RESULTS
}
