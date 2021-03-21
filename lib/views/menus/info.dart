import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class InfoView implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;

  final Function navigate;
  GameManagerState previousState;
  BaseView previousView;
  List<String> selectedText;

  InfoView(this.spriteManager, this.navigate);

  void onAttach() {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    createButtons();

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  createButtons() {
    double buttonSize = screenSize.height / 7;
    buttons = [];
    buttons.add(Button(this.spriteManager, Offset(screenSize.width / 3 * 2, 5.5 * buttonSize), ButtonType.ICON_YES, () => {navigate(GameManagerState.CLOSE_INFO)}));
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
    buttons.forEach((button) {
      button.onTapDown(details.focalPoint);
    });
  }

  @override
  void onScaleStart(ScaleStartDetails details) {}

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
    if (this.previousView != null) {
      this.previousView.render(canvas);
    }
    Paint overlay = Paint()
      ..color = Color(0x77000000)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTRB(0, 0, screenSize.width, screenSize.height), overlay);

    double buttonSize = screenSize.height / 7;

    buttonBackground.render(canvas, position: Vector2(screenSize.width / 4, buttonSize), size: Vector2(screenSize.width / 2, screenSize.height - buttonSize * 1.75));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader.render(canvas, position: Vector2(screenSize.width / 3, buttonSize * 0.75), size: Vector2(screenSize.width / 3, buttonSize));

    renderText(canvas);

    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Info');
    Offset position = Offset(screenSize.width / 2, buttonSize);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  renderText(canvas) {
    selectedText?.asMap()?.forEach((i, line) {
      renderLine(canvas, line, i);
    });
  }

  renderLine(canvas, line, yOffset) {
    double buttonSize = screenSize.height / 7;
    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 13.0, fontFamily: 'SaranaiGame'), text: line);
    CanvasUtils.drawText(canvas, Offset(screenSize.width / 2, buttonSize / 2 * (yOffset / 2 + 4)), 0, span);
  }

  splitLongText(String text) {
    List<String> splitted = [];
    while (text.length > 0) {
      if (text.length <= 30) {
        splitted.add(text);
        text = '';
      } else {
        int end = text.indexOf(' ', 30);
        int newLine = text.indexOf('\n', 0);
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
  void resize(Size size) {
    screenSize = size;
    createButtons();
    buttons.forEach((element) {
      element.setScreenSize(size);
    });
    if (this.previousView != null) {
      this.previousView.resize(size);
    }
  }

  @override
  void update(double t) {}
}
