import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/views/menus/menuBackground.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class MainMenu implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;

  final Function navigate;

  MainMenu(this.spriteManager, this.navigate);

  void onAttach() {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  createButtons(double buttonSize) {
    buttons = [];
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 4 * buttonSize - buttonSize * 1.1),
      ButtonType.BAR_GREEN,
      () => {navigate(GameManagerState.COURSE_SELECT_MENU)},
      'Career',
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 4 * buttonSize),
      ButtonType.BAR_YELLOW,
      () => {navigate(GameManagerState.COURSE_SELECT_MENU)},
      'Single race',
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 4 * buttonSize + buttonSize * 1.1),
      ButtonType.BAR_YELLOW,
      () => {navigate(GameManagerState.TOUR_SELECT_MENU)},
      'Tour',
    ));
    buttons.add(Button(
        this.spriteManager,
        Offset(buttonSize / 2 + 5, screenSize.height - buttonSize / 2 - 5),
        ButtonType.ICON_CREDITS,
        () => {navigate(GameManagerState.CREDITS)}));
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
        canvas, Position(screenSize.width / 3.3, buttonSize * 1.45),
        size: Position(screenSize.width * 1.3 / 3.3,
            screenSize.height - buttonSize * 2.5));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader.renderPosition(
        canvas, Position(screenSize.width / 3, buttonSize * 1.2),
        size: Position(screenSize.width / 3, buttonSize));

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'Cycling Escape');
    Offset position = Offset(screenSize.width / 2, buttonSize * 1.4);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  @override
  void resize(Size size) {
    screenSize = size;
    double buttonSize = screenSize.height / 7;
    buttons = [];
    createButtons(buttonSize);
    buttons.forEach((element) {
      element.setScreenSize(size);
    });
  }

  @override
  void update(double t) {}
}
