import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/screen_game/base_view.dart';
import 'package:cycling_escape/screen_game/cycling_view_ui.dart';
import 'package:cycling_escape/util/audio/audio_controller.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/map/map_utils.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/cyclist_place.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/moveable/cyclist.dart';
import 'package:cycling_escape/widget_game/moveable/dice.dart';
import 'package:cycling_escape/widget_game/positions/game_map.dart';
import 'package:cycling_escape/widget_game/positions/position.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart' hide PositionType;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

typedef SelectFollow = Future<FollowType> Function(int minThrow);

class CyclingView extends BaseView implements PositionListener, DiceListener {
  int? diceValue;
  int? currentTurn = 0;
  var grid = false;
  var ended = false;
  var moving = false;
  var autoFollow = false;
  var hasResults = false;
  var openFollowSelect = false;
  Dice? dice, dice2;
  Size? worldSize = const Size(1, 1);
  Size? mapSize = const Size(1, 1);
  Sprite? backgroundNotification;
  Sprite? backgroundText;
  Sprite? grass;
  Sprite? grass2;
  Sprite? iconTime;
  Sprite? iconRank;
  Sprite? iconPoints;
  Sprite? iconMountain;
  Offset offsetStart = Offset.zero;
  Offset offset = Offset.zero;
  double zoom = 0.5;
  double? zoomStart;
  double movingTimer = 0;
  double maxZoom = 1.5;
  double minZoom = 0.2;
  double tileSize = 1;
  double? cyclistMoved;
  double diceValueCooldown = 0;
  GameMap? map;
  Cyclist? movingCyclist;
  Results? tempResults;
  Results? startResults;
  Position? cyclistSelected;
  Position? cyclistLastSelected;
  var gameState = GameState.gameSelectNext;

  List<Team?>? teams = [];
  List<Button> buttons = [];
  List<Position?>? moveAnimation = [];
  List<Notification> notifications = [];
  final LocalStorage localStorage;
  final VoidCallback onPause;
  final Localization localizations;
  final ValueChanged<List<Sprint>?> onEndCycling;
  final ValueChanged<TutorialType> openTutorial;
  final SelectFollow onSelectFollow;

  CyclingView({
    required super.spriteManager,
    required this.onEndCycling,
    required this.localStorage,
    required this.localizations,
    required this.openTutorial,
    required this.onPause,
    required this.onSelectFollow,
  });

