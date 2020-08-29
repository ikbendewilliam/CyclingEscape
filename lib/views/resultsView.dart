import 'dart:ui';

import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/resultData.dart';
import 'package:CyclingEscape/components/data/results.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/positions/sprint.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/saveUtil.dart';
import 'package:CyclingEscape/views/baseView.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'gameManager.dart';
import 'menus/careerMenu.dart';

class ResultsView implements BaseView {
  final Function closeCallback;

  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  int cyclistNumber;
  bool isPaused = false;
  bool lastResultsAdded = false;
  Sprite background;
  Sprite backgroundHeader;
  Sprite backgroundCyclist;
  Sprite backgroundSlider;
  Sprite sliderFront;
  Sprite iconMountain;
  Sprite iconTeam;
  Sprite iconTime;
  Sprite iconPoints;
  Sprite iconRank;
  Sprite iconNumber;
  Sprite iconYoung;
  double scroll = 0;
  double scrollStart = 0;
  Career career;
  ActiveTour activeTour;
  ResultsType type = ResultsType.RACE;
  List<Button> buttons = [];
  List<Sprint> sprints = [];
  List<Results> results = [];

  ResultsView(this.spriteManager, this.closeCallback, this.career);

  calculateResults(bool inCareer) {
    if (lastResultsAdded) {
      return;
    }
    lastResultsAdded = true;
    sprints.forEach((sprint) {
      sprint.cyclistPlaces.sort((a, b) => (b.value - a.value).round());
    });
    Results raceResults = Results(ResultsType.RACE);
    Sprint finish = sprints.firstWhere(
        (element) => element.type == SprintType.FINISH,
        orElse: () => null);
    if (finish != null) {
      finish.cyclistPlaces.asMap().forEach((i, element) {
        int points = finish.getPoints(i);
        raceResults.data.add(ResultData(i, element.getTurns(), points, 0,
            element.cyclist.number, element.cyclist.team));
      });
    }
    sprints
        .where((element) =>
            element.type == SprintType.SPRINT ||
            element.type == SprintType.MOUNTAIN_SPRINT)
        .toList()
        .forEach((sprint) {
      sprint.cyclistPlaces.asMap().forEach((i, element) {
        int points = sprint.getPoints(i);
        if (sprint.type == SprintType.SPRINT && points > 0) {
          ResultData data = raceResults.data
              .firstWhere((result) => result.number == element.cyclist.number);
          data.points += points;
        } else if (sprint.type == SprintType.MOUNTAIN_SPRINT && points > 0) {
          ResultData data = raceResults.data
              .firstWhere((result) => result.number == element.cyclist.number);
          data.mountain += points;
        }
      });
    });
    this.results = [raceResults];

    if (activeTour != null && activeTour.currentResults != null) {
      raceResults.data.forEach((result) {
        ResultData currentResult = activeTour.currentResults.data.firstWhere(
            (element) => element.number == result.number,
            orElse: () => null);
        if (currentResult == null) {
          currentResult =
              ResultData(result.rank, 0, 0, 0, result.number, result.team);
          activeTour.currentResults.data.add(currentResult);
        }
        currentResult.time += result.time;
        currentResult.points += result.points;
        currentResult.mountain += result.mountain;
      });
      activeTour.currentResults.data.sort((a, b) => a.time - b.time);
    }

    Results timeResults = Results(ResultsType.TIME);
    timeResults.data = (activeTour != null && activeTour.currentResults != null)
        ? activeTour.currentResults.data
        : raceResults.data;
    this.results.add(timeResults);

    Results youngResults = Results(ResultsType.YOUNG);
    if (career.rankingTypes > 4 || !inCareer) {
      youngResults.data = timeResults.data
          .where((element) => element.number % 10 <= 2)
          .map((e) => e.copy())
          .toList();
      youngResults.data.sort((a, b) => a.time - b.time);
      if (youngResults.data.length > 0 &&
          activeTour != null &&
          activeTour.currentResults != null) {
        activeTour.currentResults.whiteJersey = youngResults.data.first.number;
      }
    }
    this.results.add(youngResults);

    Results pointsResults = Results(ResultsType.POINTS);
    if (career.rankingTypes > 1 || !inCareer) {
      pointsResults.data = timeResults.data
          .where((element) => element.points > 0)
          .map((e) => e.copy())
          .toList();
      pointsResults.data.sort((a, b) => b.points - a.points);
      if (youngResults.data.length > 0 &&
          activeTour != null &&
          activeTour.currentResults != null) {
        activeTour.currentResults.greenJersey = pointsResults.data.first.number;
      }
    }
    this.results.add(pointsResults);

    Results mountainResults = Results(ResultsType.MOUNTAIN);
    if (career.rankingTypes > 3 || !inCareer) {
      mountainResults.data = timeResults.data
          .where((element) => element.mountain > 0)
          .map((e) => e.copy())
          .toList();
      mountainResults.data.sort((a, b) => b.mountain - a.mountain);
      if (mountainResults.data.length > 0 &&
          activeTour != null &&
          activeTour.currentResults != null) {
        activeTour.currentResults.bouledJersey =
            mountainResults.data.first.number;
      }
    }
    this.results.add(mountainResults);

    Results teamResults = Results(ResultsType.TEAM);
    if (career.rankingTypes > 3 || !inCareer) {
      List<Team> teams =
          timeResults.data.map((element) => element.team).toList();
      teams.forEach((team) {
        if (teamResults.data.where((element) => element.team == team).length ==
            0) {
          ResultData resultData = ResultData();
          timeResults.data
              .where((element) => element.team == team)
              .forEach((element) => resultData.time += element.time);
          resultData.team = team;
          teamResults.data.add(resultData);
        }
      });
      teamResults.data.sort((a, b) => a.time - b.time);
    }
    this.results.add(teamResults);

    this.results.forEach((result) {
      result.data.asMap().forEach((rank, value) => value = ResultData(rank,
          value.time, value.points, value.mountain, value.number, value.team));
    });

    if (activeTour != null) {
      SaveUtil.saveTour(activeTour);
    }
  }

