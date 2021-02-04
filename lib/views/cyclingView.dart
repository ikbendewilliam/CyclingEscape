import 'dart:math';
import 'dart:ui';
import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/cyclistPlace.dart';
import 'package:CyclingEscape/components/data/playSettings.dart';
import 'package:CyclingEscape/components/data/resultData.dart';
import 'package:CyclingEscape/components/data/results.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/positions/gameMap.dart';
import 'package:CyclingEscape/components/positions/sprint.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/saveUtil.dart';
import 'package:CyclingEscape/views/menus/tutorialView.dart';
import 'package:CyclingEscape/views/resultsView.dart';
import 'package:flame/position.dart' as flamePosition;
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../components/data/team.dart';
import '../components/moveable/cyclist.dart';
import '../utils/mapUtils.dart';
import '../components/moveable/dice.dart';
import '../components/positions/position.dart';
import 'baseView.dart';
import 'cyclingViewUI.dart';
import 'gameManager.dart';
import 'menus/careerMenu.dart';
import 'menus/followSelect.dart';
import 'menus/settingsMenu.dart';

class CyclingView implements BaseView, PositionListener, DiceListener {
  int diceValue;
  int currentTurn = 0;
  bool grid = false;
  bool ended = false;
  bool moving = false;
  bool inCareer = false;
  bool autoFollow = false;
  bool hasResults = false;
  bool openFollowSelect = false;
  Dice dice, dice2;
  Size worldSize = Size(1, 1);
  Size mapSize = Size(1, 1);
  Sprite backgroundNotification;
  Sprite backgroundText;
  Sprite grass;
  Sprite grass2;
  Sprite iconTime;
  Sprite iconRank;
  Sprite iconPoints;
  Sprite iconMountain;
  Offset offsetStart = Offset(0, 0);
  Offset offset = Offset(0, 0);
  double zoom = 0.5;
  double zoomStart;
  double movingTimer = 0;
  double maxZoom = 1.5;
  double minZoom = 0.2;
  double tileSize = 1;
  double cyclistMoved;
  double diceValueCooldown = 0;
  GameMap map;
  Cyclist movingCyclist;
  Results tempResults;
  Results startResults;
  RaceType careerRaceType;
  Settings settings;
  Position cyclistSelected;
  Position cyclistLastSelected;
  GameState gameState = GameState.GAME_SELECT_NEXT;
  FollowSelect followSelect;

  List<Team> teams = [];
  List<Button> buttons = [];
  List<Position> moveAnimation = [];
  List<Notification> notifications = [];
  @override
  Size screenSize = Size(1, 1);
  @override
  final SpriteManager spriteManager;

  final Function cyclingEnded;
  final Function navigate;
  final Function openTutorial;

  CyclingView(this.spriteManager, this.cyclingEnded, this.navigate, this.settings, this.openTutorial);

