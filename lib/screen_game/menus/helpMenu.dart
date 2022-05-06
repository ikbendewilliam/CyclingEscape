import 'package:cycling_escape/screen_game/baseView.dart';
import 'package:cycling_escape/screen_game/gameManager.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class HelpMenu implements BaseView {
  final NavigateType navigate;
  Localization localizations;

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

  HelpMenu(this.spriteManager, this.navigate, this.localizations);

  @override
  void onAttach() {
    screenSize ??= const Size(1, 1);
    background = spriteManager.getSprite('back_results.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
    backgroundSlider = spriteManager.getSprite('back_slider.png');
    sliderFront = spriteManager.getSprite('slider_front.png');

    createButtons();
    selectedText = getTextFromScreen();
  }

  void createButtons() {
    buttons = [];
    buttons.add(Button(spriteManager, Offset(screenSize!.width / 9.8, screenSize!.height / 2), ButtonType.iconLeft, () {
      screen = (screen - 1 + 7) % 7;
      scroll = 0;
      selectedText = getTextFromScreen();
    }));
    buttons.add(Button(spriteManager, Offset(screenSize!.width - screenSize!.width / 9.8, screenSize!.height / 2), ButtonType.iconRight, () {
      screen = (screen + 1 + 7) % 7;
      scroll = 0;
      selectedText = getTextFromScreen();
    }));
    buttons.add(Button(spriteManager, Offset(screenSize!.width / 15 * 13, screenSize!.height / 6 * 4.8), ButtonType.iconYes, () => navigate(GameManagerState.mainMenu)));
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

  @override
  void render(Canvas canvas) {
    final double buttonSize = screenSize!.height / 7;

    background!.render(canvas, position: Vector2(screenSize!.width / 15, buttonSize / 2), size: Vector2(screenSize!.width / 15 * 13, screenSize!.height - buttonSize));
    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize / 4), size: Vector2(screenSize!.width / 3, buttonSize));

    final TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.helpTitle);
    final Offset position = Offset(screenSize!.width / 2, buttonSize / 2);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundSlider!.render(canvas, position: Vector2(screenSize!.width * 0.76, buttonSize * 1.5), size: Vector2(buttonSize / 2, screenSize!.height / 1.5));

    sliderFront!.render(canvas,
        position: Vector2(screenSize!.width * 0.76, buttonSize * 1.5 + scroll * (screenSize!.height / 1.5 - buttonSize / 2)), size: Vector2(buttonSize, buttonSize) / 2);

    for (final button in buttons) {
      button.render(canvas);
    }

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, buttonSize * 1.4, screenSize!.width, buttonSize * 6));
    renderText(canvas);

    canvas.restore();
  }

  void renderText(Canvas canvas) {
    double i = (12 - selectedText.length) * scroll;
    if (selectedText.length <= 12) {
      i = 0;
    }
    for (final line in selectedText) {
      renderLine(canvas, line, i++);
    }
  }

  void renderLine(Canvas canvas, String line, double yOffset) {
    final double buttonSize = screenSize!.height / 7;
    final TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 13.0, fontFamily: 'SaranaiGame'), text: line);
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize / 2 * (yOffset / 2 + 3)), 0, span);
  }

  List<String> getTextFromScreen() {
    final List<String> text = [];
    switch (screen) {
      case 0:
        text.addAll(splitLongText(localizations.helpHome1));
        text.add('');
        text.addAll(splitLongText(localizations.helpHome2));
        text.add('');
        text.addAll(splitLongText(localizations.helpHome3));
        text.add(localizations.helpBasicsTitle);
        text.add(localizations.helpMapTypesTitle);
        text.add(localizations.helpResultsTitle);
        text.add(localizations.helpToursTitle);
        text.add(localizations.helpStrategy);
        text.add(localizations.helpSettingsTitle);
        text.add(localizations.helpMoreTitle);
        break;
      case 1:
        text.add(localizations.helpBasicsTitle);
        text.add('');
        text.addAll(splitLongText(localizations.helpBasics1));
        text.add('');
        text.add(localizations.helpBasics2);
        text.addAll(splitLongText(localizations.helpBasics3));
        text.add('');
        text.add(localizations.helpBasics4);
        text.addAll(splitLongText(localizations.helpBasics5));
        text.addAll(splitLongText(localizations.helpBasics6));
        break;
      case 2:
        text.add(localizations.helpMapTypesTitle);
        text.add('');
        text.addAll(splitLongText(localizations.helpMapTypes1));
        text.addAll(splitLongText(localizations.helpMapTypes2));
        text.add('');
        text.addAll(splitLongText(localizations.helpMapTypes3));
        break;
      case 3:
        text.add(localizations.helpResultsTitle);
        text.add(localizations.helpResults1);
        text.add('');
        text.addAll(splitLongText(localizations.helpResults2));
        text.add('');
        text.add(localizations.helpResults3);
        text.add('');
        text.addAll(splitLongText(localizations.helpResults4));
        text.add('');
        text.add(localizations.helpResults5);
        text.add('');
        text.addAll(splitLongText(localizations.helpResults6));
        break;
      case 4:
        text.add(localizations.helpToursTitle);
        text.add('');
        text.addAll(splitLongText(localizations.helpTours));
        break;
      case 5:
        text.add(localizations.helpStrategyTitle);
        text.add('');
        text.addAll(splitLongText(localizations.helpStrategy));
        break;
      case 6:
        text.add(localizations.helpSettingsTitle);
        text.add('');
        text.addAll(splitLongText(localizations.helpSettings1));
        text.add('');
        text.add(localizations.helpSettings2);
        text.addAll(splitLongText(localizations.helpSettings3));
        text.add('');
        text.add(localizations.helpSettings4);
        text.addAll(splitLongText(localizations.helpSettings5));
        text.add('');
        text.add(localizations.helpSettings6);
        text.addAll(splitLongText(localizations.helpSettings7));
        break;
      case 7:
        text.add(localizations.helpMoreTitle);
        text.add('');
        text.addAll(splitLongText(localizations.helpMore));
        break;
      default:
    }
    return text;
  }

  List<String> splitLongText(String text) {
    final List<String> splitted = [];
    while (text.isNotEmpty) {
      if (text.length <= 30) {
        splitted.add(text);
        text = '';
      } else {
        final int end = text.indexOf(' ', 30);
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
  for (final ResultsType element in ResultsType.values) {
    if (element.toString() == resultsTypeAsString) {
      return element;
    }
  }
  return null;
}

enum ResultsType { race, tour, time, young, points, mountain, team }