  @override
  void onAttach([bool inCareer]) {
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    background = this.spriteManager.getSprite('back_results.png');
    backgroundHeader = this.spriteManager.getSprite('back_text_01.png');
    backgroundCyclist = this.spriteManager.getSprite('back_text_04.png');
    backgroundSlider = this.spriteManager.getSprite('back_slider.png');
    sliderFront = this.spriteManager.getSprite('slider_front.png');
    iconMountain = this.spriteManager.getSprite('icon_mountain.png');
    iconTeam = this.spriteManager.getSprite('icon_team.png');
    iconTime = this.spriteManager.getSprite('icon_time.png');
    iconPoints = this.spriteManager.getSprite('icon_points.png');
    iconRank = this.spriteManager.getSprite('icon_rank.png');
    iconNumber = this.spriteManager.getSprite('icon_number.png');
    iconYoung = this.spriteManager.getSprite('icon_young.png');
    type = ResultsType.RACE;

    calculateResults(inCareer);
    createButtons();
  }

  decreaseResultType() {
    scroll = 0;
    switch (type) {
      case ResultsType.RACE:
        type = ResultsType.TEAM;
        break;
      case ResultsType.TIME:
        type = ResultsType.RACE;
        break;
      case ResultsType.YOUNG:
        type = ResultsType.TIME;
        break;
      case ResultsType.POINTS:
        type = ResultsType.YOUNG;
        break;
      case ResultsType.MOUNTAIN:
        type = ResultsType.POINTS;
        break;
      case ResultsType.TEAM:
        type = ResultsType.MOUNTAIN;
        break;
      default:
        type = ResultsType.RACE;
    }
    Results selectedResult = results
        .firstWhere((element) => element.type == type, orElse: () => null);
    if (selectedResult == null ||
        (selectedResult.data.length == 0 &&
            selectedResult.type != ResultsType.RACE)) {
      decreaseResultType();
    }
  }

