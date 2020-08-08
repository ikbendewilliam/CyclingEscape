import 'dart:math';
import 'dart:ui';
import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/cyclistPlace.dart';
import 'package:CyclingEscape/components/data/playSettings.dart';
import 'package:CyclingEscape/components/positions/gameMap.dart';
import 'package:CyclingEscape/components/positions/sprint.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../components/data/team.dart';
import '../components/moveable/cyclist.dart';
import '../utils/mapUtils.dart';
import '../components/moveable/dice.dart';
import '../components/positions/position.dart';
import 'baseView.dart';
import 'gameManager.dart';
import 'menus/followSelect.dart';

class CyclingView implements BaseView, PositionListener, DiceListener {
  int diceValue;
  int currentTurn = -1;
  bool grid = false;
  bool ended = false;
  bool autoFollow = false;
  Dice dice, dice2;
  Size worldSize = Size(1, 1);
  Size mapSize = Size(1, 1);
  Sprite backgroundNotification;
  Offset offsetStart = Offset(0, 0);
  Offset offset = Offset(0, 0);
  double zoom = 0.5;
  double zoomStart;
  double maxZoom = 1.5;
  double minZoom = 0.1;
  double tileSize = 1;
  double cyclistMoved;
  GameMap map;
  Position cyclistSelected;
  Position cyclistLastSelected;
  GameState gameState = GameState.GAME_SELECT_NEXT;
  FollowSelect followSelect;
  List<Team> teams = [];
  List<Button> buttons = [];
  List<Notification> notifications = [];
  @override
  Size screenSize = Size(1, 1);

  final Function cyclingEnded;
  final Function navigate;
  CyclingView(this.cyclingEnded, this.navigate);

  void onAttach({PlaySettings playSettings, ActiveTour activeTour, int team}) {
    if (playSettings != null) {
      this.map = MapUtils.generateMap(playSettings, this);
      this.mapSize = this.map.mapSize;
      teams = [];
      for (int i = 0; i < playSettings.teams; i++) {
        if (team != null) {
          if (i == 0) {
            teams.add(Team(true, team));
          } else {
            teams.add(Team(false, i == team ? 0 : i));
          }
        } else {
          teams.add(Team(i == 0, i));
        }
      }
      for (int i = 0;
          i < playSettings.teams * playSettings.ridersPerTeam;
          i++) {
        int teamIndex =
            (i - (i / playSettings.teams).floor()) % playSettings.teams;
        Cyclist cyclist = Cyclist(
            teams[teamIndex],
            (2 + teams[teamIndex].numberStart) * 10 +
                (teams[teamIndex].cyclists.length + 1),
            1);
        teams[teamIndex].cyclists.add(cyclist);
        this.map.positions[i].addCyclist(cyclist);
      }
    } else if (activeTour != null) {
      this.map =
          MapUtils.generateMap(PlaySettings.fromTour(activeTour.tour), this);
      this.mapSize = this.map.mapSize;
      if (activeTour.teams != null) {
        teams = activeTour.teams;
      } else {
        teams = [];
        for (int i = 0; i < activeTour.tour.teams; i++) {
          if (team != null) {
            if (i == 0) {
              teams.add(Team(true, team));
            } else {
              teams.add(Team(false, i == team ? 0 : i));
            }
          } else {
            teams.add(Team(i == 0, i));
          }
        }
        activeTour.teams = teams;
      }
      activeTour.cyclists.forEach((cyclist) {
        cyclist.rank = activeTour.currentResults.data
            .firstWhere((element) => element.number == cyclist.number)
            .rank;
        cyclist.lastPosition = null;
        cyclist.lastUsedOnTurn = 0;
      });
      activeTour.cyclists.sort((a, b) => b.rank - a.rank);
      for (int i = 0;
          i < activeTour.tour.teams * activeTour.tour.ridersPerTeam;
          i++) {
        int teamIndex =
            (i - (i / activeTour.tour.teams).floor()) % activeTour.tour.teams;
        Cyclist cyclist;
        if (activeTour.cyclists.length ==
            activeTour.tour.teams * activeTour.tour.ridersPerTeam) {
          cyclist = activeTour.cyclists[i];
        } else {
          cyclist = Cyclist(
              teams[teamIndex],
              (2 + teams[teamIndex].numberStart) * 10 +
                  (teams[teamIndex].cyclists.length + 1),
              1);
          activeTour.cyclists.add(cyclist);
          teams[teamIndex].cyclists.add(cyclist);
        }
        this.map.positions[i].addCyclist(cyclist);
      }
    }
    if (playSettings != null || activeTour != null) {
      currentTurn = -1;
      ended = false;
      autoFollow = false;
      offsetStart = Offset(0, 0);
      offset = Offset(0, 0);
      zoom = 0.5;
      notifications = [];
      this.handleInBetweenTurns();
      this.processGameState(GameState.GAME_SELECT_NEXT);
      backgroundNotification = Sprite('back_text_04.png');
      createButtons(screenSize != null ? screenSize.height / 7 : 10);
    }
  }

