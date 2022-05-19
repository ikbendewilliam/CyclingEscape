import 'dart:async';

import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/model/gamedata/career.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/screen_game/cycling_view.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class GameListener {
  final int? playerTeam;
  final Career? career;
  final LocalStorage localStorage;
  final Localization localizations;
  final PlaySettings playSettings;
  final VoidCallback onPause;
  final SpriteManager spriteManager;
  final ValueNotifier<bool> isPaused;
  final FollowType Function() onSelectFollow;
  final ValueChanged<TutorialType> openTutorial;
  final ValueChanged<List<Sprint>?> onEndCycling;

  GameListener({
    required this.onPause,
    required this.isPaused,
    required this.playerTeam,
    required this.localStorage,
    required this.onEndCycling,
    required this.openTutorial,
    required this.playSettings,
    required this.localizations,
    required this.spriteManager,
    required this.onSelectFollow,
    this.career,
  });
}

class GameManager with Game, ScaleDetector, TapDetector {
  var _loading = true;
  double loadingPercentage = 0;
  CyclingView? _view;
  GameListener? _listener;
  final _canStartLoading = Completer<void>();

  bool get loading => _loading || _view == null;

  CyclingView get view => _view!;

  Future<void> addListener(GameListener listener) async {
    _listener = listener;
    _view = CyclingView(
      spriteManager: _listener!.spriteManager,
      onEndCycling: _listener!.onEndCycling,
      localStorage: _listener!.localStorage,
      localizations: _listener!.localizations,
      openTutorial: _listener!.openTutorial,
      onSelectFollow: _listener!.onSelectFollow,
      onPause: _onPause,
    );
    _canStartLoading.complete();
  }

  @override
  Future<void>? onLoad() async {
    await _load();
    return super.onLoad();
  }

  Future<void> _load() async {
    await _canStartLoading.future; // Wait for the listener to be added
    view.resize(size.toSize());
    await _listener!.spriteManager.loadSprites();
    view.onAttach(playSettings: _listener!.playSettings);
    _loading = false;
  }

  void _onPause() => _listener?.onPause();

