import 'dart:ui';

import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/views/baseView.dart';
import 'package:CyclingEscape/views/gameManager.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class HelpMenu implements BaseView {
  final Function navigate;

  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  int screen = 0;
  Sprite background;
  Sprite backgroundHeader;
  Sprite backgroundSlider;
  Sprite sliderFront;
  double scroll = 0;
  double scrollStart = 0;
  List<String> selectedText = [];
  List<Button> buttons = [];

  HelpMenu(this.spriteManager, this.navigate);

  @override
  void onAttach() {
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    background = this.spriteManager.getSprite('back_results.png');
    backgroundHeader = this.spriteManager.getSprite('back_text_01.png');
    backgroundSlider = this.spriteManager.getSprite('back_slider.png');
    sliderFront = this.spriteManager.getSprite('slider_front.png');

    createButtons();
    selectedText = getTextFromScreen();
  }

  createButtons() {
    buttons = [];
    buttons.add(Button(
        this.spriteManager,
        Offset(screenSize.width / 9.8, screenSize.height / 2),
        ButtonType.ICON_LEFT, () {
      screen = (screen - 1 + 10) % 10;
      scroll = 0;
      selectedText = getTextFromScreen();
    }));
    buttons.add(Button(
        this.spriteManager,
        Offset(
            screenSize.width - screenSize.width / 9.8, screenSize.height / 2),
        ButtonType.ICON_RIGHT, () {
      screen = (screen + 1 + 10) % 10;
      scroll = 0;
      selectedText = getTextFromScreen();
    }));
    buttons.add(Button(
        this.spriteManager,
        Offset(screenSize.width / 15 * 13, screenSize.height / 6 * 4.8),
        ButtonType.ICON_YES,
        () => navigate(GameManagerState.MAIN_MENU)));
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

  @override
  void render(Canvas canvas) {
    double buttonSize = screenSize.height / 7;

    background.renderPosition(
        canvas, Position(screenSize.width / 15, buttonSize / 2),
        size: Position(
            screenSize.width / 15 * 13, screenSize.height - buttonSize));
    backgroundHeader.renderPosition(
        canvas, Position(screenSize.width / 3, buttonSize / 4),
        size: Position(screenSize.width / 3, buttonSize));

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'Help');
    Offset position = Offset(screenSize.width / 2, buttonSize / 2);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundSlider.renderPosition(
        canvas, Position(screenSize.width * 0.76, buttonSize * 1.5),
        size: Position(buttonSize / 2, screenSize.height / 1.5));

    sliderFront.renderPosition(
        canvas,
        Position(
            screenSize.width * 0.76,
            buttonSize * 1.5 +
                scroll * (screenSize.height / 1.5 - buttonSize / 2)),
        size: Position(buttonSize, buttonSize) / 2);

    buttons.forEach((button) {
      button.render(canvas);
    });

    canvas.save();
    canvas.clipRect(
        Rect.fromLTRB(0, buttonSize * 1.4, screenSize.width, buttonSize * 6));
    renderText(canvas);

    canvas.restore();
  }

  renderText(canvas) {
    double i = (12 - selectedText.length) * scroll;
    if (selectedText.length <= 12) {
      i = 0;
    }
    selectedText.forEach((line) {
      renderLine(canvas, line, i++);
    });
  }

  renderLine(canvas, line, yOffset) {
    double buttonSize = screenSize.height / 7;
    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 13.0, fontFamily: 'SaranaiGame'),
        text: line);
    CanvasUtils.drawText(
        canvas,
        Offset(screenSize.width / 2, buttonSize / 2 * (yOffset / 2 + 3)),
        0,
        span);
  }

  getTextFromScreen() {
    List<String> text = [];
    switch (screen) {
      case 0:
        text.addAll(splitLongText(
            'Hello and welcome to the help page. You can find most information about the game on this page. If you were to have any more questions, don\'t hesitate to send me a mail.'));
        text.add('');
        text.addAll(splitLongText(
            'If you enjoy the game (or don\'t) let me know by writing a review.'));
        break;
      case 1:
        text.add('Basics');
        text.add('');
        text.addAll(splitLongText(
            'The goal of the game is to finish first. You do this by throwing the dice and selecting where you want to move. After you or the computer has moved, the cyclist that is right behind the one that just moved may be able to follow. If they can follow depends on some conditions (see below). The first one to cross the finish line (second white line) wins the race. How the points are distributed and time is calculated is explained in the Results tab of this help page.'));
        text.add('');
        text.add('Following');
        text.addAll(splitLongText(
            'A very important aspect of the game is when to follow. Whenever the option to follow is shown it always shows you how much you would need to throw to get at that spot. A good rule of hand is that when you need at a 7 or more following is worth it. This is also what the computer uses as a threshold. You may notice that there is also an option to auto follow. Clicking this will say to the game that you will always follow whenever you need a 7 or more (you can change this in settings). Whenever you need less than a 7 to follow and you have already pressed auto previously it will still ask if you want to follow. This is because in some circumstances this may be a smart move. You can also disable this in settings.'));
        text.add('');
        text.add('Races, tours and career');
        text.addAll(splitLongText(
            'These are explained in another tab, but in short you can decide if you want to play a single race. This is a quick race and is for when you only have a limited time or if you want to experiment with the game. Tours are longer events and consist of multiple races. Starting from the second race there will be special jerseys for the people that are first in a ranking.'));
        text.addAll(splitLongText(
            'Career is more a campaign, you will start with only a single cyclist and your goal is to become the best team. There is a bigger explanation on this on different tabs.'));
        break;
      case 2:
        text.add('Map types');
        text.add('');
        text.addAll(splitLongText(
            'You may notice when you are selecting a race or tour that there are different map types. For now there are 4 types, you have flat, cobbled, hilled and heavy. This will determine what road types are created. Flat are regular road pieces and will not include any special road. Cobbled will create cobbled road. These roads have a different colour and a negative value shown on them. This value is then subtracted if you start from this position. Be carefull with -4 for example as you can get stuck there for a whole turn if you throw 4 or lower. When you choose a hilled type, there are hills/mountains created. These first have red roads with a rising negative value that will be subtracted. These go from -1 to -5 which are very difficult to traverse. After the red comes yellow roads with positive value. These will be added to your dices\' value. Standing on a +5 and throwing a 12 will get you as far as 17! tiles. These values only count when you stop on the tile. If you go over them the value isn\'t taken into account.'));
        text.addAll(splitLongText(
            'The last type is Heavy and that is a combination of all other types. This will include flat, cobbled, uphill and downhill road. Note that since cobbled is less difficult than hills heavy may create races that are less difficult than hilled.'));
        text.add('');
        text.addAll(splitLongText(
            'The maps are always randomly generated from options. This does not mean that all options are always used. You may select heavy and only have cobbled or even no special road.'));
        break;
      case 3:
        text.add('Results');
        text.add('(points, mountain sprints, finish, ...)');
        text.add('');
        text.addAll(splitLongText(
            'In most races there are sprints (green lines), mountain sprints (red line) and there is always a start (white) and a finish (also white). These may earn you points for the apropriate ranking. Start is just an indication, sprints and mountains will earn respectivly 5, 3, 2 and 1 (mountain) point. The finish earns you respectivly 10, 7, 5, 4, 3, 2, 1.'));
        text.add('');
        text.add('Who is first?');
        text.add('');
        text.addAll(splitLongText(
            'The first one to pass is not always the rider that gets the most points. The positions are only calculated at the END of the turn. This means that at the start of the turn you may pass it first, but then during the turn 4 riders may pass you and take all the points of the sprint. The closest field to the end is used to know how far you are, so be carefull when there are turns after the sprint.'));
        break;
      case 4:
        text.add('Tours');
        text.add('');
        text.add('tbd');
        break;
      case 5:
        text.add('Career');
        text.add('');
        text.add('tbd');
        break;
      case 6:
        text.add('Career - upgrades');
        text.add('');
        text.add('tbd');
        break;
      case 7:
        text.add('Strategy');
        text.add('');
        text.add('tbd');
        break;
      case 8:
        text.add('Settings');
        text.add('');
        text.add('tbd');
        break;
      case 9:
        text.add('More information and contact');
        text.add('');
        text.add('tbd');
        break;
      default:
    }
    return text;
  }

  splitLongText(String text) {
    List<String> splitted = [];
    while (text.length > 0) {
      print(text.length);
      if (text.length <= 30) {
        splitted.add(text);
        text = '';
      } else {
        int end = text.indexOf(' ', 30);
        if (end == -1) {
          splitted.add(text);
          text = '';
        } else {
          splitted.add(text.substring(0, end));
          text = text.substring(end);
        }
      }
    }
    return splitted;
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