  increaseResultType() {
    scroll = 0;
    switch (type) {
      case ResultsType.RACE:
        type = ResultsType.TIME;
        break;
      case ResultsType.TIME:
        type = ResultsType.YOUNG;
        break;
      case ResultsType.YOUNG:
        type = ResultsType.POINTS;
        break;
      case ResultsType.POINTS:
        type = ResultsType.MOUNTAIN;
        break;
      case ResultsType.MOUNTAIN:
        type = ResultsType.TEAM;
        break;
      case ResultsType.TEAM:
        type = ResultsType.RACE;
        break;
      default:
        type = ResultsType.RACE;
    }
    Results selectedResult = results
        .firstWhere((element) => element.type == type, orElse: () => null);
    if (selectedResult == null ||
        (selectedResult.data.length == 0 &&
            selectedResult.type != ResultsType.RACE)) {
      increaseResultType();
    }
  }

  createButtons() {
    buttons = [];
    buttons.add(Button(
        this.spriteManager,
        Offset(screenSize.width / 5, screenSize.height / 2),
        ButtonType.ICON_LEFT,
        () => {decreaseResultType()}));
    buttons.add(Button(
        this.spriteManager,
        Offset(screenSize.width * 4 / 5, screenSize.height / 2),
        ButtonType.ICON_RIGHT,
        () => {increaseResultType()}));
    if (isPaused) {
      buttons.add(Button(
          this.spriteManager,
          Offset(screenSize.width * 3.1 / 4, screenSize.height / 6),
          ButtonType.ICON_NO,
          () => closeCallback(GameManagerState.PLAYING, continueing: true)));
    } else {
      buttons.add(Button(
          this.spriteManager,
          Offset(screenSize.width * 3.1 / 4, screenSize.height / 6),
          ButtonType.ICON_NO, () {
        closeCallback(activeTour != null
            ? GameManagerState.TOUR_BETWEEN_RACES
            : GameManagerState.MAIN_MENU);
        activeTour = null;
      }));
    }
    buttons.forEach((element) {
      element.setScreenSize(screenSize);
    });
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
    buttons.forEach((button) {
      button.onTapDown(details.focalPoint);
    });
    scroll += (scrollStart - details.focalPoint.dy) / (screenSize.height / 3);
    if (scroll > 1) {
      scroll = 1;
    } else if (scroll < 0) {
      scroll = 0;
    }
    scrollStart = details.focalPoint.dy;
  }

  @override
  void onScaleStart(ScaleStartDetails details) {
    scrollStart = details.focalPoint.dy;
  }

  @override
  void onTapUp(TapUpDetails details) {
    buttons.forEach((button) {
      button.onTapUp(details);
    });
  }

  void onTapDown(TapDownDetails details) {
    buttons.forEach((button) {
      button.onTapDown(details.globalPosition);
    });
  }

  getTypeAsString() {
    switch (type) {
      case ResultsType.TIME:
        return 'Time';
      case ResultsType.YOUNG:
        return 'Young riders';
      case ResultsType.POINTS:
        return 'Points';
      case ResultsType.MOUNTAIN:
        return 'Mountain';
      case ResultsType.TEAM:
        return 'Team';
      case ResultsType.RACE:
      default:
        return 'Results';
    }
  }

  @override
  void render(Canvas canvas) {
    double buttonSize = screenSize.height / 7;

    background.renderPosition(
        canvas, Position(screenSize.width / 6, buttonSize / 2),
        size:
            Position(screenSize.width / 6 * 4, screenSize.height - buttonSize));
    backgroundHeader.renderPosition(
        canvas, Position(screenSize.width / 3, buttonSize / 4),
        size: Position(screenSize.width / 3, buttonSize));

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: getTypeAsString());
    Offset position = Offset(screenSize.width / 2, buttonSize / 2);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundSlider.renderPosition(
        canvas, Position(screenSize.width / 6 * 4.15, buttonSize * 2.3),
        size: Position(buttonSize / 2, screenSize.height / 1.9));

    sliderFront.renderPosition(
        canvas,
        Position(
            screenSize.width / 6 * 4.15,
            buttonSize * 2.3 +
                scroll * (screenSize.height / 1.9 - buttonSize / 2)),
        size: Position(buttonSize, buttonSize) / 2);

    buttons.forEach((button) {
      button.render(canvas);
    });

