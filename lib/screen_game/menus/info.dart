import 'package:cycling_escape/screen_game/baseView.dart';
import 'package:cycling_escape/screen_game/gameManager.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class InfoView implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;

  final NavigateType navigate;
  GameManagerState? previousState;
  BaseView? previousView;
  List<String>? selectedText;

  InfoView(this.spriteManager, this.navigate, this.localizations);

  @override
  void onAttach() {
    buttons = [];
    screenSize ??= const Size(1, 1);
    createButtons();

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  void createButtons() {
    final double buttonSize = screenSize!.height / 7;
    buttons = [];
    buttons.add(Button(spriteManager, Offset(screenSize!.width / 3 * 2, 5.5 * buttonSize), ButtonType.iconYes, () => {navigate(GameManagerState.closeInfo)}));
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    for (final button in buttons) {
      button.onTapDown(info.raw.focalPoint);
    }
  }

  @override
  void onScaleStart(ScaleStartInfo details) {}

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
    if (previousView != null) {
      previousView!.render(canvas);
    }
    final Paint overlay = Paint()
      ..color = const Color(0x77000000)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTRB(0, 0, screenSize!.width, screenSize!.height), overlay);

    final double buttonSize = screenSize!.height / 7;

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 4, buttonSize), size: Vector2(screenSize!.width / 2, screenSize!.height - buttonSize * 1.75));

    for (final button in buttons) {
      button.render(canvas);
    }

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.75), size: Vector2(screenSize!.width / 3, buttonSize));

    renderText(canvas);

    final TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.careerInfoTitle);
    final Offset position = Offset(screenSize!.width / 2, buttonSize);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  void renderText(Canvas canvas) {
    selectedText?.asMap().forEach((i, line) {
      renderLine(canvas, line, i);
    });
  }

  void renderLine(Canvas canvas, String line, int yOffset) {
    final double buttonSize = screenSize!.height / 7;
    final TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 13.0, fontFamily: 'SaranaiGame'), text: line);
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize / 2 * (yOffset / 2 + 4)), 0, span);
  }

  void splitLongText(String text) {
    final List<String> splitted = [];
    while (text.isNotEmpty) {
      if (text.length <= 30) {
        splitted.add(text);
        text = '';
      } else {
        final int end = text.indexOf(' ', 30);
        final int newLine = text.indexOf('\n', 0);
        if (newLine > -1 && (newLine <= end || end == -1)) {
          splitted.add(text.substring(0, newLine));
          text = text.substring(newLine + 1);
        } else {
          if (end == -1) {
            splitted.add(text);
            text = '';
          } else {
            splitted.add(text.substring(0, end));
            text = text.substring(end);
          }
        }
      }
    }
    selectedText = splitted;
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    createButtons();
    for (final element in buttons) {
      element.setScreenSize(size!);
    }
    if (previousView != null) {
      previousView!.resize(size);
    }
  }

  @override
  void update(double dt) {}
}
