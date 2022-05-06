import 'package:collection/collection.dart';
import 'package:cycling_escape/screen_game/baseView.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/activeTour.dart';
import 'package:cycling_escape/widget_game/data/resultData.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'gameManager.dart';
import 'menus/careerMenu.dart';

class ResultsView implements BaseView {
  final Function closeCallback;

  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;

  late int cyclistNumber;
  bool isPaused = false;
  bool lastResultsAdded = false;
  Sprite? background;
  Sprite? backgroundHeader;
  Sprite? backgroundCyclist;
  Sprite? backgroundSlider;
  Sprite? sliderFront;
  Sprite? iconMountain;
  Sprite? iconTeam;
  Sprite? iconTime;
  Sprite? iconPoints;
  Sprite? iconRank;
  Sprite? iconNumber;
  Sprite? iconYoung;
  double scroll = 0;
  double scrollStart = 0;
  Career career;
  ActiveTour? activeTour;
  ResultsType type = ResultsType.race;
  List<Button> buttons = [];
  List<Sprint?> sprints = [];
  List<Results?> results = [];
  Localization localizations;

  ResultsView(this.spriteManager, this.closeCallback, this.career, this.localizations);

  void calculateResults(bool? inCareer) {
    if (lastResultsAdded) {
      return;
    }
    lastResultsAdded = true;
    for (final sprint in sprints) {
      sprint!.cyclistPlaces.sort((a, b) => (b!.value! - a!.value!).round());
    }
    final Results raceResults = Results(ResultsType.race);
    final Sprint? finish = sprints.firstWhereOrNull(((element) => element!.type == SprintType.finish));
    if (finish != null) {
      finish.cyclistPlaces.asMap().forEach((i, element) {
        final int points = finish.getPoints(i);
        raceResults.data.add(ResultData(i, element!.getTurns(), points, 0, element.cyclist!.number, element.cyclist!.team));
      });
    }
    sprints.where((element) => element!.type == SprintType.sprint || element.type == SprintType.mountainSprint).toList().forEach((sprint) {
      sprint!.cyclistPlaces.asMap().forEach((i, element) {
        final int points = sprint.getPoints(i);
        if (sprint.type == SprintType.sprint && points > 0) {
          final ResultData data = raceResults.data.firstWhere((result) => result!.number == element!.cyclist!.number)!;
          data.points += points;
        } else if (sprint.type == SprintType.mountainSprint && points > 0) {
          final ResultData data = raceResults.data.firstWhere((result) => result!.number == element!.cyclist!.number)!;
          data.mountain += points;
        }
      });
    });
    results = [raceResults];

    if (activeTour != null && activeTour!.currentResults != null) {
      for (final result in raceResults.data) {
        ResultData? currentResult = activeTour!.currentResults!.data.firstWhereOrNull(((element) => element!.number == result!.number));
        if (currentResult == null) {
          currentResult = ResultData(result!.rank, 0, 0, 0, result.number, result.team);
          activeTour!.currentResults!.data.add(currentResult);
        }
        currentResult.time += result!.time;
        currentResult.points += result.points;
        currentResult.mountain += result.mountain;
      }
      activeTour!.currentResults!.data.sort((a, b) => a!.time - b!.time);
    }

    final Results timeResults = Results(ResultsType.time);
    timeResults.data = (activeTour != null && activeTour!.currentResults != null) ? activeTour!.currentResults!.data : raceResults.data;
    results.add(timeResults);

    final Results youngResults = Results(ResultsType.young);
    if (career.rankingTypes > 4 || !inCareer!) {
      youngResults.data = timeResults.data.where((element) => element!.number % 10 <= 2).map((e) => e!.copy()).toList();
      youngResults.data.sort((a, b) => a!.time - b!.time);
      if (youngResults.data.isNotEmpty && activeTour != null && activeTour!.currentResults != null) {
        activeTour!.currentResults!.whiteJersey = youngResults.data.first!.number;
      }
    }
    results.add(youngResults);

    final Results pointsResults = Results(ResultsType.points);
    if (career.rankingTypes > 1 || !inCareer!) {
      pointsResults.data = timeResults.data.where((element) => element!.points > 0).map((e) => e!.copy()).toList();
      pointsResults.data.sort((a, b) => b!.points - a!.points);
      if (youngResults.data.isNotEmpty && activeTour != null && activeTour!.currentResults != null) {
        activeTour!.currentResults!.greenJersey = pointsResults.data.first!.number;
      }
    }
    results.add(pointsResults);

    final Results mountainResults = Results(ResultsType.mountain);
    if (career.rankingTypes > 3 || !inCareer!) {
      mountainResults.data = timeResults.data.where((element) => element!.mountain > 0).map((e) => e!.copy()).toList();
      mountainResults.data.sort((a, b) => b!.mountain - a!.mountain);
      if (mountainResults.data.isNotEmpty && activeTour != null && activeTour!.currentResults != null) {
        activeTour!.currentResults!.bouledJersey = mountainResults.data.first!.number;
      }
    }
    results.add(mountainResults);

    final Results teamResults = Results(ResultsType.team);
    if (career.rankingTypes > 3 || !inCareer!) {
      final List<Team?> teams = timeResults.data.map((element) => element!.team).toList();
      for (final team in teams) {
        if (teamResults.data.where((element) => element!.team == team).isEmpty) {
          final ResultData resultData = ResultData();
          timeResults.data.where((element) => element!.team == team).forEach((element) => resultData.time += element!.time);
          resultData.team = team;
          teamResults.data.add(resultData);
        }
      }
      teamResults.data.sort((a, b) => a!.time - b!.time);
    }
    results.add(teamResults);

    for (final result in results) {
      result!.data.asMap().forEach((rank, value) => value = ResultData(rank, value!.time, value.points, value.mountain, value.number, value.team));
    }

    if (activeTour != null) {
      SaveUtil.saveTour(activeTour!);
    }
  }