    renderIcons(canvas);
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(
        0, buttonSize * 1.2 * 1.9, screenSize.width, buttonSize * 6));
    renderCyclists(canvas);
    canvas.restore();
  }

  renderIcons(Canvas canvas) {
    double buttonSize = screenSize.height / 7;
    double i = 0;
    renderIcon(canvas, iconRank, i++, buttonSize);
    renderIcon(canvas, iconNumber, i++, buttonSize);
    if (type == ResultsType.TIME ||
        type == ResultsType.RACE ||
        type == ResultsType.YOUNG ||
        type == ResultsType.TEAM) {
      renderIcon(canvas, iconTime, i++, buttonSize);
    }
    if (type == ResultsType.POINTS || type == ResultsType.RACE) {
      renderIcon(canvas, iconPoints, i++, buttonSize);
    }
    if (type == ResultsType.MOUNTAIN || type == ResultsType.RACE) {
      renderIcon(canvas, iconMountain, i++, buttonSize);
    }
  }

  renderIcon(Canvas canvas, Sprite sprite, double position, double buttonSize) {
    sprite.renderPosition(
        canvas,
        Position(
            screenSize.width / 3.6 + buttonSize * position, buttonSize * 1.2),
        size: Position(buttonSize, buttonSize));
  }

  renderCyclists(Canvas canvas) {
    Results selectedResult = results
        .firstWhere((element) => element.type == type, orElse: () => null);
    if (selectedResult != null) {
      cyclistNumber = selectedResult.data.length;

      double i = (6 - cyclistNumber) * scroll;
      if (cyclistNumber <= 6) {
        i = 0;
      }
      int firstTime = selectedResult.data.fold(
          9999,
          (previousValue, element) =>
              previousValue < element.time ? previousValue : element.time);
      selectedResult.data.asMap().forEach((index, element) {
        String time = '';
        if (index == 0) {
          time = element.time.toString();
          firstTime = element.time;
        } else {
          time = '+' + (-(firstTime - element.time)).toString();
        }
        renderCyclist(
            canvas,
            i++,
            element.team.getColor(),
            '${index + 1}.',
            '${type == ResultsType.TEAM ? (element.team.numberStart + 2) * 10 : element.number}',
            time,
            '${element.points}',
            '${element.mountain}');
      });
    }
  }

  renderCyclist(Canvas canvas, double yOffset, Color teamColor, String rank,
      String number, String time, String points, String mountain) {
    double buttonSize = screenSize.height / 7;
    backgroundCyclist.renderPosition(
        canvas,
        Position(
            screenSize.width / 3.6, buttonSize * 1.2 * (yOffset / 2 + 1.9)),
        size: Position(screenSize.width / 2.5, buttonSize / 1.5));
    double i = 0;
    renderCyclistText(canvas, yOffset, teamColor, rank, i++);
    renderCyclistText(canvas, yOffset, teamColor, number, i++);
    if (type == ResultsType.TIME ||
        type == ResultsType.RACE ||
        type == ResultsType.YOUNG ||
        type == ResultsType.TEAM) {
      renderCyclistText(canvas, yOffset, teamColor, time, i++);
    }
    if (type == ResultsType.POINTS || type == ResultsType.RACE) {
      renderCyclistText(canvas, yOffset, teamColor, points, i++);
    }
    if (type == ResultsType.MOUNTAIN || type == ResultsType.RACE) {
      renderCyclistText(canvas, yOffset, teamColor, mountain, i++);
    }
  }

  renderCyclistText(Canvas canvas, double yOffset, Color teamColor, String text,
      double position) {
    double buttonSize = screenSize.height / 7;
    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: teamColor, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: text);
    CanvasUtils.drawText(
        canvas,
        Offset(screenSize.width / 3.6 + buttonSize * (position + 0.5),
            buttonSize * 1.2 * (yOffset / 2 + 2)),
        0,
        span);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}

ResultsType getResultsTypeFromString(String resultsTypeAsString) {
  for (ResultsType element in ResultsType.values) {
    if (element.toString() == resultsTypeAsString) {
      return element;
    }
  }
  return null;
}

enum ResultsType { RACE, TOUR, TIME, YOUNG, POINTS, MOUNTAIN, TEAM }