  void render(Canvas canvas) {
    canvas.save();
    Paint bgPaint = Paint()..color = Colors.green[200];
    canvas.drawRect(
        Rect.fromLTRB(0, 0, screenSize.width, screenSize.height), bgPaint);
    canvas.translate(offset.dx * zoom, offset.dy * zoom);
    canvas.scale(zoom);

    if (grid) {
      for (int i = 0; i < worldSize.width; i++) {
        Paint paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawLine(Offset(i * tileSize, 0),
            Offset(i * tileSize, worldSize.height), paint);
      }

      for (int i = 0; i < worldSize.height; i++) {
        Paint paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawLine(Offset(0, i * tileSize),
            Offset(worldSize.width, i * tileSize), paint);
      }
    }

    this.map.render(canvas, tileSize);
    canvas.restore();

    if (dice != null) {
      dice.render(canvas, 0);
    }
    if (dice2 != null) {
      dice2.render(canvas, 1);
    }
    if (followSelect != null) {
      followSelect.render(canvas);
    }

    buttons.forEach((button) {
      button.render(canvas);
    });
    notifications.asMap().forEach((i, notification) {
      backgroundNotification.renderRect(
          canvas,
          Rect.fromLTRB(
              screenSize.width - tileSize * 3.7,
              tileSize * (i / 2 + 0.1),
              screenSize.width - tileSize * 0.1,
              tileSize * (i / 2 + 0.6)));
      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: notification.color,
              fontSize: 14.0,
              fontFamily: 'SaranaiGame'),
          text: notification.text);
      Offset position =
          Offset(screenSize.width - tileSize * 1.7, tileSize * (i / 2 + 0.1));
      CanvasUtils.drawText(canvas, position, 0, span);
    });
  }

  void update(double t) {
    this.map.update(t);

    if (dice != null) {
      dice.update(t);
    }
    if (dice2 != null) {
      dice2.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.height / 9;
    worldSize = Size(tileSize * mapSize.width, tileSize * mapSize.height);
    if (followSelect != null) {
      followSelect.resize(size);
    }
    if (cyclistSelected != null) {
      offset = -((cyclistSelected.p1 + cyclistSelected.p2) / 2 * tileSize -
          Offset(screenSize.width, screenSize.height) / 2 / zoom);
      checkBounds();
    }
    createButtons(screenSize.height / 7);
    buttons.forEach((element) {
      element.setScreenSize(size);
    });
  }

  createButtons(double buttonSize) {
    buttons = [];
    buttons.add(Button(Offset(buttonSize, buttonSize) / 2,
        ButtonType.ICON_PAUSE, () => {navigate(GameManagerState.PAUSED)}));
  }

  void onTapUp(TapUpDetails details) {
    bool pressed = false;
    buttons.forEach((button) {
      pressed = pressed || button.onTapUp(details);
    });
    if (pressed) {
      return;
    }
    if (followSelect != null) {
      followSelect.onTapUp(details);
    } else {
      switch (gameState) {
        case GameState.USER_INPUT_DICE_START:
          startDice();
          processGameState(GameState.USER_WAIT_DICE_ROLLING);
          break;
        case GameState.USER_INPUT_DICE_DONE:
          removeDice();
          processGameState(GameState.USER_INPUT_POSITION_CHOICE);
          break;
        case GameState.USER_INPUT_POSITION_CHOICE:
          if (cyclistSelected != null) {
            this.map.clickedEvent(
                (-offset + details.globalPosition / zoom) / tileSize);
          }
          break;
        case GameState.USER_INPUT_CYCLIST_FOLLOW:
          processGameState(GameState.USER_WAIT_CYCLIST_MOVING);
          break;
        case GameState.USER_WAIT_CYCLIST_MOVING:
        case GameState.USER_WAIT_DICE_ROLLING:
        case GameState.USER_WAIT_DICE_ROLLING2:
        default:
        // Do nothing
      }
    }
  }

  processGameState(newState) {
    if (ended) {
      return;
    }
    gameState = newState;
    switch (gameState) {
      case GameState.USER_WAIT_CYCLIST_MOVING:
        // TODO: Special effects :-D
        break;
      case GameState.USER_INPUT_CYCLIST_FOLLOW:
        bool following = false;
        int minThrow = this.canFollow();
        if (minThrow >= 0) {
          Position placeBefore = getPlaceBefore();
          if (minThrow >= 7 &&
              (this.autoFollow || !placeBefore.cyclist.team.isPlayer)) {
            following = true;
            follow();
            processGameState(GameState.USER_INPUT_CYCLIST_FOLLOW);
          } else if (placeBefore.cyclist.team.isPlayer) {
            followSelect = FollowSelect((FollowType returnValue) {
              switch (returnValue) {
                case FollowType.AUTO_FOLLOW:
                  this.autoFollow = true;
                  if (minThrow >= 7) {
                    follow();
                    processGameState(GameState.USER_INPUT_CYCLIST_FOLLOW);
                  } else {
                    processGameState(GameState.GAME_SELECT_NEXT);
                  }
                  break;
                case FollowType.FOLLOW:
                  follow();
                  processGameState(GameState.USER_INPUT_CYCLIST_FOLLOW);
                  break;
                case FollowType.LEAVE:
                default:
                  processGameState(GameState.GAME_SELECT_NEXT);
              }
              followSelect = null;
            }, minThrow);
            followSelect.onAttach();
            followSelect.resize(screenSize);
            following = true;
          }
        }
        if (!following) {
          processGameState(GameState.GAME_SELECT_NEXT);
        }
        break;
      case GameState.GAME_SELECT_NEXT:
        this.selectNextCyclist();
        break;
      case GameState.USER_INPUT_POSITION_CHOICE:
        this.map.setState(PositionState.NOT_SELECTABLE);
        cyclistSelected.setState(
            PositionState.SELECTABLE,
            max(0, diceValue + cyclistSelected.fieldValue),
            cyclistSelected.cyclist);
        if (!cyclistSelected.cyclist.team.isPlayer) {
          selectPosition(MapUtils.findMaxValue(
              cyclistSelected, diceValue + cyclistSelected.fieldValue));
        }
        break;
      case GameState.USER_INPUT_DICE_START:
        if (!cyclistSelected.cyclist.team.isPlayer) {
          startDice();
          processGameState(GameState.USER_WAIT_DICE_ROLLING);
        }
        break;
      case GameState.USER_INPUT_DICE_DONE:
        if (!cyclistSelected.cyclist.team.isPlayer) {
          removeDice();
          processGameState(GameState.USER_INPUT_POSITION_CHOICE);
        }
        break;
      default:
      // Do nothing
    }
  }

  // -1 if you cannot follow, int for min to throw to follow
  int canFollow() {
    Position placeBefore = MapUtils.findPlaceBefore(
        cyclistLastSelected, 9999, false,
        positions: map.positions);
    if (placeBefore == null || placeBefore.cyclist == null) {
      return -1;
    }
    Position placeBeforeEnd = MapUtils.findPlaceBefore(
        cyclistSelected, cyclistMoved, true,
        startPosition: placeBefore);
    if (placeBeforeEnd == null) {
      return -1;
    }
    return max(
        (MapUtils.calculateDistance(placeBefore, placeBeforeEnd) -
                placeBefore.fieldValue)
            .ceil(),
        0);
  }

  getPlaceBefore() {
    return MapUtils.findPlaceBefore(cyclistLastSelected, 9999, false,
        positions: map.positions);
  }

  follow() {
    Position lastSelectedAccent = MapUtils.findPlaceBefore(
        cyclistLastSelected, 9999, false,
        positions: map.positions);
    if (lastSelectedAccent == null || lastSelectedAccent.cyclist == null) {
      return null;
    }
    Position selectedAccent = MapUtils.findPlaceBefore(
        cyclistSelected, cyclistMoved, true,
        startPosition: lastSelectedAccent);
    if (selectedAccent != null && lastSelectedAccent != null) {
      cyclistSelected = selectedAccent;
      cyclistLastSelected = lastSelectedAccent;
      cyclistSelected.addCyclist(lastSelectedAccent.removeCyclist());
      cyclistSelected.cyclist.lastUsedOnTurn++;
    }
  }

  addNotification(String text, Color color) {
    notifications.add(Notification(text, color));
    print(text);
  }

  handleInBetweenTurns() {
    bool removed = false;
    this.map.positions.forEach((position) {
      if (position.cyclist != null) {
        if (position.cyclist.lastPosition != null) {
          List<Sprint> sprints = MapUtils.getSprintsBetween(
              position.cyclist.lastPosition, position);
          sprints.forEach((sprint) => sprint.addCyclistPlace(
              CyclistPlace(position.cyclist, position.getValue(true))));
          if (sprints.length > 0) {
            if (sprints.firstWhere((s) => s.type == SprintType.FINISH,
                    orElse: () => null) !=
                null) {
              position.removeCyclist(); // Remove cyclist when finished
              removed = true;
            }
          }
        }
        if (position.cyclist != null) {
          position.cyclist.lastPosition = position;
        }
      }
    });
    this
        .map
        .sprints
        .where((sprint) => sprint.type != SprintType.START)
        .forEach((sprint) {
      sprint.cyclistPlaces.sort((a, b) => (b.value - a.value).round());
      sprint.cyclistPlaces.asMap().forEach((key, element) {
        if (!element.displayed) {
          element.displayed = true;
          if (sprint.type == SprintType.FINISH) {
            addNotification('${element.cyclist.number} Finished ${th(key + 1)}',
                element.cyclist.team.getColor());
          } else if (sprint.getPoints(key) > 0) {
            addNotification(
                '${element.cyclist.number} Gained ${sprint.getPoints(key)} ${sprint.getPointsName()}',
                element.cyclist.team.getColor());
          }
        }
      });
    });
    return removed;
  }

  th(int number) {
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

  selectNextCyclist() {
    Position nextPosition;
    double nextValue = 0;
    this
        .map
        .positions
        .where((element) => element.cyclist != null)
        .forEach((pos) {
      double value = pos.getValue(true);
      if (nextValue < value || nextPosition == null) {
        nextValue = value;
        nextPosition = pos;
      }
      this.map.setState(PositionState.NORMAL);
      cyclistSelected = nextPosition;
    });
    if (nextPosition == null || cyclistSelected.cyclist == null) {
      // No more cyclist -> Race ended
      cyclingEnded(this.map.sprints);
      ended = true;
    } else if (!ended) {
      cyclistSelected.setState(PositionState.NOT_SELECTABLE);
      if (cyclistSelected.cyclist.lastUsedOnTurn > currentTurn) {
        currentTurn = cyclistSelected.cyclist.lastUsedOnTurn;
        notifications = [];
        if (handleInBetweenTurns()) {
          this.selectNextCyclist();
        }
      }
      this.dice = Dice(this);
      this.dice2 = Dice(this);
      if (screenSize != null) {
        offset = -((cyclistSelected.p1 + cyclistSelected.p2) / 2 * tileSize -
            Offset(screenSize.width, screenSize.height) / 2 / zoom);
        checkBounds();
      }
      processGameState(GameState.USER_INPUT_DICE_START);
    }
  }

  startDice() {
    this.dice.start();
    this.dice2.start();
  }

  removeDice() {
    this.dice = null;
    this.dice2 = null;
  }

  void onScaleStart(ScaleStartDetails details) {
    offsetStart = details.focalPoint / zoom - offset;
    zoomStart = zoom;
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    buttons.forEach((button) {
      button.onTapDown(details.focalPoint);
    });
    if (followSelect != null) {
      followSelect.onScaleUpdate(details);
    } else {
      offset = details.focalPoint / zoom - offsetStart;
      zoom = zoomStart * details.scale;
      checkBounds();
    }
  }

  checkBounds() {
    if (zoom > maxZoom) {
      zoom = maxZoom;
    }
    if (zoom < minZoom) {
      zoom = minZoom;
    }
    if (-offset.dx > worldSize.width - screenSize.width / zoom) {
      offset +=
          Offset(-offset.dx - worldSize.width + screenSize.width / zoom, 0);
    }
    if (-offset.dy > worldSize.height - screenSize.height / zoom) {
      offset +=
          Offset(0, -offset.dy - worldSize.height + screenSize.height / zoom);
    }
    if (-offset.dx < 0) {
      offset -= Offset(offset.dx, 0);
    }
    if (-offset.dy < 0) {
      offset -= Offset(0, offset.dy);
    }
  }

  @override
  void selectPosition(Position position) {
    if (cyclistSelected != null) {
      position.addCyclist(cyclistSelected.removeCyclist());
      position.cyclist.lastUsedOnTurn++;
      if (position != cyclistSelected) {
        cyclistMoved = MapUtils.calculateDistance(cyclistSelected, position,
            minDistance: max(0, diceValue + cyclistSelected.fieldValue));
      }
      cyclistLastSelected = cyclistSelected;
      map.setState(PositionState.NORMAL);
      cyclistSelected = position;
      processGameState(GameState.USER_INPUT_CYCLIST_FOLLOW);
    }
  }

  @override
  void diceStopped(int diceValue) {
    if (gameState == GameState.USER_WAIT_DICE_ROLLING2) {
      this.diceValue += diceValue;
      processGameState(GameState.USER_INPUT_DICE_DONE);
    } else {
      this.diceValue = diceValue;
      processGameState(GameState.USER_WAIT_DICE_ROLLING2);
    }
  }

  @override
  void onTapDown(TapDownDetails details) {
    buttons.forEach((button) {
      button.onTapDown(details.globalPosition);
    });
  }
}

enum GameState {
  USER_INPUT_DICE_START,
  USER_WAIT_DICE_ROLLING,
  USER_WAIT_DICE_ROLLING2,
  USER_INPUT_DICE_DONE,
  USER_INPUT_POSITION_CHOICE,
  USER_WAIT_CYCLIST_MOVING,
  USER_INPUT_CYCLIST_FOLLOW,
  GAME_SELECT_NEXT,
}

class Notification {
  final String text;
  final Color color;

  Notification(this.text, this.color);
}
