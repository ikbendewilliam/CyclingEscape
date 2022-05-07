import 'dart:math';

import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/map/map_utils.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class Button {
  final String? text;
  ButtonType type;
  final Function onPress;
  final SpriteManager spriteManager;

  bool isPressed = false;
  Offset center;
  Sprite? spriteBackground;
  Sprite? sprite;
  Sprite? spritePressed;
  double buttonSize = 1;
  double? scale;

  Button(this.spriteManager, this.center, this.type, this.onPress, {this.text, this.scale}) {
    getSprite();
  }

  void getSprite() {
    switch (type) {
      case ButtonType.barGreen:
        sprite = spriteManager.getSprite('green_button_01.png');
        spritePressed = spriteManager.getSprite('green_button_02.png');
        break;
      case ButtonType.barYellow:
        sprite = spriteManager.getSprite('yellow_button_01.png');
        spritePressed = spriteManager.getSprite('yellow_button_02.png');
        break;
      case ButtonType.barBlack:
        sprite = spriteManager.getSprite('black_button_01.png');
        spritePressed = spriteManager.getSprite('black_button_02.png');
        break;
      case ButtonType.barBlue:
        sprite = spriteManager.getSprite('blue_button_01.png');
        spritePressed = spriteManager.getSprite('blue_button_02.png');
        break;
      case ButtonType.barRed:
        sprite = spriteManager.getSprite('red_button_01.png');
        spritePressed = spriteManager.getSprite('red_button_02.png');
        break;
      case ButtonType.iconLeft:
        spriteBackground = spriteManager.getSprite('left_arrow_01.png');
        sprite = spriteManager.getSprite('left_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.iconCredits:
        sprite = spriteManager.getSprite('icon_credits.png');
        spritePressed = sprite;
        break;
      case ButtonType.iconRight:
        spriteBackground = spriteManager.getSprite('right_arrow_01.png');
        sprite = spriteManager.getSprite('right_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.iconSmallLeft:
        sprite = spriteManager.getSprite('left_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.iconSmallRight:
        sprite = spriteManager.getSprite('right_arrow_02.png');
        spritePressed = sprite;
        break;
      case ButtonType.iconPause:
        sprite = spriteManager.getSprite('icon_pause.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconResults:
        sprite = spriteManager.getSprite('icon_results.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconPlay:
        sprite = spriteManager.getSprite('icon_play.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconPlus:
        sprite = spriteManager.getSprite('icon_plus.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconPlusDisabled:
        sprite = spriteManager.getSprite('icon_plus_disabled.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconMinus:
        sprite = spriteManager.getSprite('icon_minus.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconMinusDisabled:
        sprite = spriteManager.getSprite('icon_minus_disabled.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconSettings:
        sprite = spriteManager.getSprite('icon_settings.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconYes:
        sprite = spriteManager.getSprite('icon_yes.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconNo:
        sprite = spriteManager.getSprite('icon_no.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.iconReload:
        sprite = spriteManager.getSprite('icon_reload.png');
        spritePressed = sprite;
        break;
      case ButtonType.iconTrash:
        sprite = spriteManager.getSprite('icon_trash.png');
        spritePressed = sprite;
        break;
      case ButtonType.iconHelp:
        sprite = spriteManager.getSprite('icon_help.png');
        spritePressed = spriteManager.getSprite('icon_pressed.png');
        break;
      case ButtonType.switchButtonOff:
        sprite = spriteManager.getSprite('switch_button_off.png');
        spritePressed = sprite;
        break;
      case ButtonType.switchButtonOn:
        sprite = spriteManager.getSprite('switch_button_on.png');
        spritePressed = sprite;
        break;
    }
  }

  void render(Canvas canvas) {
    double aspectRatio = (text != null) ? 3.5 : 1;
    double scale = 1;

    if (type == ButtonType.iconLeft || type == ButtonType.iconRight || type == ButtonType.iconSmallLeft || type == ButtonType.iconSmallRight) {
      aspectRatio = 0.8;
      scale = 0.7;
    }
    if (type == ButtonType.switchButtonOn || type == ButtonType.switchButtonOff) {
      aspectRatio = 2;
      scale = 0.7;
    }
    if (spriteBackground != null) {
      spriteBackground!.renderCentered(canvas, position: Vector2FromOffset.fromOffset(center), size: Vector2(buttonSize, buttonSize) * 1.5);
    }
    if (!isPressed) {
      sprite!.renderCentered(canvas, position: Vector2FromOffset.fromOffset(center), size: Vector2(buttonSize * scale * aspectRatio, buttonSize * scale));
    } else {
      spritePressed!.renderCentered(canvas, position: Vector2FromOffset.fromOffset(center), size: Vector2(buttonSize * scale * aspectRatio, buttonSize * scale));
    }

    if (text != null) {
      final TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: pow(buttonSize, 1 / 2) * 2.5, fontFamily: 'SaranaiGame'), text: text);
      Offset position = Offset(center.dx, center.dy);
      position = Offset(position.dx, position.dy - (isPressed ? pow(buttonSize, 1 / 2) * 2 : pow(buttonSize, 1 / 2) * 2.5));
      CanvasUtils.drawText(canvas, position, 0, span);
    }
  }

  void onTapDown(Offset point) {
    final double aspectRatio = (text != null) ? 3.5 : 1;
    final Offset delta = Offset(buttonSize * aspectRatio, buttonSize) / 2;
    isPressed = MapUtils.isInsideRect(point, center - delta, center + delta);
  }

  bool onTapUp(TapUpInfo details) {
    final double aspectRatio = (text != null) ? 3.5 : 1;
    final Offset delta = Offset(buttonSize * aspectRatio, buttonSize) / 2;
    if (MapUtils.isInsideRect(details.raw.globalPosition, center - delta, center + delta)) {
      isPressed = false;
      if (type == ButtonType.switchButtonOn) {
        type = ButtonType.switchButtonOff;
        onPress(false);
        getSprite();
      } else if (type == ButtonType.switchButtonOff) {
        type = ButtonType.switchButtonOn;
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
      buttonSize *= scale!;
    }
  }
}

enum ButtonType {
  barGreen,
  barYellow,
  barBlack,
  barBlue,
  barRed,
  iconCredits,
  iconLeft,
  iconRight,
  iconSmallLeft,
  iconSmallRight,
  iconPause,
  iconResults,
  iconPlay,
  iconPlus,
  iconPlusDisabled,
  iconMinus,
  iconMinusDisabled,
  iconSettings,
  iconYes,
  iconNo,
  iconReload,
  iconTrash,
  iconHelp,
  switchButtonOff,
  switchButtonOn
}
