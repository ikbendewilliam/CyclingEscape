import 'dart:math';
import 'dart:ui';

import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/mapUtils.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button {
  final String text;
  ButtonType type;
  final Function onPress;
  final SpriteManager spriteManager;

  bool isPressed = false;
  Offset center;
  Sprite spriteBackground;
  Sprite sprite;
  Sprite spritePressed;
  double buttonSize = 1;
  double scale;

  Button(this.spriteManager, this.center, this.type, this.onPress,
      {this.text, this.scale}) {
    getSprite();
  }

  getSprite() {
    switch (this.type) {
      case ButtonType.BAR_GREEN:
        sprite = this.spriteManager.getSprite('green_button_01.png');
        spritePressed = this.spriteManager.getSprite('green_button_02.png');
        break;
      case ButtonType.BAR_YELLOW:
        sprite = this.spriteManager.getSprite('yellow_button_01.png');
        spritePressed = this.spriteManager.getSprite('yellow_button_02.png');
        break;
      case ButtonType.BAR_BLACK:
        sprite = this.spriteManager.getSprite('black_button_01.png');
        spritePressed = this.spriteManager.getSprite('black_button_02.png');
        break;
      case ButtonType.BAR_BLUE:
        sprite = this.spriteManager.getSprite('blue_button_01.png');
        spritePressed = this.spriteManager.getSprite('blue_button_02.png');
        break;
      case ButtonType.BAR_RED:
        sprite = this.spriteManager.getSprite('red_button_01.png');
        spritePressed = this.spriteManager.getSprite('red_button_02.png');
        break;
      case ButtonType.ICON_LEFT:
        spriteBackground = this.spriteManager.getSprite('left_arrow_01.png');
        sprite = this.spriteManager.getSprite('left_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_CREDITS:
        sprite = this.spriteManager.getSprite('icon_credits.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_RIGHT:
        spriteBackground = this.spriteManager.getSprite('right_arrow_01.png');
        sprite = this.spriteManager.getSprite('right_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_SMALL_LEFT:
        sprite = this.spriteManager.getSprite('left_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_SMALL_RIGHT:
        sprite = this.spriteManager.getSprite('right_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_PAUSE:
        sprite = this.spriteManager.getSprite('icon_pause.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_RESULTS:
        sprite = this.spriteManager.getSprite('icon_results.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_PLAY:
        sprite = this.spriteManager.getSprite('icon_play.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_PLUS:
        sprite = this.spriteManager.getSprite('icon_plus.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_PLUS_DISABLED:
        sprite = this.spriteManager.getSprite('icon_plus_disabled.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_MINUS:
        sprite = this.spriteManager.getSprite('icon_minus.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_MINUS_DISABLED:
        sprite = this.spriteManager.getSprite('icon_minus_disabled.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_SETTINGS:
        sprite = this.spriteManager.getSprite('icon_settings.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_YES:
        sprite = this.spriteManager.getSprite('icon_yes.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_NO:
        sprite = this.spriteManager.getSprite('icon_no.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.ICON_RELOAD:
        sprite = this.spriteManager.getSprite('icon_reload.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_TRASH:
        sprite = this.spriteManager.getSprite('icon_trash.png');
        spritePressed = sprite;
        break;
      case ButtonType.ICON_HELP:
        sprite = this.spriteManager.getSprite('icon_help.png');
        spritePressed = this.spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.SWITCH_BUTTON_OFF:
        sprite = this.spriteManager.getSprite('switch_button_off.png');
        spritePressed = sprite;
        break;
      case ButtonType.SWITCH_BUTTON_ON:
        sprite = this.spriteManager.getSprite('switch_button_on.png');
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
    if (type == ButtonType.SWITCH_BUTTON_ON ||
        type == ButtonType.SWITCH_BUTTON_OFF) {
      aspectRatio = 2;
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
              color: Colors.white,
              fontSize: pow(buttonSize, 1 / 2) * 2.5,
              fontFamily: 'SaranaiGame'),
          text: this.text);
      Offset position = Offset(center.dx, center.dy);
      position = Offset(
          position.dx,
          position.dy -
              (isPressed
                  ? pow(buttonSize, 1 / 2) * 2
                  : pow(buttonSize, 1 / 2) * 2.5));
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
      if (this.type == ButtonType.SWITCH_BUTTON_ON) {
        this.type = ButtonType.SWITCH_BUTTON_OFF;
        onPress(false);
        getSprite();
      } else if (this.type == ButtonType.SWITCH_BUTTON_OFF) {
        this.type = ButtonType.SWITCH_BUTTON_ON;
        onPress(true);
        getSprite();
      } else {
        onPress();
      }
      return true;
    }
    return false;
  }

  void setScreenSize(Size size) {
    buttonSize = size.height / 7;
    if (scale != null) {
      buttonSize *= scale;
    }
  }
}

enum ButtonType {
  BAR_GREEN,
  BAR_YELLOW,
  BAR_BLACK,
  BAR_BLUE,
  BAR_RED,
  ICON_CREDITS,
  ICON_LEFT,
  ICON_RIGHT,
  ICON_SMALL_LEFT,
  ICON_SMALL_RIGHT,
  ICON_PAUSE,
  ICON_RESULTS,
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
  ICON_HELP,
  SWITCH_BUTTON_OFF,
  SWITCH_BUTTON_ON
}