  @override
  void onGameResize(Vector2 size) {
    view.resize(size.toSize());
    super.onGameResize(size);
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
      view.render(canvas);
    }
  }

  void loadingCheck() {
    if (loading && _listener != null) {
      loadingPercentage = _listener!.spriteManager.checkLoadingPercentage();
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
    if (state == AppLifecycleState.inactive && !view.ended! && view.map != null) {
      // SaveUtil.saveCyclingView(view); // TODO: Save cycling view
    }
  }

  @override
  void update(double dt) {
    if (_listener?.isPaused.value != false) return;
    if (loading) {
      loadingCheck();
      return;
    } else {
      view.update(dt);
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    if (loading) return;
    view.onTapUp(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (loading) return;
    view.onTapDown(info);
  }

  void onResize() {
    view.resize(size.toSize());
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    if (loading) return;
    view.onScaleStart(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (loading) return;
    view.onScaleUpdate(info);
  }

  // void navigate(GameManagerState newState,
  //     {PlaySettings? playSettings,
  //     Tour? tourSettings,
  //     bool deleteActiveTour = false,
  //     int? team,
  //     bool continueing = false,
  //     bool save = false,
  //     bool load = false,
  //     String infoText = '',
  //     RaceType? careerRaceType,
  //     TutorialType? tutorialType}) async {
  //   state = newState;
  //   switch (newState) {
  //     case GameManagerState.mainMenu:
  //       currentView = mainmenu;
  //       mainmenu!.onAttach();
  //       if (activeTour != null && activeTour!.racesDone >= activeTour!.tour!.races) {
  //         if (inCareer == true) {
  //           final int earnings = calculateEarnings(activeTour!.currentResults!.data, activeTour!.raceType!);
  //           career.cash += earnings;
  //           SaveUtil.saveCareer(career);
  //           navigate(GameManagerState.careerMenu);
  //           navigate(GameManagerState.info, infoText: '${localizations.careerFinishedEarnings} \$$earnings.');
  //         }
  //         inCareer = false;
  //         activeTour = null;
  //         tourSelectMenu!.selectedTour = null;
  //         await SaveUtil.clearTour();
  //         openTutorial(TutorialType.tourFirstFinished);
  //       }
  //       break;
  //     case GameManagerState.info:
  //       info = InfoView(spriteManager, navigate, localizations);
  //       info!.previousState = state;
  //       info!.previousView = currentView;
  //       info!.splitLongText(infoText);
  //       currentView = info;
  //       info!.onAttach();
  //       break;
  //     case GameManagerState.closeInfo:
  //       state = info!.previousState;
  //       currentView = info!.previousView;
  //       currentView!.onAttach();
  //       if (currentView is InfoView) {
  //         info = currentView as InfoView?;
  //       }
  //       break;
  //     case GameManagerState.courseSelectMenu:
  //       currentView = courseSelectMenu;
  //       courseSelectMenu!.onAttach();
  //       openTutorial(TutorialType.singleRace);
  //       break;
  //     case GameManagerState.settingsMenu:
  //       currentView = settingsMenu;
  //       settingsMenu!.onAttach();
  //       openTutorial(TutorialType.settings);
  //       break;
  //     case GameManagerState.tourSelectMenu:
  //       activeTour = await SaveUtil.loadTour(spriteManager);
  //       if (activeTour != null && !inCareer!) {
  //         navigate(GameManagerState.tourBetweenRaces);
  //       } else {
  //         currentView = tourSelectMenu;
  //         tourSelectMenu!.onAttach();
  //       }
  //       openTutorial(TutorialType.tour);
  //       break;
  //     case GameManagerState.playing:
  //       currentView = cyclingView;
  //       resultsViewEndsRace = true;
  //       if (!continueing) {
  //         if (careerRaceType != null) {
  //           activeTour = ActiveTour(careerRaceType.tour, careerRaceType);
  //           inCareer = true;
  //         } else {
  //           inCareer = false;
  //         }
  //         if (tourSettings != null) {
  //           activeTour = ActiveTour(tourSettings, null);
  //         }
  //         if (playSettings != null) {
  //           activeTour = null;
  // cyclingView!.onAttach(playSettings: playSettings, team: playerTeam);
  //         } else if (activeTour != null) {
  //           cyclingView!.onAttach(activeTour: activeTour, team: playerTeam, playerRiders: inCareer! ? career.riders : -1);
  //         }
  //         cyclingView!.inCareer = inCareer;
  //       } else {
  //         cyclingView!.onAttach();
  //       }
  //       openTutorial(TutorialType.openRace);
  //       break;
  //     case GameManagerState.results:
  //       currentView = resultsView;
  //       resultsViewEndsRace = false;
  //       resultsView!.onAttach(inCareer);
  //       openTutorial(TutorialType.rankings);
  //       break;
  //     case GameManagerState.closeTutorial:
  //       state = tutorial!.previousState;
  //       currentView = tutorial!.previousView;
  //       currentView!.onAttach();
  //       if (currentView is TutorialView) {
  //         tutorial = currentView as TutorialView?;
  //       }
  //       break;
  //     default:
  //     // Do nothing
  //   }
  //   onResize();
  // }

  // void cyclingEnded(List<Sprint?> sprints) {
  //   state = GameManagerState.results;
  //   currentView = resultsView;
  //   resultsView!.isPaused = false;
  //   resultsView!.sprints = sprints;
  //   resultsView!.lastResultsAdded = false;
  //   if (activeTour != null) {
  //     activeTour!.racesDone++;
  //     resultsView!.activeTour = activeTour;
  //     SaveUtil.saveTour(activeTour!);
  //   }
  //   resultsView!.onAttach(inCareer);
  //   onResize();
  //   cyclingView = CyclingView(spriteManager, cyclingEnded, navigate, settings, localizations, openTutorial); // Clean the CyclingView to be safe
  //   SaveUtil.clearCyclingView();
  // }

  // int calculateEarnings(List<ResultData?> data, RaceType raceType) {
  //   data.sort((a, b) => a!.time - b!.time);

  //   final List<ResultData?> timeResults = data;

  //   final List<ResultData> youngResults = career.rankingTypes > 4 ? timeResults.where((element) => (element?.number ?? 0) % 10 <= 2).map((e) => e!.copy()).toList() : [];
  //   youngResults.sort((a, b) => a.time - b.time);

  //   final List<ResultData> pointsResults = career.rankingTypes > 1 ? timeResults.where((element) => (element?.points ?? 0) > 0).map((e) => e!.copy()).toList() : [];
  //   pointsResults.sort((a, b) => b.points - a.points);

  //   final List<ResultData> mountainResults = career.rankingTypes > 3 ? timeResults.where((element) => (element?.mountain ?? 0) > 0).map((e) => e!.copy()).toList() : [];
  //   mountainResults.sort((a, b) => b.mountain - a.mountain);

  //   final List<ResultData> teamResults = [];
  //   if (career.rankingTypes > 2) {
  //     final List<Team?> teams = timeResults.map((element) => element!.team).toList();
  //     for (final team in teams) {
  //       if (teamResults.where((element) => element.team == team).isEmpty) {
  //         final ResultData resultData = ResultData();
  //         timeResults.where((element) => element!.team == team).forEach((element) => resultData.time += element!.time);
  //         resultData.team = team;
  //         teamResults.add(resultData);
  //       }
  //     }
  //   }
  //   teamResults.sort((a, b) => a.time - b.time);

  //   int earnings = 0;
  //   earnings += calculateResultDataEarnings(timeResults, (1 * raceType.earnings!).floor());
  //   earnings += career.rankingTypes > 4 ? calculateResultDataEarnings(youngResults, (0.5 * raceType.earnings!).floor()) : 0;
  //   earnings += career.rankingTypes > 1 ? calculateResultDataEarnings(pointsResults, (0.5 * raceType.earnings!).floor()) : 0;
  //   earnings += career.rankingTypes > 3 ? calculateResultDataEarnings(mountainResults, (0.25 * raceType.earnings!).floor()) : 0;
  //   earnings += career.rankingTypes > 2 ? calculateResultDataEarnings(teamResults, (0.75 * raceType.earnings!).floor()) : 0;
  //   return earnings;
  // }

  // int calculateResultDataEarnings(List<ResultData?> data, int maxEarnings) {
  //   int earnings = 0;
  //   data.asMap().forEach((key, element) {
  //     if (element!.team!.isPlayer!) {
  //       earnings += (1.0 * maxEarnings / (key + 1)).floor();
  //     }
  //   });
  //   return earnings;
  // }
}
