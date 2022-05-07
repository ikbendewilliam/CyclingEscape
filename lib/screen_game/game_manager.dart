import 'package:app_review/app_review.dart';
import 'package:cycling_escape/screen_game/base_view.dart';
import 'package:cycling_escape/screen_game/cycling_view.dart';
import 'package:cycling_escape/screen_game/menus/career_menu.dart';
import 'package:cycling_escape/screen_game/menus/career_upgrades.dart';
import 'package:cycling_escape/screen_game/menus/course_select.dart';
import 'package:cycling_escape/screen_game/menus/credits_view.dart';
import 'package:cycling_escape/screen_game/menus/help_menu.dart';
import 'package:cycling_escape/screen_game/menus/info.dart';
import 'package:cycling_escape/screen_game/menus/main_menu.dart';
import 'package:cycling_escape/screen_game/menus/menu_background.dart';
import 'package:cycling_escape/screen_game/menus/pause_menu.dart';
import 'package:cycling_escape/screen_game/menus/settings_menu.dart';
import 'package:cycling_escape/screen_game/menus/tour_in_between_races.dart';
import 'package:cycling_escape/screen_game/menus/tour_select.dart';
import 'package:cycling_escape/screen_game/menus/tutorial_view.dart';
import 'package:cycling_escape/screen_game/results_view.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/active_tour.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

typedef NavigateType = void Function(
  GameManagerState newState, {
  PlaySettings? playSettings,
  Tour? tourSettings,
  bool deleteActiveTour,
  int? team,
  bool continueing,
  bool save,
  bool load,
  String infoText,
  RaceType? careerRaceType,
  TutorialType? tutorialType,
});

class GameManager with Game, ScaleDetector, TapDetector {
  int? playerTeam;
  bool loading = true;
  bool? inCareer = false;
  bool resultsViewEndsRace = true;
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
  TutorialsViewed tutorialsViewed = TutorialsViewed([]);
  GameManagerState? state;
  CourseSelectMenu? courseSelectMenu;
  TourInBetweenRacesMenu? tourInBetweenRacesMenu;
  late Localization localizations;

  GameManager() {
    spriteManager = SpriteManager();
    state = GameManagerState.mainMenu;
  }

  Future<void> loadSettings() async {
    await Future.wait([
      SaveUtil.loadSettings().then((_settings) {
        if (_settings != null) {
          settings.autofollowAsk = _settings.autofollowAsk;
          settings.autofollowThreshold = _settings.autofollowThreshold;
          settings.cameraMovement = _settings.cameraMovement;
          settings.cyclistMovement = _settings.cyclistMovement;
          settings.difficulty = _settings.difficulty;
        }
      }),
      SaveUtil.loadTutorialsViewed().then((_tutorialsViewed) {
        if (_tutorialsViewed != null) {
          tutorialsViewed.typesViewed = _tutorialsViewed.typesViewed;
        }
        openTutorial(TutorialType.firstOpen);
      }),
      SaveUtil.loadCareer().then((_career) {
        if (_career != null) {
          career.riders = _career.riders;
          career.rankingTypes = _career.rankingTypes;
          career.raceTypes = _career.raceTypes;
          career.cash = _career.cash;
        }
      }),
    ]);
  }

  void openTutorial(TutorialType type) {
    if (type == TutorialType.tourFirstFinished) {
      tutorialsViewed.toursFinished++;
      tutorialsViewed.save();
      if (tutorialsViewed.toursFinished == 5) {
        AppReview.requestReview.then((_) {});
      }
    }
    if (!tutorialsViewed.hasViewed(type)) {
      navigate(GameManagerState.tutorial, tutorialType: type);
    }
  }

  void load(Localization localizations) async {
    this.localizations = localizations;
    cyclingView = CyclingView(spriteManager, cyclingEnded, navigate, settings, localizations, openTutorial);
    resultsView = ResultsView(spriteManager, navigate, career, localizations);
    mainmenu = MainMenu(spriteManager, navigate, localizations);
    careerMenu = CareerMenu(spriteManager, navigate, career, localizations);
    careerUpgrades = CareerUpgradesMenu(spriteManager, navigate, career, localizations);
    info = InfoView(spriteManager, navigate, localizations);
    helpMenu = HelpMenu(spriteManager, navigate, localizations);
    credits = CreditsView(spriteManager, navigate, localizations);
    pauseMenu = PauseMenu(spriteManager, navigate, localizations);
    tutorial = TutorialView(spriteManager, navigate, localizations);
    courseSelectMenu = CourseSelectMenu(spriteManager, navigate, localizations);
    settingsMenu = SettingsMenu(spriteManager, navigate, settings, localizations);
    tourInBetweenRacesMenu = TourInBetweenRacesMenu(spriteManager, navigate, localizations);
    tourSelectMenu = TourSelectMenu(spriteManager, navigate, localizations);
    currentView = mainmenu;
  }

  @override
  Future<void> onLoad() async {
    currentView?.resize(size.toSize());
    await spriteManager.loadSprites();
    currentView?.onAttach();
    menuBackground ??= MenuBackground(spriteManager);
    await loadSettings();
    loading = false;
  }