  @override
  void onAttach({
    required PlaySettings playSettings,
    int? team,
  }) {
    final currentResults = playSettings.tourResults;
    if (map == null) {
      map = MapUtils.generateMap(playSettings, this, spriteManager);
      mapSize = map!.mapSize;
      if (currentResults != null) {
        if (currentResults.data.isNotEmpty) {
          startResults = currentResults.copy();
          hasResults = true;
        } else {
          hasResults = false;
        }
        teams = [];
        for (int i = 0; i < playSettings.teams; i++) {
          if (team != null) {
            if (i == 0) {
              teams!.add(Team(true, team, spriteManager));
            } else {
              teams!.add(Team(false, i == team ? 0 : i, spriteManager));
            }
          } else {
            teams!.add(Team(i == 0, i, spriteManager));
          }
        }
        tempResults = Results(ResultsType.race);
        currentResults.data.asMap().forEach((key, value) => {value.rank = key});
        final cyclists = <Cyclist>[];
        final maxCyclists = playSettings.teams * playSettings.ridersPerTeam;
        for (var i = 0; i < maxCyclists; i++) {
          final teamIndex = (i / playSettings.ridersPerTeam).floor();
          final cyclist = Cyclist(teams![teamIndex], (2 + teams![teamIndex]!.numberStart!) * 10 + (teams![teamIndex]!.cyclists.length + 1), 1, spriteManager);

          cyclist.rank = currentResults.data.firstWhereOrNull((element) => element.number == cyclist.number)?.rank ?? i;
          cyclist.wearsYellowJersey = (cyclist.rank == 0);
          cyclist.wearsWhiteJersey = currentResults.whiteJersey == cyclist.number;
          cyclist.wearsGreenJersey = currentResults.greenJersey == cyclist.number;
          cyclist.wearsBouledJersey = currentResults.bouledJersey == cyclist.number;

          cyclists.add(cyclist);
          teams![teamIndex]!.cyclists.add(cyclist);
          tempResults!.data.add(ResultData(playSettings.teams * playSettings.ridersPerTeam - i, 0, 0, 0, cyclist.number, cyclist.team));
        }
        cyclists.sort((a, b) => b.rank! - a.rank!);

        for (final entry in cyclists.asMap().entries) {
          if (map!.positions.length < entry.key) continue; // Out of bounds
          map!.positions[entry.key].addCyclist(entry.value);
          entry.value.lastPosition = map!.positions[entry.key];
        }
      } else {
        hasResults = false;
        teams = [];
        for (int i = 0; i < playSettings.teams; i++) {
          if (team != null) {
            if (i == 0) {
              teams!.add(Team(true, team, spriteManager));
            } else {
              teams!.add(Team(false, i == team ? 0 : i, spriteManager));
            }
          } else {
            teams!.add(Team(i == 0, i, spriteManager));
          }
        }
        tempResults = Results(ResultsType.race);
        teams?.shuffle();
        for (var i = 0; i < playSettings.teams * playSettings.ridersPerTeam; i++) {
          final teamIndex = (i - (i / playSettings.teams).floor()) % playSettings.teams;
          final cyclist = Cyclist(teams![teamIndex], (2 + teams![teamIndex]!.numberStart!) * 10 + (teams![teamIndex]!.cyclists.length + 1), 1, spriteManager);
          tempResults!.data.add(ResultData(playSettings.teams * playSettings.ridersPerTeam - i, 0, 0, 0, cyclist.number, cyclist.team));
          teams![teamIndex]!.cyclists.add(cyclist);
          map!.positions[i].addCyclist(cyclist);
        }
      }
      currentTurn = 0;
      ended = false;
      autoFollow = false;
      offsetStart = Offset.zero;
      offset = Offset.zero;
      zoom = 0.5;
      notifications = [];
      minZoom = 0.2;
      handleInBetweenTurns();
      processGameState(GameState.gameSelectNext);
    }
    createButtons(screenSize != null ? screenSize!.height / 7 : 10);
    if (openFollowSelect) processGameState(GameState.userWaitCyclistFollow);
    grass ??= spriteManager.getSprite('environment/grass.png');
    grass2 ??= spriteManager.getSprite('environment/grass2.png');
    backgroundNotification ??= spriteManager.getSprite('back_text_04.png');
    backgroundText ??= spriteManager.getSprite('back_text_05.png');
    iconTime ??= spriteManager.getSprite('icon_time.png');
    iconRank ??= spriteManager.getSprite('icon_rank.png');
    iconPoints ??= spriteManager.getSprite('icon_points.png');
    iconMountain ??= spriteManager.getSprite('icon_mountain.png');
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(offset.dx * zoom, offset.dy * zoom);
    canvas.scale(zoom);
    if (grass != null && grass2 != null) {
      for (int i = -(offset.dx / tileSize).ceil(); i < -(offset.dx / tileSize).floor() + screenSize!.width / tileSize / zoom; i++) {
        for (int j = -(offset.dy / tileSize).ceil(); j < -(offset.dy / tileSize).floor() + screenSize!.height / tileSize / zoom; j++) {
          Sprite? g = grass;
          if ((i * j + i + j) % 5 == 0 || (i * j + i + j) % 7 == 0) {
            g = grass2;
          }
          g!.render(canvas, position: Vector2(i * tileSize, j * tileSize), size: Vector2(tileSize * 1.05, tileSize * 1.05));
        }
      }
    }

    if (grid) {
      for (int i = 0; i < worldSize!.width; i++) {
        final Paint paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawLine(Offset(i * tileSize, 0), Offset(i * tileSize, worldSize!.height), paint);
      }

      for (int i = 0; i < worldSize!.height; i++) {
        final Paint paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawLine(Offset(0, i * tileSize), Offset(worldSize!.width, i * tileSize), paint);
      }
    }

    final Offset center =
        Offset(-(offset.dx / tileSize).ceil() + screenSize!.width / tileSize / zoom / 2, -(offset.dy / tileSize).ceil() + screenSize!.height / tileSize / zoom / 2);

    final double screenRange = screenSize!.width * 1.2 / zoom;
    map?.render(canvas, tileSize, center, screenRange);
    movingCyclist?.render(canvas, movingCyclist!.movingOffset! * tileSize, tileSize / 3, movingCyclist!.movingAngle);
    canvas.restore();

    CyclingViewUI.render(
      canvas: canvas,
      tileSize: tileSize,
      screenSize: screenSize,
      dice: dice,
      dice2: dice2,
      buttons: buttons,
      notifications: notifications,
      backgroundNotification: backgroundNotification,
      backgroundText: backgroundText,
      iconTime: iconTime,
      iconRank: iconRank,
      iconPoints: iconPoints,
      iconMountain: iconMountain,
      cyclist: movingCyclist ?? cyclistSelected!.cyclist,
      tempResults: tempResults,
      diceValueCooldown: diceValueCooldown,
      diceValue: diceValue,
    );
  }