  @override
  void onAttach([bool? inCareer]) {
    screenSize ??= const Size(1, 1);
    background = spriteManager.getSprite('back_results.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
    backgroundCyclist = spriteManager.getSprite('back_text_04.png');
    backgroundSlider = spriteManager.getSprite('back_slider.png');
    sliderFront = spriteManager.getSprite('slider_front.png');
    iconMountain = spriteManager.getSprite('icon_mountain.png');
    iconTeam = spriteManager.getSprite('icon_team.png');
    iconTime = spriteManager.getSprite('icon_time.png');
    iconPoints = spriteManager.getSprite('icon_points.png');
    iconRank = spriteManager.getSprite('icon_rank.png');
    iconNumber = spriteManager.getSprite('icon_number.png');
    iconYoung = spriteManager.getSprite('icon_young.png');
    type = ResultsType.race;

    calculateResults(inCareer);
    createButtons();
  }

  void decreaseResultType() {
    scroll = 0;
    switch (type) {
      case ResultsType.race:
        type = ResultsType.team;
        break;
      case ResultsType.time:
        type = ResultsType.race;
        break;
      case ResultsType.young:
        type = ResultsType.time;
        break;
      case ResultsType.points:
        type = ResultsType.young;
        break;
      case ResultsType.mountain:
        type = ResultsType.points;
        break;
      case ResultsType.team:
        type = ResultsType.mountain;
        break;
      default:
        type = ResultsType.race;
    }
    final Results? selectedResult = results.firstWhereOrNull(((element) => element!.type == type));
    if (selectedResult == null || (selectedResult.data.isEmpty && selectedResult.type != ResultsType.race)) {
      decreaseResultType();
    }
  }

  void increaseResultType() {
    scroll = 0;
    switch (type) {
      case ResultsType.race:
        type = ResultsType.time;
        break;
      case ResultsType.time:
        type = ResultsType.young;
        break;
      case ResultsType.young:
        type = ResultsType.points;
        break;
      case ResultsType.points:
        type = ResultsType.mountain;
        break;
      case ResultsType.mountain:
        type = ResultsType.team;
        break;
      case ResultsType.team:
        type = ResultsType.race;
        break;
      default:
        type = ResultsType.race;
    }
    final Results? selectedResult = results.firstWhereOrNull(((element) => element!.type == type));
    if (selectedResult == null || (selectedResult.data.isEmpty && selectedResult.type != ResultsType.race)) {
      increaseResultType();
    }
  }

  void createButtons() {
    buttons = [];
    buttons.add(Button(spriteManager, Offset(screenSize!.width / 5, screenSize!.height / 2), ButtonType.iconLeft, () => {decreaseResultType()}));
    buttons.add(Button(spriteManager, Offset(screenSize!.width * 4 / 5, screenSize!.height / 2), ButtonType.iconRight, () => {increaseResultType()}));
    if (isPaused) {
      buttons.add(
          Button(spriteManager, Offset(screenSize!.width * 3.1 / 4, screenSize!.height / 6), ButtonType.iconNo, () => closeCallback(GameManagerState.playing, continueing: true)));
    } else {
      buttons.add(Button(spriteManager, Offset(screenSize!.width * 3.1 / 4, screenSize!.height / 6), ButtonType.iconNo, () {
        closeCallback(activeTour != null ? GameManagerState.tourBetweenRaces : GameManagerState.mainMenu);
        activeTour = null;
      }));
    }
    for (final element in buttons) {
      element.setScreenSize(screenSize!);
    }
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    for (final button in buttons) {
      button.onTapDown(info.raw.focalPoint);
    }
    scroll += (scrollStart - info.raw.focalPoint.dy) / (screenSize!.height / 3);
    if (scroll > 1) {
      scroll = 1;
    } else if (scroll < 0) {
      scroll = 0;
    }
    scrollStart = info.raw.focalPoint.dy;
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    scrollStart = info.raw.focalPoint.dy;
  }

  @override
  void onTapUp(TapUpInfo details) {
    for (final button in buttons) {
      button.onTapUp(details);
    }
  }

  @override
  void onTapDown(TapDownInfo details) {
    for (final button in buttons) {
      button.onTapDown(details.raw.globalPosition);
    }
  }

  String getTypeAsString() {
    switch (type) {
      case ResultsType.time:
        return localizations.resultsTimeTitle;
      case ResultsType.young:
        return localizations.resultsYoungRidersTitle;
      case ResultsType.points:
        return localizations.resultsPointsTitle;
      case ResultsType.mountain:
        return localizations.resultsMountainTitle;
      case ResultsType.team:
        return localizations.resultsTeamTitle;
      case ResultsType.race:
      default:
        return localizations.resultsTitle;
    }
  }

  @override
  void render(Canvas canvas) {
    final double buttonSize = screenSize!.height / 7;

    background!.render(canvas, position: Vector2(screenSize!.width / 6, buttonSize / 2), size: Vector2(screenSize!.width / 6 * 4, screenSize!.height - buttonSize));
    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize / 4), size: Vector2(screenSize!.width / 3, buttonSize));