  @override
  void render(Canvas canvas) {
    if (loading) {
      // print(loadingPercentage);
      final Paint bgPaint = Paint()..color = Colors.green[200]!;
      canvas.drawRect(Rect.fromLTRB(0, 0, size.x, size.y), bgPaint);
      const TextSpan span =
          TextSpan(style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: 'Loading... '); // ${loadingPercentage.toStringAsFixed(2)}%
      final Offset position = Offset(size.x / 2, size.y / 2);
      CanvasUtils.drawText(canvas, position, 0, span);
    } else {
      switch (state) {
        case GameManagerState.mainMenu:
        case GameManagerState.info:
        case GameManagerState.closeInfo:
        case GameManagerState.careerMenu:
        case GameManagerState.careerUpgradesMenu:
        case GameManagerState.credits:
        case GameManagerState.results:
        case GameManagerState.courseSelectMenu:
        case GameManagerState.settingsMenu:
        case GameManagerState.helpMenu:
        case GameManagerState.tourSelectMenu:
        case GameManagerState.tourBetweenRaces:
        case GameManagerState.tutorial:
          menuBackground!.render(canvas, size.toSize());
          break;
        case GameManagerState.paused:
        case GameManagerState.pausedResults:
          cyclingView!.render(canvas);
          break;
        default:
        // No special rendering
      }
      currentView!.render(canvas);
    }
  }

  void loadingCheck() {
    if (loading) {
      loadingPercentage = spriteManager.checkLoadingPercentage();
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
      if (activeTour != null) {
        SaveUtil.saveTour(activeTour!);
      }
      if (cyclingView != null && !cyclingView!.ended! && cyclingView!.map != null) {
        SaveUtil.saveCyclingView(cyclingView!);
      }
    }
  }

