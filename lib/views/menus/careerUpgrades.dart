import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/saveUtil.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class CareerUpgradesMenu implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;

  final Function navigate;

  CareerUpgradesMenu(this.spriteManager, this.navigate);

  void onAttach() async {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }

    createButtons();

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  createButtons() async {
    bool canContinue = await SaveUtil.hasCyclingView();
    double buttonSize = screenSize.height / 7;
    buttons = [];
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 4 * buttonSize - buttonSize * 0.5),
      ButtonType.BAR_RED,
      () => {navigate(GameManagerState.CAREER_MENU)},
      'Career',
    ));
    buttons.forEach((element) {
      element.setScreenSize(screenSize);
    });
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
    double buttonSize = screenSize.height / 7;

    buttonBackground.renderPosition(
        canvas, Position(screenSize.width / 3.3, buttonSize * 1.05),
        size: Position(screenSize.width * 1.3 / 3.3,
            screenSize.height - buttonSize * 1.5));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader.renderPosition(
        canvas, Position(screenSize.width / 3, buttonSize * 0.8),
        size: Position(screenSize.width / 3, buttonSize));

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'Cycling Escape');
    Offset position = Offset(screenSize.width / 2, buttonSize * 1.05);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}
