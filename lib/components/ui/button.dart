import 'dart:ui';

import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/mapUtils.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button {
  final String text;
  final ButtonType type;
  final Function onPress;

  bool isPressed = false;
  Offset center;
  Sprite spriteBackground;
  Sprite sprite;
  Sprite spritePressed;
  double buttonSize = 1;

  Button(this.center, this.type, this.onPress, [this.text]) {
    switch (this.type) {
      case ButtonType.BAR_GREEN:
        sprite = Sprite('green_button_01.png');
        spritePressed = Sprite('green_button_02.png');
        break;
      case ButtonType.BAR_YELLOW:
        sprite = Sprite('yellow_button_01.png');
        spritePressed = Sprite('yellow_button_02.png');
        break;
      case ButtonType.BAR_BLACK:
        sprite = Sprite('black_button_01.png');
        spritePressed = Sprite('black_button_02.png');
        break;
      case ButtonType.BAR_BLUE:
        sprite = Sprite('blue_button_01.png');
        spritePressed = Sprite('blue_button_02.png');
        break;
      case ButtonType.BAR_RED:
        sprite = Sprite('red_button_01.png');
        spritePressed = Sprite('red_button_02.png');
        break;
      case ButtonType.ICON_LEFT:
        spriteBackground = Sprite('left_arrow_01.png');
        sprite = Sprite('left_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_RIGHT:
        spriteBackground = Sprite('right_arrow_01.png');
        sprite = Sprite('right_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_SMALL_LEFT:
        sprite = Sprite('left_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_SMALL_RIGHT:
        sprite = Sprite('right_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_PAUSE:
        sprite = Sprite('icon_pause.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_PLAY:
        sprite = Sprite('icon_play.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_PLUS:
        sprite = Sprite('icon_plus.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_PLUS_DISABLED:
        sprite = Sprite('icon_plus_disabled.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_MINUS:
        sprite = Sprite('icon_minus.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_MINUS_DISABLED:
        sprite = Sprite('icon_minus_disabled.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_SETTINGS:
        sprite = Sprite('icon_settings.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_YES:
        sprite = Sprite('icon_yes.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_NO:
        sprite = Sprite('icon_no.png');
        spritePressed = Sprite('icon_pressed.png');
        break;
      case ButtonType.ICON_RELOAD:
        sprite = Sprite('icon_reload.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_TRASH:
        sprite = Sprite('icon_trash.png');
        spritePressed = sprite;
        break;
      case ButtonType.SWITCH_BUTTON_OFF:
        sprite = Sprite('switch_button_off.png');
        spritePressed = sprite;
        break;
      case ButtonType.SWITCH_BUTTON_ON:
        sprite = Sprite('switch_button_on.png');
        spritePressed = sprite;
        break;
    }
  }

  void render(Canvas canvas) {
    double aspectRatio = (this.text != null) ? 3.5 : 1;
    double scale = 1;

    if (type == ButtonType.ICON_LEFT ||
        type == ButtonType.ICON_RIGHT ||
        type == ButtonType.ICON_SMALL_LEFT ||
        type == ButtonType.ICON_SMALL_RIGHT) {
      aspectRatio = 0.8;
      scale = 0.7;
    }
    if (spriteBackground != null) {
      spriteBackground.renderCentered(canvas, Position(center.dx, center.dy),
          size: Position(buttonSize, buttonSize) * 1.5);
    }
    if (!isPressed) {
      sprite.renderCentered(canvas, Position(center.dx, center.dy),
          size: Position(buttonSize * scale * aspectRatio, buttonSize * scale));
    } else {
      spritePressed.renderCentered(canvas, Position(center.dx, center.dy),
          size: Position(buttonSize * scale * aspectRatio, buttonSize * scale));
    }

    if (this.text != null) {
      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
          text: this.text);
      Offset position = Offset(center.dx, center.dy);
      position = Offset(position.dx,
          position.dy - (isPressed ? buttonSize / 4 : buttonSize / 3));
      CanvasUtils.drawText(canvas, position, 0, span);
    }
  }

  void onTapDown(Offset point) {
    double aspectRatio = (this.text != null) ? 3.5 : 1;
    Offset delta = Offset(buttonSize * aspectRatio, buttonSize) / 2;
    this.isPressed =
        MapUtils.isInsideRect(point, center - delta, center + delta);
  }

  bool onTapUp(TapUpDetails details) {
    double aspectRatio = (this.text != null) ? 3.5 : 1;
    Offset delta = Offset(buttonSize * aspectRatio, buttonSize) / 2;
    if (MapUtils.isInsideRect(
        details.globalPosition, center - delta, center + delta)) {
      this.isPressed = false;
      onPress();
      return true;
    }
    return false;
  }

  void setScreenSize(Size size) {
    // this.center = Offset(size.width / 2, center.dy);
    buttonSize = size.height / 7;
  }
}

enum ButtonType {
  BAR_GREEN,
  BAR_YELLOW,
  BAR_BLACK,
  BAR_BLUE,
  BAR_RED,
  ICON_LEFT,
  ICON_RIGHT,
  ICON_SMALL_LEFT,
  ICON_SMALL_RIGHT,
  ICON_PAUSE,
  ICON_PLAY,
  ICON_PLUS,
  ICON_PLUS_DISABLED,
  ICON_MINUS,
  ICON_MINUS_DISABLED,
  ICON_SETTINGS,
  ICON_YES,
  ICON_NO,
  ICON_RELOAD,
  ICON_TRASH,
  SWITCH_BUTTON_OFF,
  SWITCH_BUTTON_ON
}