  void onAttach({PlaySettings playSettings, ActiveTour activeTour, int team, int playerRiders}) {
    if (playSettings != null) {
      this.hasResults = false;
      this.map = MapUtils.generateMap(playSettings, this, this.spriteManager);
      this.mapSize = this.map.mapSize;
      teams = [];
      for (int i = 0; i < playSettings.teams; i++) {
        if (team != null) {
          if (i == 0) {
            teams.add(Team(true, team, spriteManager));
          } else {
            teams.add(Team(false, i == team ? 0 : i, spriteManager));
          }
        } else {
          teams.add(Team(i == 0, i, spriteManager));
        }
      }
      tempResults = Results(ResultsType.RACE);
      for (int i = 0; i < playSettings.teams * playSettings.ridersPerTeam; i++) {
        int teamIndex = (i - (i / playSettings.teams).floor()) % playSettings.teams;
        Cyclist cyclist = Cyclist(teams[teamIndex], (2 + teams[teamIndex].numberStart) * 10 + (teams[teamIndex].cyclists.length + 1), 1, spriteManager);
        tempResults.data.add(ResultData(playSettings.teams * playSettings.ridersPerTeam - i, 0, 0, 0, cyclist.number, cyclist.team));
        teams[teamIndex].cyclists.add(cyclist);
        this.map.positions[i].addCyclist(cyclist);
      }
    } else if (activeTour != null) {
      if (activeTour.currentResults.data != null && activeTour.currentResults.data.length > 0) {
        this.startResults = activeTour.currentResults.copy();
        this.hasResults = true;
      } else {
        this.hasResults = false;
      }
      this.map = MapUtils.generateMap(PlaySettings.fromTour(activeTour.tour), this, this.spriteManager);
      this.mapSize = this.map.mapSize;
      if (activeTour.teams != null) {
        teams = activeTour.teams;
      } else {
        teams = [];
        for (int i = 0; i < activeTour.tour.teams; i++) {
          if (team != null) {
            if (i == 0) {
              teams.add(Team(true, team, spriteManager));
            } else {
              teams.add(Team(false, i == team ? 0 : i, spriteManager));
            }
          } else {
            teams.add(Team(i == 0, i, spriteManager));
          }
        }
        activeTour.teams = teams;
      }
      int greenJersey;
      int bouledJersey;
      int whiteJersey;
      this.tempResults = Results(ResultsType.RACE);
      if (activeTour.currentResults.data != null && activeTour.currentResults.data.length > 0) {
        greenJersey = activeTour.currentResults.greenJersey;
        bouledJersey = activeTour.currentResults.bouledJersey;
        whiteJersey = activeTour.currentResults.whiteJersey;
        activeTour.currentResults.data.asMap().forEach((key, value) => {value.rank = key});
      }
      activeTour.cyclists.forEach((cyclist) {
        if (activeTour.currentResults.data.length > 0) {
          cyclist.rank = activeTour.currentResults.data.firstWhere((element) => element.number == cyclist.number).rank;
        }
        cyclist.lastPosition = null;
        cyclist.lastUsedOnTurn = 0;
        cyclist.wearsYellowJersey = (cyclist.rank == 0);
        cyclist.wearsWhiteJersey = whiteJersey != null && whiteJersey == cyclist.number;
        cyclist.wearsGreenJersey = greenJersey != null && greenJersey == cyclist.number;
        cyclist.wearsBouledJersey = bouledJersey != null && bouledJersey == cyclist.number;
      });
      activeTour.cyclists.sort((a, b) => b.rank - a.rank);
      int maxCyclists = activeTour.tour.teams * activeTour.tour.ridersPerTeam;
      if (playerRiders != null && playerRiders > 0) {
        maxCyclists = (activeTour.tour.teams - 1) * activeTour.tour.ridersPerTeam + playerRiders;
      }
      for (int i = 0; i < maxCyclists; i++) {
        Cyclist cyclist;
        int teamIndex = (i / activeTour.tour.ridersPerTeam).floor();
        if (playerRiders != null && playerRiders > 0) {
          teamIndex = 0;
          if (i >= playerRiders) {
            teamIndex = ((i - playerRiders) / activeTour.tour.ridersPerTeam).floor() + 1;
          }
        }
        if (maxCyclists == activeTour.tour.teams * activeTour.tour.ridersPerTeam && maxCyclists == activeTour.cyclists.length) {
          cyclist = activeTour.cyclists[i];
        } else {
          cyclist = Cyclist(teams[teamIndex], (2 + teams[teamIndex].numberStart) * 10 + (teams[teamIndex].cyclists.length + 1), 1, spriteManager);
          activeTour.cyclists.add(cyclist);
          teams[teamIndex].cyclists.add(cyclist);
        }
        tempResults.data.add(ResultData(activeTour.tour.teams * activeTour.tour.ridersPerTeam - i, 0, 0, 0, cyclist.number, cyclist.team));
      }
      List<int> teamIndexes = [0, 0, 0, 0, 0, 0, 0, 0];
      for (int i = 0; i < maxCyclists; i++) {
        // int teamIndex = (i % teams.length);
        int teamIndex = (i - (i / activeTour.tour.teams).floor()) % activeTour.tour.teams;
        if (teams[teamIndex].cyclists.length <= teamIndexes[teamIndex]) {
          teamIndex = 0;
        }
        Cyclist cyclist = teams[teamIndex].cyclists[teamIndexes[teamIndex]++];
        if (this.map.positions.length < i) {
          throw Error(); // Out of bounds
        }
        this.map.positions[i].addCyclist(cyclist);
        cyclist.lastPosition = this.map.positions[i];
      }
    }
    if (playSettings != null || activeTour != null) {
      careerRaceType = activeTour.raceType;
      inCareer = (playerRiders != null && playerRiders > 0);
      currentTurn = 0;
      ended = false;
      autoFollow = false;
      offsetStart = Offset(0, 0);
      offset = Offset(0, 0);
      zoom = 0.5;
      notifications = [];
      minZoom = 0.2;
      followSelect = null;
      this.handleInBetweenTurns();
      this.processGameState(GameState.GAME_SELECT_NEXT);
    }
    createButtons(screenSize != null ? screenSize.height / 7 : 10);
    if (openFollowSelect) {
      this.processGameState(GameState.USER_INPUT_CYCLIST_FOLLOW);
    }
    if (grass == null) {
      grass = this.spriteManager.getSprite('environment/grass.png');
    }
    if (grass2 == null) {
      grass2 = this.spriteManager.getSprite('environment/grass2.png');
    }
    if (backgroundNotification == null) {
      backgroundNotification = this.spriteManager.getSprite('back_text_04.png');
    }
    if (backgroundText == null) {
      backgroundText = this.spriteManager.getSprite('back_text_05.png');
    }
    if (iconTime == null) {
      iconTime = this.spriteManager.getSprite('icon_time.png');
    }
    if (iconRank == null) {
      iconRank = this.spriteManager.getSprite('icon_rank.png');
    }
    if (iconPoints == null) {
      iconPoints = this.spriteManager.getSprite('icon_points.png');
    }
    if (iconMountain == null) {
      iconMountain = this.spriteManager.getSprite('icon_mountain.png');
    }
  }

  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(offset.dx * zoom, offset.dy * zoom);
    canvas.scale(zoom);
    if (grass != null && grass2 != null && grass.loaded() && grass2.loaded()) {
      for (int i = -(offset.dx / tileSize).ceil(); i < -(offset.dx / tileSize).floor() + screenSize.width / tileSize / zoom; i++) {
        for (int j = -(offset.dy / tileSize).ceil(); j < -(offset.dy / tileSize).floor() + screenSize.height / tileSize / zoom; j++) {
          Sprite g = grass;
          if ((i * j + i + j) % 5 == 0 || (i * j + i + j) % 7 == 0) {
            g = grass2;
          }
          g.renderPosition(canvas, flamePosition.Position(i * tileSize, j * tileSize), size: flamePosition.Position(tileSize * 1.05, tileSize * 1.05));
        }
      }
    }