    final TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: getTypeAsString());
    final Offset position = Offset(screenSize!.width / 2, buttonSize / 2);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundSlider!.render(canvas, position: Vector2(screenSize!.width / 6 * 4.15, buttonSize * 2.3), size: Vector2(buttonSize / 2, screenSize!.height / 1.9));

    sliderFront!.render(canvas,
        position: Vector2(screenSize!.width / 6 * 4.15, buttonSize * 2.3 + scroll * (screenSize!.height / 1.9 - buttonSize / 2)), size: Vector2(buttonSize, buttonSize) / 2);

    for (final button in buttons) {
      button.render(canvas);
    }

    renderIcons(canvas);
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, buttonSize * 1.2 * 1.9, screenSize!.width, buttonSize * 6));
    renderCyclists(canvas);
    canvas.restore();
  }

  void renderIcons(Canvas canvas) {
    final buttonSize = screenSize!.height / 7;
    double i = 0;
    renderIcon(canvas, iconRank!, i++, buttonSize);
    renderIcon(canvas, iconNumber!, i++, buttonSize);
    if (type == ResultsType.time || type == ResultsType.race || type == ResultsType.young || type == ResultsType.team) {
      renderIcon(canvas, iconTime!, i++, buttonSize);
    }
    if (type == ResultsType.points || type == ResultsType.race) {
      renderIcon(canvas, iconPoints!, i++, buttonSize);
    }
    if (type == ResultsType.mountain || type == ResultsType.race) {
      renderIcon(canvas, iconMountain!, i++, buttonSize);
    }
  }

  void renderIcon(Canvas canvas, Sprite sprite, double position, double buttonSize) {
    sprite.render(canvas, position: Vector2(screenSize!.width / 3.6 + buttonSize * position, buttonSize * 1.2), size: Vector2(buttonSize, buttonSize));
  }

  void renderCyclists(Canvas canvas) {
    final Results? selectedResult = results.firstWhereOrNull(((element) => element!.type == type));
    if (selectedResult != null) {
      cyclistNumber = selectedResult.data.length;

      double i = (6 - cyclistNumber) * scroll;
      if (cyclistNumber <= 6) {
        i = 0;
      }
      int firstTime = selectedResult.data.fold(9999, (previousValue, element) => previousValue < element!.time ? previousValue : element.time);
      selectedResult.data.asMap().forEach((index, element) {
        String time = '';
        if (index == 0) {
          time = element!.time.toString();
          firstTime = element.time;
        } else {
          time = '+' + (-(firstTime - element!.time)).toString();
        }
        renderCyclist(canvas, i++, element.team!.getColor(), '${index + 1}.', '${type == ResultsType.team ? (element.team!.numberStart! + 2) * 10 : element.number}', time,
            '${element.points}', '${element.mountain}');
      });
    }
  }

  void renderCyclist(Canvas canvas, double yOffset, Color teamColor, String rank, String number, String time, String points, String mountain) {
    final double buttonSize = screenSize!.height / 7;
    backgroundCyclist!.render(canvas, position: Vector2(screenSize!.width / 3.6, buttonSize * 1.2 * (yOffset / 2 + 1.9)), size: Vector2(screenSize!.width / 2.5, buttonSize / 1.5));
    double i = 0;
    renderCyclistText(canvas, yOffset, teamColor, rank, i++);
    renderCyclistText(canvas, yOffset, teamColor, number, i++);
    if (type == ResultsType.time || type == ResultsType.race || type == ResultsType.young || type == ResultsType.team) {
      renderCyclistText(canvas, yOffset, teamColor, time, i++);
    }
    if (type == ResultsType.points || type == ResultsType.race) {
      renderCyclistText(canvas, yOffset, teamColor, points, i++);
    }
    if (type == ResultsType.mountain || type == ResultsType.race) {
      renderCyclistText(canvas, yOffset, teamColor, mountain, i++);
    }
  }

  void renderCyclistText(Canvas canvas, double yOffset, Color teamColor, String text, double position) {
    final double buttonSize = screenSize!.height / 7;
    final TextSpan span = TextSpan(style: TextStyle(color: teamColor, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: text);
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 3.6 + buttonSize * (position + 0.5), buttonSize * 1.2 * (yOffset / 2 + 2)), 0, span);
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}

ResultsType? getResultsTypeFromString(String? resultsTypeAsString) {
  for (final ResultsType element in ResultsType.values) {
    if (element.toString() == resultsTypeAsString) {
      return element;
    }
  }
  return null;
}

enum ResultsType { race, tour, time, young, points, mountain, team }