  @override
  void update(double t) {
    map!.update(t);

    if (diceValueCooldown > 0) {
      diceValueCooldown -= t;
    }

    dice?.update(t);
    dice2?.update(t);
    if (moving) {
      final startTimer = localStorage.cyclistMovement.timerDuration;
      if (movingTimer == -1) {
        movingTimer = startTimer;
      } else {
        movingTimer -= t;
      }
      movingCyclist?.moveTo(max(0, 1 - movingTimer / startTimer), moveAnimation);
      if (movingCyclist?.movingOffset!.isFinite == true && localStorage.cameraMovement == CameraMovementType.auto) {
        offset = -(movingCyclist!.movingOffset! * tileSize - Offset(screenSize!.width, screenSize!.height) / 2 / zoom);
      }
      if (movingTimer <= 0) {
        processGameState(GameState.userWaitCyclistMovingFinished);
      }
    }
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    tileSize = screenSize!.height / 9;
    worldSize = Size(tileSize * mapSize!.width, tileSize * mapSize!.height);
    if (screenSize!.width / worldSize!.width > minZoom) {
      minZoom = screenSize!.width / worldSize!.width;
    }
    if (screenSize!.height / worldSize!.height > minZoom) {
      minZoom = screenSize!.height / worldSize!.height;
    }
    if (cyclistSelected != null) {
      offset = -((cyclistSelected!.p1 + cyclistSelected!.p2) / 2 * tileSize - Offset(screenSize!.width, screenSize!.height) / 2 / zoom);
      checkBounds();
    }
    createButtons(screenSize!.height / 7);
    for (final element in buttons) {
      element.setScreenSize(size!);
    }
  }