    if (grid) {
      for (int i = 0; i < worldSize.width; i++) {
        Paint paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawLine(Offset(i * tileSize, 0), Offset(i * tileSize, worldSize.height), paint);
      }

      for (int i = 0; i < worldSize.height; i++) {
        Paint paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawLine(Offset(0, i * tileSize), Offset(worldSize.width, i * tileSize), paint);
      }
    }

    Offset center = Offset(-(offset.dx / tileSize).ceil() + screenSize.width / tileSize / zoom / 2, -(offset.dy / tileSize).ceil() + screenSize.height / tileSize / zoom / 2);

    double screenRange = screenSize.width * 1.2 / zoom;
    this.map.render(canvas, tileSize, center, screenRange);
    if (movingCyclist != null) {
      movingCyclist.render(canvas, movingCyclist.movingOffset * tileSize, tileSize / 3, movingCyclist.movingAngle);
    }
    canvas.restore();

    if (followSelect != null) {
      followSelect.render(canvas);
    }

    CyclingViewUI.render(canvas, tileSize, screenSize, dice, dice2, buttons, notifications, backgroundNotification, backgroundText, iconTime, iconRank, iconPoints, iconMountain,
        movingCyclist != null ? movingCyclist : cyclistSelected.cyclist, tempResults, diceValueCooldown, diceValue);
  }

  void update(double t) {
    this.map.update(t);

    if (diceValueCooldown > 0) {
      diceValueCooldown -= t;
    }

    if (dice != null) {
      dice.update(t);
    }
    if (dice2 != null) {
      dice2.update(t);
    }
    if (moving) {
      double startTimer = 0;
      switch (this.settings.cyclistMovement) {
        case CyclistMovementType.FAST:
          startTimer = 0.5;
          break;
        case CyclistMovementType.SLOW:
          startTimer = 2;
          break;
        case CyclistMovementType.SKIP:
          startTimer = 0.01;
          break;
        default:
          startTimer = 1;
          break;
      }

      if (movingTimer == -1) {
        movingTimer = startTimer;
      } else {
        movingTimer -= t;
      }
      movingCyclist.moveTo(max(0, 1 - movingTimer / startTimer), moveAnimation);
      if (movingCyclist.movingOffset.isFinite && this.settings.cameraMovement == CameraMovementType.AUTO) {
        offset = -(movingCyclist.movingOffset * tileSize - Offset(screenSize.width, screenSize.height) / 2 / zoom);
      }
      if (movingTimer <= 0) {
        this.processGameState(GameState.USER_WAIT_CYCLIST_MOVING_FINISHED);
      }
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.height / 9;
    worldSize = Size(tileSize * mapSize.width, tileSize * mapSize.height);
    if (screenSize.width / worldSize.width > minZoom) {
      minZoom = screenSize.width / worldSize.width;
    }
    if (screenSize.height / worldSize.height > minZoom) {
      minZoom = screenSize.height / worldSize.height;
    }
    if (followSelect != null) {
      followSelect.resize(size);
    }
    if (cyclistSelected != null) {
      offset = -((cyclistSelected.p1 + cyclistSelected.p2) / 2 * tileSize - Offset(screenSize.width, screenSize.height) / 2 / zoom);
      checkBounds();
    }
    createButtons(screenSize.height / 7);
    buttons.forEach((element) {
      element.setScreenSize(size);
    });
  }

  createButtons(double buttonSize) {
    buttons = [];
    buttons.add(Button(this.spriteManager, Offset(buttonSize / 2 + 5, screenSize.height - buttonSize / 2 - 5), ButtonType.ICON_PAUSE, () => {navigate(GameManagerState.PAUSED)}));
    if (hasResults) {
      buttons.add(Button(this.spriteManager, Offset(buttonSize / 2 * 3.2 + 5, screenSize.height - buttonSize / 2 - 5), ButtonType.ICON_RESULTS,
          () => {navigate(GameManagerState.PAUSED_RESULTS)}));
    }
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
            this.map.clickedEvent((-offset + details.globalPosition / zoom) / tileSize);
          }
          break;
        case GameState.USER_WAIT_CYCLIST_MOVING:
        case GameState.USER_WAIT_CYCLIST_MOVING_FINISHED:
        case GameState.USER_INPUT_CYCLIST_FOLLOW:
        case GameState.USER_WAIT_DICE_ROLLING:
        case GameState.USER_WAIT_DICE_ROLLING2:
        default:
        // Do nothing
      }
    }
  }

  updateResults() {
    if (cyclistSelected == null || cyclistSelected.cyclist == null) {
      return;
    }
    bool useStartResults = false;
    ResultData startResult;
    this.map.positions.where((element) => element.cyclist != null).toList().forEach((cyclistPosition) {
      if (startResults != null) {
        useStartResults = true;
        startResult = startResults.data.firstWhere((element) => element.number == cyclistPosition.cyclist.number, orElse: () => null);
      }
      ResultData result = tempResults.data.firstWhere((element) => element.number == cyclistPosition.cyclist.number, orElse: () => null);
      if (result != null) {
        result.time = (useStartResults ? startResult.time : 0) + currentTurn;
        result.value = useStartResults ? 100.0 - startResult.rank : cyclistPosition.getValue(false);
        if (useStartResults && result.points < startResult.points) {
          result.points += startResult.points;
        }
        if (useStartResults && result.mountain < startResult.mountain) {
          result.mountain += startResult.mountain;
        }
      }
    });
    tempResults.data.sort((a, b) => ((a.time == b.time ? b.value - a.value : a.time - b.time) * 100).round());
    tempResults.data.asMap().forEach((key, value) {
      value.rank = key + 1;
    });
  }

  processGameState(newState) {
    if (ended) {
      return;
    }
    gameState = newState;
    switch (gameState) {
      case GameState.USER_WAIT_CYCLIST_MOVING:
        moving = true;
        movingTimer = -1;
        movingCyclist = moveAnimation.first.removeCyclist();
        movingCyclist.moveTo(0, moveAnimation);
        break;
      case GameState.USER_WAIT_CYCLIST_MOVING_FINISHED:
        moving = false;
        cyclistLastSelected = moveAnimation.first;
        cyclistSelected = moveAnimation.last;
        cyclistSelected.addCyclist(movingCyclist);
        cyclistSelected.cyclist.lastUsedOnTurn++;
        movingCyclist = null;
        this.processGameState(GameState.USER_INPUT_CYCLIST_FOLLOW);
        break;
      case GameState.USER_INPUT_CYCLIST_FOLLOW:
        bool following = false;
        int minThrow = this.canFollow();
        Position placeBefore = getPlaceBefore();
        if (minThrow <= 0 && placeBefore?.cyclist?.team?.isPlayer == true) {
          openTutorial(TutorialType.NO_FOLLOW_AVAILABLE);
        } else if (minThrow > 0) {
          if (placeBefore.cyclist.team.isPlayer) {
            openTutorial(TutorialType.FOLLOW);
          }
          if ((minThrow >= 7 && !placeBefore.cyclist.team.isPlayer) || (minThrow >= this.settings.autofollowThreshold && this.autoFollow && placeBefore.cyclist.team.isPlayer)) {
            following = true;
            follow();
            processGameState(GameState.USER_WAIT_CYCLIST_MOVING);
          } else if (placeBefore.cyclist.team.isPlayer && (minThrow >= this.settings.autofollowThreshold || this.settings.autofollowAsk)) {
            followSelect = FollowSelect(this.spriteManager, (FollowType returnValue) {
              followSelect = null;
              switch (returnValue) {
                case FollowType.AUTO_FOLLOW:
                  this.autoFollow = true;
                  if (minThrow >= this.settings.autofollowThreshold) {
                    follow();
                    processGameState(GameState.USER_WAIT_CYCLIST_MOVING);
                  } else {
                    processGameState(GameState.GAME_SELECT_NEXT);
                  }
                  break;
                case FollowType.FOLLOW:
                  follow();
                  processGameState(GameState.USER_WAIT_CYCLIST_MOVING);
                  break;
                case FollowType.LEAVE:
                default:
                  processGameState(GameState.GAME_SELECT_NEXT);
              }
            }, minThrow);
            followSelect.onAttach();
            followSelect.resize(screenSize);
            following = true;
            if (this.autoFollow) {
              openTutorial(TutorialType.FOLLOW);
            }
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
        cyclistSelected.setState(PositionState.SELECTABLE, max(0, diceValue + cyclistSelected.fieldValue), [], cyclistSelected.cyclist);
        if (!cyclistSelected.cyclist.team.isPlayer) {
          selectPosition(MapUtils.findMaxValue(cyclistSelected, max(0, diceValue + cyclistSelected.fieldValue)));
        } else {
          openTutorial(TutorialType.SELECT_POSITION);
        }
        break;
      case GameState.USER_INPUT_DICE_START:
        if (!cyclistSelected.cyclist.team.isPlayer) {
          startDice();
          processGameState(GameState.USER_WAIT_DICE_ROLLING);
        } else {
          openTutorial(TutorialType.THROW_DICE);
          if (cyclistSelected.fieldValue < 0) {
            openTutorial(TutorialType.FIELDVALUE);
          } else if (cyclistSelected.fieldValue > 0) {
            openTutorial(TutorialType.FIELDVALUE_POSITIVE);
          }
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
    Position placeBefore = getPlaceBefore();
    if (placeBefore == null || placeBefore.cyclist == null) {
      return -1;
    }
    List<Position> routeBeforeEnd = MapUtils.findPlaceBefore(cyclistSelected, cyclistMoved, true, startPosition: placeBefore);
    if (routeBeforeEnd == null || routeBeforeEnd.length == 0) {
      return -1;
    }
    if (cyclistLastSelected.positionType == PositionType.DOWNHILL && placeBefore.positionType == PositionType.UPHILL) {
      return -1;
    }
    return max(routeBeforeEnd.length - 1 - placeBefore.fieldValue.floor(), 0);
  }

  Position getPlaceBefore() {
    return MapUtils.findPlaceBefore(cyclistLastSelected, 9999, false, positions: map.positions).lastWhere((element) => true, orElse: () => null);
  }

  follow() {
    Position lastSelectedAccent = getPlaceBefore();
    if (lastSelectedAccent == null || lastSelectedAccent.cyclist == null) {
      return null;
    }
    moveAnimation = MapUtils.findPlaceBefore(cyclistSelected, cyclistMoved, true, startPosition: lastSelectedAccent);
  }

  addNotification(String text, Color color) {
    notifications.add(Notification(text, color));
  }

  handleInBetweenTurns() {
    bool removed = false;
    this.map.positions.forEach((position) {
      if (position.cyclist != null) {
        if (position.cyclist.lastPosition != null) {
          List<Sprint> sprints = MapUtils.getSprintsBetween(position.cyclist.lastPosition, position);
          sprints =
              sprints.where((element) => element.cyclistPlaces.firstWhere((CyclistPlace x) => x.cyclist.number == position.cyclist.number, orElse: () => null) == null).toList();
          sprints.forEach((sprint) => sprint.addCyclistPlace(CyclistPlace(position.cyclist, position.getValue(true))));
          if (sprints.length > 0) {
            if (sprints.firstWhere((s) => s.type == SprintType.FINISH, orElse: () => null) != null) {
              openTutorial(TutorialType.FINISH);
              position.removeCyclist(); // Remove cyclist when finished
              removed = true;
            } else if (sprints.firstWhere((s) => s.type == SprintType.MOUNTAIN_SPRINT || s.type == SprintType.SPRINT, orElse: () => null) != null) {
              openTutorial(TutorialType.SPRINT);
            }
          }
        }
        if (position.cyclist != null) {
          position.cyclist.lastPosition = position;
        }
      }
    });
    this.map.sprints.where((sprint) => sprint.type != SprintType.START).forEach((sprint) {
      sprint.cyclistPlaces.sort((a, b) => (b.value - a.value).round());
      sprint.cyclistPlaces.asMap().forEach((key, element) {
        if (!element.displayed) {
          element.displayed = true;
          if (sprint.type == SprintType.FINISH) {
            addNotification('${element.cyclist.number} Finished ${th(key + 1)}', element.cyclist.team.getColor());
          } else if (sprint.getPoints(key) > 0) {
            ResultData result = tempResults.data.firstWhere((r) => r.number == element.cyclist.number, orElse: () => null);
            if (result != null) {
              switch (sprint.type) {
                case SprintType.MOUNTAIN_SPRINT:
                  result.mountain += sprint.getPoints(key);
                  break;
                case SprintType.SPRINT:
                  result.points += sprint.getPoints(key);
                  break;
                default:
                // Do nothing
              }
            }
            addNotification('${element.cyclist.number} Gained ${sprint.getPoints(key)} ${sprint.getPointsName()}', element.cyclist.team.getColor());
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
    this.map.positions.where((element) => element.cyclist != null).forEach((positionWithCyclist) {
      double value = positionWithCyclist.getValue(true);
      if (nextValue < value || nextPosition == null) {
        nextValue = value;
        nextPosition = positionWithCyclist;
      }
      this.map.setState(PositionState.NORMAL);
      cyclistSelected = nextPosition;
    });
    if (nextPosition == null || cyclistSelected.cyclist == null) {
      // No more cyclist -> Race ended
      cyclingEnded(this.map.sprints);
      ended = true;
    } else if (!ended) {
      updateResults();
      cyclistSelected.setState(PositionState.NOT_SELECTABLE);
      if (cyclistSelected.cyclist.lastUsedOnTurn > currentTurn) {
        currentTurn = cyclistSelected.cyclist.lastUsedOnTurn;
        notifications = [];
        if (handleInBetweenTurns()) {
          this.selectNextCyclist();
        }
      }
      this.dice = Dice(this.spriteManager, this, difficulty: settings.difficulty, isPlayer: cyclistSelected?.cyclist?.team?.isPlayer);
      this.dice2 = Dice(this.spriteManager, this, difficulty: settings.difficulty, isPlayer: cyclistSelected?.cyclist?.team?.isPlayer);
      if (screenSize != null) {
        if (this.settings.cameraMovement != CameraMovementType.NONE) {
          offset = -((cyclistSelected.p1 + cyclistSelected.p2) / 2 * tileSize - Offset(screenSize.width, screenSize.height) / 2 / zoom);
          checkBounds();
        }
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
    diceValueCooldown = 2.5;
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
      offset += Offset(-offset.dx - worldSize.width + screenSize.width / zoom, 0);
    }
    if (-offset.dy > worldSize.height - screenSize.height / zoom) {
      offset += Offset(0, -offset.dy - worldSize.height + screenSize.height / zoom);
    }
    if (-offset.dx < 0) {
      offset -= Offset(offset.dx, 0);
    }
    if (-offset.dy < 0) {
      offset -= Offset(0, offset.dy);
    }
  }

  @override
  void selectPosition(List<Position> route) {
    if (cyclistSelected != null) {
      moveAnimation = route;
      cyclistMoved = route.length.toDouble() - 1;
      map.setState(PositionState.NORMAL);
      processGameState(GameState.USER_WAIT_CYCLIST_MOVING);
    }
  }

  @override
  void diceStopped() {
    this.diceValue = this.dice.getValue() + this.dice2.getValue();
    if (gameState == GameState.USER_WAIT_DICE_ROLLING2) {
      processGameState(GameState.USER_INPUT_DICE_DONE);
    } else {
      processGameState(GameState.USER_WAIT_DICE_ROLLING2);
    }
  }

  @override
  void onTapDown(TapDownDetails details) {
    buttons.forEach((button) {
      button.onTapDown(details.globalPosition);
    });
  }

  static CyclingView fromJson(Map<String, dynamic> json, SpriteManager spriteManager, Function cyclingEnded, Function navigate, Settings settings, Function openTutorial) {
    List<Position> existingPositions = [];
    List<Sprint> existingSprints = [];
    List<Cyclist> existingCyclists = [];
    List<Team> existingTeams = [];

    if (json == null || json['map'] == null) {
      return null;
    }
    CyclingView cyclingView = CyclingView(spriteManager, cyclingEnded, navigate, settings, openTutorial);
    if (json['teams'] != null) {
      cyclingView.teams = [];
      json['teams'].forEach((j) {
        cyclingView.teams.add(Team.fromJson(j, existingCyclists, existingTeams, spriteManager));
      });
    }
    cyclingView.map = GameMap.fromJson(json['map'], existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, cyclingView);
    cyclingView.diceValue = json['diceValue'];
    cyclingView.currentTurn = json['currentTurn'];
    cyclingView.grid = json['grid'] == true;
    cyclingView.ended = json['ended'];
    cyclingView.moving = json['moving'];
    cyclingView.autoFollow = json['autoFollow'];
    cyclingView.hasResults = json['hasResults'];
    cyclingView.openFollowSelect = json['openFollowSelect'];
    cyclingView.dice = Dice.fromJson(json['dice'], cyclingView, spriteManager);
    cyclingView.dice2 = Dice.fromJson(json['dice2'], cyclingView, spriteManager);
    cyclingView.worldSize = SaveUtil.sizeFromJson(json['worldSize']);
    cyclingView.mapSize = SaveUtil.sizeFromJson(json['mapSize']);
    cyclingView.offset = SaveUtil.offsetFromJson(json['offset']);
    cyclingView.zoom = json['zoom'];
    cyclingView.inCareer = json['inCareer'];
    cyclingView.movingTimer = json['movingTimer'];
    cyclingView.tileSize = json['tileSize'];
    cyclingView.cyclistMoved = json['cyclistMoved'];
    cyclingView.diceValueCooldown = json['diceValueCooldown'];
    cyclingView.movingCyclist = Cyclist.fromJson(json['movingCyclist'], existingCyclists, existingTeams, spriteManager);
    cyclingView.tempResults = Results.fromJson(json['tempResults'], existingCyclists, existingTeams, spriteManager);
    cyclingView.startResults = Results.fromJson(json['startResults'], existingCyclists, existingTeams, spriteManager);
    cyclingView.cyclistSelected = Position.fromJson(json['cyclistSelected'], existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, cyclingView);
    cyclingView.cyclistLastSelected =
        Position.fromJson(json['cyclistLastSelected'], existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, cyclingView);
    cyclingView.gameState = getGameStateFromString(json['gameState']);
    cyclingView.careerRaceType = RaceType.fromJson(json['careerRaceType']);
    cyclingView.followSelect = json['followSelect'];

    if (json['moveAnimation'] != null) {
      cyclingView.moveAnimation = [];
      json['moveAnimation'].forEach((j) {
        cyclingView.moveAnimation.add(Position.fromJson(j, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, cyclingView));
      });
    }

    if (json['notifications'] != null) {
      cyclingView.notifications = [];
      json['notifications'].forEach((j) {
        cyclingView.notifications.add(Notification.fromJson(j));
      });
    }

    cyclingView.tempResults?.data?.forEach((element) {
      if (element.team.isPlaceHolder) {
        element.team = existingTeams.firstWhere((existing) => existing.id == element.team.id, orElse: () => element.team);
      }
    });
    cyclingView.startResults?.data?.forEach((element) {
      if (element.team.isPlaceHolder) {
        element.team = existingTeams.firstWhere((existing) => existing.id == element.team.id, orElse: () => element.team);
      }
    });
    cyclingView.map.sprints?.forEach((sprint) {
      sprint.cyclistPlaces.forEach((element) {
        if (element.cyclist.isPlaceHolder) {
          element.cyclist = existingCyclists.firstWhere((existing) => existing.id == element.cyclist.id, orElse: () => element.cyclist);
        }
      });
    });
    existingPositions.forEach((element) {
      if (element.cyclist?.isPlaceHolder == true) {
        element.cyclist = existingCyclists.firstWhere((existing) => existing.id == element.cyclist.id, orElse: () => element.cyclist);
      }
      if (element.sprint?.isPlaceHolder == true) {
        element.sprint = existingSprints.firstWhere((existing) => existing.id == element.sprint.id, orElse: () => element.sprint);
      }
      for (int i = 0; i < element.connections.length; i++) {
        if (element.connections[i].isPlaceHolder) {
          element.connections[i] = existingPositions.firstWhere((existing) => existing.id == element.connections[i].id, orElse: () => element.connections[i]);
        }
      }
      for (int i = 0; i < element.route.length; i++) {
        if (element.route[i].isPlaceHolder) {
          element.route[i] = existingPositions.firstWhere((existing) => existing.id == element.route[i].id, orElse: () => element.route[i]);
        }
      }
    });
    existingCyclists.forEach((element) {
      if (element.team.isPlaceHolder) {
        element.team = existingTeams.firstWhere((existing) => existing.id == element.team.id, orElse: () => element.team);
      }
      if (element.lastPosition?.isPlaceHolder == true) {
        element.lastPosition = existingPositions.firstWhere((existing) => existing.id == element.lastPosition.id, orElse: () => element.lastPosition);
      }
    });
    existingTeams.forEach((team) {
      for (int i = 0; i < team.cyclists.length; i++) {
        if (team.cyclists[i].isPlaceHolder) {
          team.cyclists[i] = existingCyclists.firstWhere((existing) => existing.id == team.cyclists[i].id, orElse: () => team.cyclists[i]);
        }
      }
    });

    return cyclingView;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grid'] = this.grid;
    data['diceValue'] = this.diceValue;
    data['currentTurn'] = this.currentTurn;
    data['ended'] = this.ended;
    data['moving'] = this.moving;
    data['autoFollow'] = this.autoFollow;
    data['hasResults'] = this.hasResults;
    data['openFollowSelect'] = this.followSelect != null;
    data['zoom'] = this.zoom;
    data['inCareer'] = this.inCareer;
    data['movingTimer'] = this.movingTimer;
    data['cyclistMoved'] = this.cyclistMoved;
    data['diceValueCooldown'] = this.diceValueCooldown;

    data['careerRaceType'] = this.careerRaceType?.toJson();

    data['offset'] = SaveUtil.offsetToJson(this.offset);
    data['worldSize'] = SaveUtil.sizeToJson(this.worldSize);
    data['mapSize'] = SaveUtil.sizeToJson(this.mapSize);

    data['gameState'] = this.gameState.toString();

    data['dice'] = this.dice != null ? this.dice.toJson() : null;
    data['dice2'] = this.dice2 != null ? this.dice2.toJson() : null;
    data['map'] = this.map != null ? this.map.toJson() : null;
    data['movingCyclist'] = this.movingCyclist != null ? this.movingCyclist.toJson(true) : null;
    data['tempResults'] = this.tempResults != null ? this.tempResults.toJson() : null;
    data['startResults'] = this.startResults != null ? this.startResults.toJson() : null;
    data['cyclistSelected'] = this.cyclistSelected != null ? this.cyclistSelected.toJson(true) : null;
    data['cyclistLastSelected'] = this.cyclistLastSelected != null ? this.cyclistLastSelected.toJson(true) : null;

    data['teams'] = this.teams?.map((i) => i.toJson(false))?.toList();
    data['moveAnimation'] = this.moveAnimation?.map((i) => i.toJson(true))?.toList();
    data['notifications'] = this.notifications?.map((i) => i.toJson())?.toList();

    return data;
  }
}

GameState getGameStateFromString(String gameStateAsString) {
  for (GameState element in GameState.values) {
    if (element.toString() == gameStateAsString) {
      return element;
    }
  }
  return null;
}

enum GameState {
  USER_INPUT_DICE_START,
  USER_WAIT_DICE_ROLLING,
  USER_WAIT_DICE_ROLLING2,
  USER_INPUT_DICE_DONE,
  USER_INPUT_POSITION_CHOICE,
  USER_WAIT_CYCLIST_MOVING,
  USER_WAIT_CYCLIST_MOVING_FINISHED,
  USER_INPUT_CYCLIST_FOLLOW,
  GAME_SELECT_NEXT,
}

class Notification {
  String text;
  Color color;

  Notification(this.text, this.color);

  static Notification fromJson(Map<String, dynamic> json) {
    return Notification(json['text'], SaveUtil.colorFromJson(json['color']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['color'] = SaveUtil.colorToJson(this.color);
    return data;
  }
}
