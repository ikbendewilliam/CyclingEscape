import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';

class FollowSelect implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundText;

  final Function returnValue;
  final int minThrow;

  FollowSelect(this.spriteManager, this.returnValue, this.minThrow);

  void onAttach() {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    double dy = 54;
    createButtons(dy);

    buttonBackground = this.spriteManager.getSprite('options_back_01.png');
    backgroundText = this.spriteManager.getSprite('back_text_04.png');
  }

  createButtons(double buttonSize) {
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 4 * buttonSize - buttonSize * 1.1),
      ButtonType.BAR_GREEN,
      () => {returnValue(FollowType.FOLLOW)},
      'Follow',
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 4 * buttonSize),
      ButtonType.BAR_YELLOW,
      () => {returnValue(FollowType.LEAVE)},
      'Leave',
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 4 * buttonSize + buttonSize * 1.1),
      ButtonType.BAR_YELLOW,
      () => {returnValue(FollowType.AUTO_FOLLOW)},
      'Auto follow',
    ));
  }

  @override
  void onScaleUpdate(ScaleUpdateDetails details) {
    buttons.forEach((button) {
      button.onTapDown(details.focalPoint);
    });
  }

  @override
  void onScaleStart(ScaleStartDetails details) {
    // TODO: implement onScaleStart
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

    buttonBackground.renderPosition(
        canvas, Position(screenSize.width / 3, 2 * buttonSize),
        size:
            Position(screenSize.width / 3, screenSize.height - buttonSize * 3));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundText.renderRect(
        canvas,
        Rect.fromLTRB(
            screenSize.width / 2 - buttonSize * 1.75,
            buttonSize * 1.4,
            screenSize.width / 2 + buttonSize * 1.75,
            buttonSize * 1.8));

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 12, fontFamily: 'SaranaiGame'),
        text: 'You need to throw $minThrow');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, buttonSize * 1.45), 0, span);
  }

  @override
  void resize(Size size) {
    this.screenSize = size;
    double buttonSize = screenSize.height / 7;
    buttons = [];
    createButtons(buttonSize);
    buttons.forEach((element) {
      element.setScreenSize(size);
    });
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}

enum FollowType { FOLLOW, LEAVE, AUTO_FOLLOW }