  void createButtons(double buttonSize) {
    buttons = [];
    buttons.add(Button(spriteManager, Offset(buttonSize / 2 + 5, screenSize!.height - buttonSize / 2 - 5), ButtonType.iconPause, onPause));
    if (hasResults) {
      buttons.add(Button(spriteManager, Offset(buttonSize / 2 * 3.2 + 5, screenSize!.height - buttonSize / 2 - 5), ButtonType.iconResults, onPause));
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    bool pressed = false;
    for (final button in buttons) {
      pressed = pressed || button.onTapUp(info);
    }
    if (pressed) {
      return;
    }

    switch (gameState) {
      case GameState.userInputDiceStart:
        startDice();
        processGameState(GameState.userWaitDiceRolling);
        break;
      case GameState.userInputDiceDone:
        removeDice();
        processGameState(GameState.userInputPositionChoice);
        break;
      case GameState.userInputPositionChoice:
        if (cyclistSelected != null) {
          map!.clickedEvent((-offset + info.raw.globalPosition / zoom) / tileSize);
        }
        break;
      default:
      // Do nothing
    }
  }

  void updateResults() {
    if (cyclistSelected == null || cyclistSelected!.cyclist == null) {
      return;
    }
    var useStartResults = false;
    ResultData? startResult;
    map!.positions.where((element) => element.cyclist != null).toList().forEach((cyclistPosition) {
      if (startResults != null) {
        useStartResults = true;
        startResult = startResults!.data.firstWhereOrNull((element) => element.number == cyclistPosition.cyclist!.number);
      }
      final result = tempResults!.data.firstWhereOrNull(((element) => element.number == cyclistPosition.cyclist!.number));
      if (result != null) {
        result.time = (useStartResults ? startResult!.time : 0) + currentTurn!;
        result.value = useStartResults ? 100.0 - startResult!.rank : cyclistPosition.getValue(false);
        if (useStartResults && result.points < startResult!.points) {
          result.points += startResult!.points;
        }
        if (useStartResults && result.mountain < startResult!.mountain) {
          result.mountain += startResult!.mountain;
        }
      }
    });
    tempResults!.data.sort((a, b) => ((a.time == b.time ? b.value! - a.value! : a.time - b.time) * 100).round());
    tempResults!.data.asMap().forEach((key, value) {
      value.rank = key + 1;
    });
  }

  Future<void> processGameState(GameState newState) async {
    if (ended) return;
    gameState = newState;
    switch (gameState) {
      case GameState.userWaitCyclistMoving:
        moving = true;
        movingTimer = -1;
        movingCyclist = moveAnimation!.first!.removeCyclist();
        movingCyclist!.moveTo(0, moveAnimation);
        break;
      case GameState.userWaitCyclistMovingFinished:
        moving = false;
        cyclistLastSelected = moveAnimation!.first;
        cyclistSelected = moveAnimation!.last;
        cyclistSelected!.addCyclist(movingCyclist);
        cyclistSelected!.cyclist?.lastUsedOnTurn = (cyclistSelected!.cyclist!.lastUsedOnTurn ?? 0) + 1;
        movingCyclist = null;
        unawaited(processGameState(GameState.userWaitCyclistFollow));
        break;
      case GameState.userWaitCyclistFollow:
        var following = false;
        final minThrow = canFollow();
        final placeBefore = getPlaceBefore();
        if (minThrow <= 0 && placeBefore?.cyclist?.team?.isPlayer == true) {
          openTutorial(TutorialType.noFollowAvailable);
        } else if (minThrow > 0) {
          if (placeBefore!.cyclist!.team!.isPlayer!) {
            openTutorial(TutorialType.follow);
          }
          if ((minThrow >= 7 && !placeBefore.cyclist!.team!.isPlayer!) ||
              (minThrow >= localStorage.autofollowThreshold && (autoFollow || !localStorage.autofollowThresholdAboveAsk) && placeBefore.cyclist!.team!.isPlayer!)) {
            following = true;
            follow();
            unawaited(processGameState(GameState.userWaitCyclistMoving));
          } else if (placeBefore.cyclist!.team!.isPlayer! && !autoFollow && (minThrow >= localStorage.autofollowThreshold || localStorage.autofollowThresholdBelowAsk)) {
            openFollowSelect = true;
            final returnValue = await onSelectFollow(minThrow);
            switch (returnValue) {
              case FollowType.autoFollow:
                autoFollow = true;
                if (minThrow >= localStorage.autofollowThreshold) {
                  follow();
                  unawaited(processGameState(GameState.userWaitCyclistMoving));
                } else {
                  unawaited(processGameState(GameState.gameSelectNext));
                }
                break;
              case FollowType.follow:
                follow();
                unawaited(processGameState(GameState.userWaitCyclistMoving));
                break;
              case FollowType.leave:
                unawaited(processGameState(GameState.gameSelectNext));
            }
            following = true;
            openFollowSelect = false;
          }
          if (autoFollow) openTutorial(TutorialType.follow);
        }
        if (!following) unawaited(processGameState(GameState.gameSelectNext));

        break;
      case GameState.gameSelectNext:
        selectNextCyclist();
        break;
      case GameState.userInputPositionChoice:
        map!.setState(PositionState.notSelectable);
        cyclistSelected!.setState(PositionState.selectable, max(0, diceValue! + cyclistSelected!.fieldValue), [], cyclistSelected!.cyclist);
        if (!cyclistSelected!.cyclist!.team!.isPlayer!) {
          selectPosition(MapUtils.findMaxValue(cyclistSelected, max(0, diceValue! + cyclistSelected!.fieldValue)));
        } else {
          openTutorial(TutorialType.selectPosition);
        }
        break;
      case GameState.userInputDiceStart:
        if (!cyclistSelected!.cyclist!.team!.isPlayer!) {
          startDice();
          unawaited(processGameState(GameState.userWaitDiceRolling));
        } else {
          openTutorial(TutorialType.throwDice);
          if (cyclistSelected!.fieldValue < 0) {
            openTutorial(TutorialType.fieldValue);
          } else if (cyclistSelected!.fieldValue > 0) {
            openTutorial(TutorialType.fieldValuePositive);
          }
        }
        break;
      case GameState.userInputDiceDone:
        if (!cyclistSelected!.cyclist!.team!.isPlayer!) {
          removeDice();
          unawaited(processGameState(GameState.userInputPositionChoice));
        }
        break;
      default:
      // Do nothing
    }
  }

  // -1 if you cannot follow, int for min to throw to follow
  int canFollow() {
    final placeBefore = getPlaceBefore();
    if (placeBefore == null || placeBefore.cyclist == null) {
      return -1;
    }
    final routeBeforeEnd = MapUtils.findPlaceBefore(cyclistSelected, cyclistMoved, true, startPosition: placeBefore);
    if (routeBeforeEnd.isEmpty) {
      return -1;
    }
    if (cyclistLastSelected!.positionType == PositionType.downhill && placeBefore.positionType == PositionType.uphill) {
      return -1;
    }
    return max(routeBeforeEnd.length - 1 - placeBefore.fieldValue.floor(), 0);
  }

  Position? getPlaceBefore() {
    return MapUtils.findPlaceBefore(cyclistLastSelected, 9999, false, positions: map!.positions).lastWhereOrNull((element) => true);
  }

  void follow() {
    final lastSelectedAccent = getPlaceBefore();
    if (lastSelectedAccent == null || lastSelectedAccent.cyclist == null) {
      return;
    }
    moveAnimation = MapUtils.findPlaceBefore(cyclistSelected, cyclistMoved, true, startPosition: lastSelectedAccent);
  }

  void addNotification(String text, Color color) {
    notifications.add(Notification(text, color));
  }

  bool handleInBetweenTurns() {
    bool removed = false;
    for (final position in map!.positions) {
      if (position.cyclist != null) {
        if (position.cyclist!.lastPosition != null) {
          List<Sprint?> sprints = MapUtils.getSprintsBetween(position.cyclist!.lastPosition!, position);
          sprints = sprints.where((element) => element!.cyclistPlaces.firstWhereOrNull((CyclistPlace? x) => x!.cyclist!.number == position.cyclist!.number) == null).toList();
          for (final sprint in sprints) {
            sprint!.addCyclistPlace(CyclistPlace(position.cyclist, position.getValue(true)));
          }
          if (sprints.isNotEmpty) {
            if (sprints.firstWhereOrNull((s) => s!.type == SprintType.finish) != null) {
              openTutorial(TutorialType.finish);
              position.removeCyclist(); // Remove cyclist when finished
              removed = true;
            } else if (sprints.firstWhereOrNull((s) => s!.type == SprintType.mountainSprint || s.type == SprintType.sprint) != null) {
              openTutorial(TutorialType.sprint);
            }
          }
        }
        if (position.cyclist != null) {
          position.cyclist!.lastPosition = position;
        }
      }
    }
    map!.sprints!.where((sprint) => sprint.type != SprintType.start).forEach((sprint) {
      sprint.cyclistPlaces.sort((a, b) => (b!.value! - a!.value!).round());
      sprint.cyclistPlaces.asMap().forEach((key, element) {
        if (!element!.displayed!) {
          element.displayed = true;
          if (sprint.type == SprintType.finish) {
            addNotification('${element.cyclist!.number} Finished ${th(key + 1)}', element.cyclist!.team!.getColor());
          } else if (sprint.getPoints(key) > 0) {
            final result = tempResults!.data.firstWhereOrNull(((r) => r.number == element.cyclist!.number));
            if (result != null) {
              switch (sprint.type) {
                case SprintType.mountainSprint:
                  result.mountain += sprint.getPoints(key);
                  break;
                case SprintType.sprint:
                  result.points += sprint.getPoints(key);
                  break;
                default:
                // Do nothing
              }
            }
            addNotification('${element.cyclist!.number} ${localizations.raceGained} ${sprint.getPoints(key)} ${sprint.getPointsName()}', element.cyclist!.team!.getColor());
          }
        }
      });
    });
    return removed;
  }

  String th(int number) {
    if (number == 1) {
      return '1st';
    } else if (number == 2) {
      return '2nd';
    } else if (number == 3) {
      return '3rd';
    } else {
      return '${number}th';
    }
  }

  void selectNextCyclist() {
    Position? nextPosition;
    double nextValue = 0;
    map!.positions.where((element) => element.cyclist != null).forEach((positionWithCyclist) {
      final value = positionWithCyclist.getValue(true);
      if (nextValue < value || nextPosition == null) {
        nextValue = value;
        nextPosition = positionWithCyclist;
      }
      map!.setState(PositionState.normal);
      cyclistSelected = nextPosition;
    });
    if (nextPosition == null || cyclistSelected!.cyclist == null) {
      // No more cyclist -> Race ended
      onEndCycling(map!.sprints);
      ended = true;
    } else if (!ended) {
      updateResults();
      cyclistSelected!.setState(PositionState.notSelectable);
      if (cyclistSelected!.cyclist!.lastUsedOnTurn! > currentTurn!) {
        currentTurn = cyclistSelected!.cyclist!.lastUsedOnTurn;
        notifications = [];
        if (handleInBetweenTurns()) {
          selectNextCyclist();
        }
      }
      dice = Dice(spriteManager, this, difficulty: localStorage.difficulty, isPlayer: cyclistSelected?.cyclist?.team?.isPlayer);
      dice2 = Dice(spriteManager, this, difficulty: localStorage.difficulty, isPlayer: cyclistSelected?.cyclist?.team?.isPlayer);
      if (screenSize != null) {
        if (localStorage.cameraMovement != CameraMovementType.none) {
          offset = -((cyclistSelected!.p1 + cyclistSelected!.p2) / 2 * tileSize - Offset(screenSize!.width, screenSize!.height) / 2 / zoom);
          checkBounds();
        }
      }
      processGameState(GameState.userInputDiceStart);
    }
  }

  void startDice() {
    GetIt.I<AudioController>().playDice();
    dice!.start();
    dice2!.start();
  }

  void removeDice() {
    dice = null;
    dice2 = null;
    diceValueCooldown = 2.5;
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    offsetStart = info.raw.focalPoint / zoom - offset;
    zoomStart = zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    for (final button in buttons) {
      button.onTapDown(info.raw.focalPoint);
    }
    offset = info.raw.focalPoint / zoom - offsetStart;
    zoom = zoomStart! * info.raw.scale;
    checkBounds();
  }

  void checkBounds() {
    zoom = zoom.clamp(minZoom, maxZoom);
    if (offset.dx > worldSize!.width - screenSize!.width / zoom) {
      offset += Offset(offset.dx - worldSize!.width + screenSize!.width / zoom, 0);
    }
    if (offset.dy > worldSize!.height - screenSize!.height / zoom) {
      offset += Offset(0, offset.dy - worldSize!.height + screenSize!.height / zoom);
    }
    if (-offset.dx < 0) {
      offset -= Offset(offset.dx, 0);
    }
    if (-offset.dy < 0) {
      offset -= Offset(0, offset.dy);
    }
  }

  @override
  void selectPosition(List<Position?>? route) {
    if (cyclistSelected != null) {
      moveAnimation = route;
      cyclistMoved = route!.length.toDouble() - 1;
      map!.setState(PositionState.normal);
      processGameState(GameState.userWaitCyclistMoving);
    }
  }

  @override
  void diceStopped() {
    diceValue = dice!.getValue() + dice2!.getValue();
    if (gameState == GameState.userWaitDiceRolling2) {
      processGameState(GameState.userInputDiceDone);
    } else {
      processGameState(GameState.userWaitDiceRolling2);
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    for (final button in buttons) {
      button.onTapDown(info.raw.globalPosition);
    }
  }

  static CyclingView? fromJson({
    required Map<String, dynamic>? json,
    required SpriteManager spriteManager,
    required LocalStorage localStorage,
    required VoidCallback onPause,
    required Localization localizations,
    required ValueChanged<List<Sprint>?> onEndCycling,
    required ValueChanged<TutorialType> openTutorial,
    required SelectFollow onSelectFollow,
  }) {
    final existingPositions = <Position?>[];
    final existingSprints = <Sprint?>[];
    final existingCyclists = <Cyclist?>[];
    final existingTeams = <Team?>[];
    if (json == null || json['map'] == null) return null;

    final cyclingView = CyclingView(
      spriteManager: spriteManager,
      onEndCycling: onEndCycling,
      localStorage: localStorage,
      localizations: localizations,
      openTutorial: openTutorial,
      onPause: onPause,
      onSelectFollow: onSelectFollow,
    );
    if (json['teams'] != null) {
      cyclingView.teams = [];
      for (final j in json['teams']) {
        cyclingView.teams!.add(Team.fromJson(j as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager));
      }
    }
    cyclingView.map = GameMap.fromJson(json['map'] as Map<String, dynamic>?, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, cyclingView);
    cyclingView.diceValue = json['diceValue'] as int?;
    cyclingView.currentTurn = json['currentTurn'] as int?;
    cyclingView.grid = json['grid'] == true;
    cyclingView.ended = json['ended'] as bool;
    cyclingView.moving = json['moving'] as bool;
    cyclingView.autoFollow = json['autoFollow'] as bool;
    cyclingView.hasResults = json['hasResults'] as bool;
    cyclingView.openFollowSelect = json['openFollowSelect'] as bool;
    cyclingView.dice = Dice.fromJson(json['dice'] as Map<String, dynamic>?, cyclingView, spriteManager);
    cyclingView.dice2 = Dice.fromJson(json['dice2'] as Map<String, dynamic>?, cyclingView, spriteManager);
    cyclingView.worldSize = SaveUtil.sizeFromJson(json['worldSize'] as Map<String, dynamic>?);
    cyclingView.mapSize = SaveUtil.sizeFromJson(json['mapSize'] as Map<String, dynamic>?);
    cyclingView.offset = SaveUtil.offsetFromJson(json['offset'] as Map<String, dynamic>?)!;
    cyclingView.zoom = json['zoom'] as double;
    cyclingView.movingTimer = json['movingTimer'] as double;
    cyclingView.tileSize = json['tileSize'] as double? ?? 1.0;
    cyclingView.cyclistMoved = json['cyclistMoved'] as double?;
    cyclingView.diceValueCooldown = json['diceValueCooldown'] as double;
    cyclingView.movingCyclist = Cyclist.fromJson(json['movingCyclist'] as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager);
    cyclingView.tempResults = Results.fromJson(json['tempResults'] as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager);
    cyclingView.startResults = Results.fromJson(json['startResults'] as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager);
    cyclingView.cyclistSelected =
        Position.fromJson(json['cyclistSelected'] as Map<String, dynamic>?, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, cyclingView);
    cyclingView.cyclistLastSelected =
        Position.fromJson(json['cyclistLastSelected'] as Map<String, dynamic>?, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, cyclingView);
    cyclingView.gameState = getGameStateFromString(json['gameState'] as String?);

    if (json['moveAnimation'] != null) {
      cyclingView.moveAnimation = [];
      for (final j in json['moveAnimation']) {
        cyclingView.moveAnimation!
            .add(Position.fromJson(j as Map<String, dynamic>?, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, cyclingView));
      }
    }

    if (json['notifications'] != null) {
      cyclingView.notifications = [];
      for (final j in json['notifications']) {
        cyclingView.notifications.add(Notification.fromJson(j as Map<String, dynamic>));
      }
    }

    for (final element in cyclingView.tempResults?.data ?? <ResultData?>[]) {
      if (element!.team!.isPlaceHolder) {
        element.team = existingTeams.firstWhere((existing) => existing!.id == element.team!.id, orElse: () => element.team);
      }
    }
    for (final element in cyclingView.startResults?.data ?? <ResultData?>[]) {
      if (element!.team!.isPlaceHolder) {
        element.team = existingTeams.firstWhere((existing) => existing!.id == element.team!.id, orElse: () => element.team);
      }
    }
    cyclingView.map!.sprints?.forEach((sprint) {
      for (final element in sprint.cyclistPlaces) {
        if (element!.cyclist!.isPlaceHolder) {
          element.cyclist = existingCyclists.firstWhere((existing) => existing!.id == element.cyclist!.id, orElse: () => element.cyclist);
        }
      }
    });
    for (final element in existingPositions) {
      if (element!.cyclist?.isPlaceHolder == true) {
        element.cyclist = existingCyclists.firstWhere((existing) => existing!.id == element.cyclist!.id, orElse: () => element.cyclist);
      }
      if (element.sprint?.isPlaceHolder == true) {
        element.sprint = existingSprints.firstWhere((existing) => existing!.id == element.sprint!.id, orElse: () => element.sprint);
      }
      for (int i = 0; i < element.connections!.length; i++) {
        if (element.connections![i]!.isPlaceHolder) {
          element.connections![i] = existingPositions.firstWhere((existing) => existing!.id == element.connections![i]!.id, orElse: () => element.connections![i]);
        }
      }
      for (int i = 0; i < element.route!.length; i++) {
        if (element.route![i]!.isPlaceHolder) {
          element.route![i] = existingPositions.firstWhere((existing) => existing!.id == element.route![i]!.id, orElse: () => element.route![i]);
        }
      }
    }
    for (final element in existingCyclists) {
      if (element!.team!.isPlaceHolder) {
        element.team = existingTeams.firstWhere((existing) => existing!.id == element.team!.id, orElse: () => element.team);
      }
      if (element.lastPosition?.isPlaceHolder == true) {
        element.lastPosition = existingPositions.firstWhere((existing) => existing!.id == element.lastPosition!.id, orElse: () => element.lastPosition);
      }
    }
    for (final team in existingTeams) {
      for (int i = 0; i < team!.cyclists.length; i++) {
        if (team.cyclists[i]!.isPlaceHolder) {
          team.cyclists[i] = existingCyclists.firstWhere((existing) => existing!.id == team.cyclists[i]!.id, orElse: () => team.cyclists[i]);
        }
      }
    }

    return cyclingView;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['grid'] = grid;
    data['diceValue'] = diceValue;
    data['currentTurn'] = currentTurn;
    data['ended'] = ended;
    data['moving'] = moving;
    data['autoFollow'] = autoFollow;
    data['hasResults'] = hasResults;
    data['openFollowSelect'] = openFollowSelect;
    data['zoom'] = zoom;
    data['movingTimer'] = movingTimer;
    data['cyclistMoved'] = cyclistMoved;
    data['diceValueCooldown'] = diceValueCooldown;

    data['offset'] = SaveUtil.offsetToJson(offset);
    data['worldSize'] = SaveUtil.sizeToJson(worldSize);
    data['mapSize'] = SaveUtil.sizeToJson(mapSize);

    data['gameState'] = gameState.toString();

    data['dice'] = dice != null ? dice!.toJson() : null;
    data['dice2'] = dice2 != null ? dice2!.toJson() : null;
    data['map'] = map != null ? map!.toJson() : null;
    data['movingCyclist'] = movingCyclist != null ? movingCyclist!.toJson(true) : null;
    data['tempResults'] = tempResults != null ? tempResults!.toJson() : null;
    data['startResults'] = startResults != null ? startResults!.toJson() : null;
    data['cyclistSelected'] = cyclistSelected != null ? cyclistSelected!.toJson(true) : null;
    data['cyclistLastSelected'] = cyclistLastSelected != null ? cyclistLastSelected!.toJson(true) : null;

    data['teams'] = teams?.map((i) => i!.toJson(false)).toList();
    data['moveAnimation'] = moveAnimation?.map((i) => i!.toJson(true)).toList();
    data['notifications'] = notifications.map((i) => i.toJson()).toList();

    return data;
  }
}

GameState getGameStateFromString(String? gameStateAsString) {
  for (final element in GameState.values) {
    if (element.toString() == gameStateAsString) {
      return element;
    }
  }
  return GameState.gameSelectNext;
}

enum GameState {
  userInputDiceStart,
  userWaitDiceRolling,
  userWaitDiceRolling2,
  userInputDiceDone,
  userInputPositionChoice,
  userWaitCyclistMoving,
  userWaitCyclistMovingFinished,
  userWaitCyclistFollow,
  gameSelectNext,
}

class Notification {
  String? text;
  Color? color;

  Notification(this.text, this.color);

  static Notification fromJson(Map<String, dynamic> json) {
    return Notification(json['text'] as String?, SaveUtil.colorFromJson(json['color'] as Map<String, dynamic>?));
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['color'] = SaveUtil.colorToJson(color);
    return data;
  }
}