  @override
  void update(double dt) {
    if (loading) {
      loadingCheck();
      return;
    } else {
      currentView!.update(dt);
      if (state == GameManagerState.mainMenu ||
          state == GameManagerState.info ||
          state == GameManagerState.closeInfo ||
          state == GameManagerState.careerMenu ||
          state == GameManagerState.careerUpgradesMenu ||
          state == GameManagerState.credits ||
          state == GameManagerState.courseSelectMenu ||
          state == GameManagerState.settingsMenu ||
          state == GameManagerState.helpMenu ||
          state == GameManagerState.tourSelectMenu ||
          state == GameManagerState.tourBetweenRaces ||
          state == GameManagerState.results) {
        menuBackground!.update(dt);
      }
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    if (loading) return;
    currentView!.onTapUp(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (loading) return;
    currentView!.onTapDown(info);
  }

  void onResize() {
    currentView?.resize(size.toSize());
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    if (loading) return;
    currentView!.onScaleStart(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (loading) return;
    currentView!.onScaleUpdate(info);
  }

  void navigate(GameManagerState newState,
      {PlaySettings? playSettings,
      Tour? tourSettings,
      bool deleteActiveTour = false,
      int? team,
      bool continueing = false,
      bool save = false,
      bool load = false,
      String infoText = '',
      RaceType? careerRaceType,
      TutorialType? tutorialType}) async {
    if (deleteActiveTour) {
      activeTour = null;
      tourSelectMenu!.selectedTour = null;
      await SaveUtil.clearTour();
    }
    if (team != null) {
      playerTeam = team;
    }
    if (save) {
      continueing = true;
    }
    if (activeTour != null) {
      SaveUtil.saveTour(activeTour!);
    }
    if (cyclingView != null && !cyclingView!.ended! && cyclingView!.map != null) {
      SaveUtil.saveCyclingView(cyclingView!);
    }
    if (load) {
      final CyclingView? newCyclingView = await SaveUtil.loadCyclingView(spriteManager, cyclingEnded, navigate, settings, localizations, openTutorial);
      if (newCyclingView != null) {
        cyclingView = newCyclingView;
        newState = GameManagerState.playing;
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
      newState = GameManagerState.tutorial;
      tutorialsViewed.addViewed(tutorialType);
      tutorial = TutorialView(spriteManager, navigate, localizations);
      tutorial!.previousState = state;
      tutorial!.previousView = currentView;
      tutorial!.tutorialType = tutorialType;
      tutorial!.setText();
    }
    state = newState;
    switch (newState) {
      case GameManagerState.mainMenu:
        currentView = mainmenu;
        mainmenu!.onAttach();
        if (activeTour != null && activeTour!.racesDone >= activeTour!.tour!.races) {
          if (inCareer == true) {
            final int earnings = calculateEarnings(activeTour!.currentResults!.data, activeTour!.raceType!);
            career.cash += earnings;
            SaveUtil.saveCareer(career);
            navigate(GameManagerState.careerMenu);
            navigate(GameManagerState.info, infoText: '${localizations.careerFinishedEarnings} \$$earnings.');
          }
          inCareer = false;
          activeTour = null;
          tourSelectMenu!.selectedTour = null;
          await SaveUtil.clearTour();
          openTutorial(TutorialType.tourFirstFinished);
        }
        break;
      case GameManagerState.info:
        info = InfoView(spriteManager, navigate, localizations);
        info!.previousState = state;
        info!.previousView = currentView;
        info!.splitLongText(infoText);
        currentView = info;
        info!.onAttach();
        break;
      case GameManagerState.closeInfo:
        state = info!.previousState;
        currentView = info!.previousView;
        currentView!.onAttach();
        if (currentView is InfoView) {
          info = currentView as InfoView?;
        }
        break;
      case GameManagerState.careerMenu:
        currentView = careerMenu;
        careerMenu!.onAttach();
        break;
      case GameManagerState.careerUpgradesMenu:
        currentView = careerUpgrades;
        careerUpgrades!.onAttach();
        break;
      case GameManagerState.credits:
        currentView = credits;
        credits!.onAttach();
        break;
      case GameManagerState.courseSelectMenu:
        currentView = courseSelectMenu;
        courseSelectMenu!.onAttach();
        openTutorial(TutorialType.singleRace);
        break;
      case GameManagerState.settingsMenu:
        currentView = settingsMenu;
        settingsMenu!.onAttach();
        openTutorial(TutorialType.settings);
        break;
      case GameManagerState.helpMenu:
        currentView = helpMenu;
        helpMenu!.onAttach();
        break;
      case GameManagerState.tourSelectMenu:
        activeTour = await SaveUtil.loadTour(spriteManager);
        if (activeTour != null && !inCareer!) {
          navigate(GameManagerState.tourBetweenRaces);
        } else {
          currentView = tourSelectMenu;
          tourSelectMenu!.onAttach();
        }
        openTutorial(TutorialType.tour);
        break;
      case GameManagerState.playing:
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
        openTutorial(TutorialType.openRace);
        break;
      case GameManagerState.tourBetweenRaces:
        currentView = tourInBetweenRacesMenu;
        tourInBetweenRacesMenu!.onAttach(activeTour: activeTour);
        break;
      case GameManagerState.results:
        currentView = resultsView;
        resultsViewEndsRace = false;
        resultsView!.onAttach(inCareer);
        openTutorial(TutorialType.rankings);
        break;
      case GameManagerState.paused:
        currentView = pauseMenu;
        pauseMenu!.onAttach();
        break;
      case GameManagerState.pausedResults:
        currentView = resultsView;
        resultsView!.isPaused = true;
        resultsView!.onAttach(inCareer);
        break;
      case GameManagerState.tutorial:
        currentView = tutorial;
        tutorial!.onAttach();
        break;
      case GameManagerState.closeTutorial:
        state = tutorial!.previousState;
        currentView = tutorial!.previousView;
        currentView!.onAttach();
        if (currentView is TutorialView) {
          tutorial = currentView as TutorialView?;
        }
        break;
      default:
      // Do nothing
    }
    onResize();
  }

  void cyclingEnded(List<Sprint?> sprints) {
    state = GameManagerState.results;
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
    onResize();
    cyclingView = CyclingView(spriteManager, cyclingEnded, navigate, settings, localizations, openTutorial); // Clean the CyclingView to be safe
    SaveUtil.clearCyclingView();
  }

  int calculateEarnings(List<ResultData?> data, RaceType raceType) {
    data.sort((a, b) => a!.time - b!.time);

    final List<ResultData?> timeResults = data;

    final List<ResultData> youngResults = career.rankingTypes > 4 ? timeResults.where((element) => (element?.number ?? 0) % 10 <= 2).map((e) => e!.copy()).toList() : [];
    youngResults.sort((a, b) => a.time - b.time);

    final List<ResultData> pointsResults = career.rankingTypes > 1 ? timeResults.where((element) => (element?.points ?? 0) > 0).map((e) => e!.copy()).toList() : [];
    pointsResults.sort((a, b) => b.points - a.points);

    final List<ResultData> mountainResults = career.rankingTypes > 3 ? timeResults.where((element) => (element?.mountain ?? 0) > 0).map((e) => e!.copy()).toList() : [];
    mountainResults.sort((a, b) => b.mountain - a.mountain);

    final List<ResultData> teamResults = [];
    if (career.rankingTypes > 2) {
      final List<Team?> teams = timeResults.map((element) => element!.team).toList();
      for (final team in teams) {
        if (teamResults.where((element) => element.team == team).isEmpty) {
          final ResultData resultData = ResultData();
          timeResults.where((element) => element!.team == team).forEach((element) => resultData.time += element!.time);
          resultData.team = team;
          teamResults.add(resultData);
        }
      }
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
  mainMenu,
  info,
  closeInfo,
  careerMenu,
  careerUpgradesMenu,
  courseSelectMenu,
  settingsMenu,
  helpMenu,
  tourSelectMenu,
  tourBetweenRaces,
  playing,
  paused,
  pausedResults,
  closeTutorial,
  tutorial,
  results,
  credits
}
