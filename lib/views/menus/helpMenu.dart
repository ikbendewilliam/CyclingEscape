import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:cycling_escape/components/ui/button.dart';
import 'package:cycling_escape/utils/canvasUtils.dart';
import 'package:cycling_escape/views/baseView.dart';
import 'package:cycling_escape/views/gameManager.dart';

class HelpMenu implements BaseView {
  final Function navigate;
  AppLocalizations appLocalizations;

  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;

  int screen = 0;
  Sprite? background;
  Sprite? backgroundHeader;
  Sprite? backgroundSlider;
  Sprite? sliderFront;
  double scroll = 0;
  double scrollStart = 0;
  List<String> selectedText = [];
  List<Button> buttons = [];

  HelpMenu(this.spriteManager, this.navigate, this.appLocalizations);

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
    buttons.add(Button(this.spriteManager, Offset(screenSize!.width / 9.8, screenSize!.height / 2), ButtonType.ICON_LEFT, () {
      screen = (screen - 1 + 7) % 7;
      scroll = 0;
      selectedText = getTextFromScreen();
    }));
    buttons.add(Button(this.spriteManager, Offset(screenSize!.width - screenSize!.width / 9.8, screenSize!.height / 2), ButtonType.ICON_RIGHT, () {
      screen = (screen + 1 + 7) % 7;
      scroll = 0;
      selectedText = getTextFromScreen();
    }));
    buttons.add(Button(this.spriteManager, Offset(screenSize!.width / 15 * 13, screenSize!.height / 6 * 4.8), ButtonType.ICON_YES, () => navigate(GameManagerState.MAIN_MENU)));
    buttons.forEach((element) {
      element.setScreenSize(screenSize!);
    });
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
    buttons.forEach((button) {
      button.onTapDown(details.focalPoint);
    });
    scroll += (scrollStart - details.focalPoint.dy) / (screenSize!.height / 3);
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
    double buttonSize = screenSize!.height / 7;

    background!.render(canvas, position: Vector2(screenSize!.width / 15, buttonSize / 2), size: Vector2(screenSize!.width / 15 * 13, screenSize!.height - buttonSize));
    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize / 4), size: Vector2(screenSize!.width / 3, buttonSize));

    TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: appLocalizations.helpTitle);
    Offset position = Offset(screenSize!.width / 2, buttonSize / 2);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundSlider!.render(canvas, position: Vector2(screenSize!.width * 0.76, buttonSize * 1.5), size: Vector2(buttonSize / 2, screenSize!.height / 1.5));

    sliderFront!.render(canvas,
        position: Vector2(screenSize!.width * 0.76, buttonSize * 1.5 + scroll * (screenSize!.height / 1.5 - buttonSize / 2)), size: Vector2(buttonSize, buttonSize) / 2);

    buttons.forEach((button) {
      button.render(canvas);
    });

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, buttonSize * 1.4, screenSize!.width, buttonSize * 6));
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
    double buttonSize = screenSize!.height / 7;
    TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 13.0, fontFamily: 'SaranaiGame'), text: line);
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize / 2 * (yOffset / 2 + 3)), 0, span);
  }

  getTextFromScreen() {
    List<String> text = [];
    switch (screen) {
      case 0:
        text.addAll(splitLongText(appLocalizations.helpHome1));
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpHome2));
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpHome3));
        text.add(appLocalizations.helpBasicsTitle);
        text.add(appLocalizations.helpMapTypesTitle);
        text.add(appLocalizations.helpResultsTitle);
        text.add(appLocalizations.helpToursTitle);
        text.add(appLocalizations.helpStrategy);
        text.add(appLocalizations.helpSettingsTitle);
        text.add(appLocalizations.helpMoreTitle);
        break;
      case 1:
        text.add(appLocalizations.helpBasicsTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpBasics1));
        text.add('');
        text.add(appLocalizations.helpBasics2);
        text.addAll(splitLongText(appLocalizations.helpBasics3));
        text.add('');
        text.add(appLocalizations.helpBasics4);
        text.addAll(splitLongText(appLocalizations.helpBasics5));
        text.addAll(splitLongText(appLocalizations.helpBasics6));
        break;
      case 2:
        text.add(appLocalizations.helpMapTypesTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpMapTypes1));
        text.addAll(splitLongText(appLocalizations.helpMapTypes2));
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpMapTypes3));
        break;
      case 3:
        text.add(appLocalizations.helpResultsTitle);
        text.add(appLocalizations.helpResults1);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpResults2));
        text.add('');
        text.add(appLocalizations.helpResults3);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpResults4));
        text.add('');
        text.add(appLocalizations.helpResults5);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpResults6));
        break;
      case 4:
        text.add(appLocalizations.helpToursTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpTours));
        break;
      case 5:
        text.add(appLocalizations.helpStrategyTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpStrategy));
        break;
      case 6:
        text.add(appLocalizations.helpSettingsTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpSettings1));
        text.add('');
        text.add(appLocalizations.helpSettings2);
        text.addAll(splitLongText(appLocalizations.helpSettings3));
        text.add('');
        text.add(appLocalizations.helpSettings4);
        text.addAll(splitLongText(appLocalizations.helpSettings5));
        text.add('');
        text.add(appLocalizations.helpSettings6);
        text.addAll(splitLongText(appLocalizations.helpSettings7));
        break;
      case 7:
        text.add(appLocalizations.helpMoreTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.helpMore));
        break;
      default:
    }
    return text;
  }

  splitLongText(String text) {
    List<String> splitted = [];
    while (text.length > 0) {
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
  void resize(Size? size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}

ResultsType? getResultsTypeFromString(String resultsTypeAsString) {
  for (ResultsType element in ResultsType.values) {
    if (element.toString() == resultsTypeAsString) {
      return element;
    }
  }
  return null;
}

enum ResultsType { RACE, TOUR, TIME, YOUNG, POINTS, MOUNTAIN, TEAM }
