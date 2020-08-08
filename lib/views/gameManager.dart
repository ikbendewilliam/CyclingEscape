import 'dart:ui';

import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/playSettings.dart';
import 'package:CyclingEscape/components/data/results.dart';
import 'package:CyclingEscape/components/positions/sprint.dart';
import 'package:CyclingEscape/views/menus/menuBackground.dart';
import 'package:CyclingEscape/views/menus/pauseMenu.dart';
import 'package:CyclingEscape/views/menus/tourInBetweenRaces.dart';
import 'package:CyclingEscape/views/menus/tourSelect.dart';
import 'package:CyclingEscape/views/resultsView.dart';
import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';

import 'baseView.dart';
import 'cyclingView.dart';
import 'menus/courseSelect.dart';
import 'menus/mainMenu.dart';

class GameManager extends Game with ScaleDetector, TapDetector {
  int playerTeam;
  Size currentSize;
  MainMenu mainmenu;
  BaseView currentView;
  PauseMenu pauseMenu;
  CyclingView cyclingView;
  ResultsView resultsView;
  MenuBackground menuBackground;
  GameManagerState state;
  CourseSelectMenu courseSelectMenu;
  TourInBetweenRacesMenu tourInBetweenRacesMenu;
  TourSelectMenu tourSelectMenu;
  ActiveTour activeTour;

  GameManager() {
    cyclingView = new CyclingView(cyclingEnded, menuPressed);
    resultsView = new ResultsView(menuPressed);
    mainmenu = new MainMenu(menuPressed);
    pauseMenu = new PauseMenu(menuPressed);
    courseSelectMenu = new CourseSelectMenu(menuPressed);
    tourInBetweenRacesMenu = new TourInBetweenRacesMenu(menuPressed);
    tourSelectMenu = new TourSelectMenu(menuPressed);
    currentView = mainmenu;
    state = GameManagerState.MAIN_MENU;
  }

  @override
  void onAttach() {
    super.onAttach();
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
  }

  @override
  void render(Canvas canvas) {
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

  @override
  void update(double t) {
    currentView.update(t);
    if (state == GameManagerState.MAIN_MENU ||
        state == GameManagerState.COURSE_SELECT_MENU ||
        state == GameManagerState.TOUR_SELECT_MENU ||
        state == GameManagerState.TOUR_BETWEEN_RACES ||
        state == GameManagerState.RESULTS) {
      menuBackground.update(t);
    }
  }

  @override
  void onTapUp(TapUpDetails details) {
    currentView.onTapUp(details);
  }

  @override
  void onTapDown(TapDownDetails details) {
    currentView.onTapDown(details);
  }

  @override
  void resize(Size size) {
    currentSize = size;
    currentView.resize(size);
  }

  @override
  void onScaleStart(ScaleStartDetails details) {
    currentView.onScaleStart(details);
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
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
