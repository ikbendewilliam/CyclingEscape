import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class CreditsView implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;

  final Function navigate;

  CreditsView(this.spriteManager, this.navigate);

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
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 6 * buttonSize),
      ButtonType.ICON_NO,
      () => {navigate(GameManagerState.MAIN_MENU)},
    ));
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
        canvas, Position(screenSize.width / 4, buttonSize * 0.4),
        size: Position(screenSize.width / 2, screenSize.height / 1.1));

    buttons.forEach((button) {
      button.render(canvas);
    });

    double y = buttonSize * 1.1;
    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 9, fontFamily: 'SaranaiGame'),
        text: 'This game is made by me (WiVe or simply William Verhaeghe)');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, y += 0.3 * buttonSize), 0, span);

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 9, fontFamily: 'SaranaiGame'),
        text: 'This game is made possible thanks ');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, y += 0.6 * buttonSize), 0, span);
    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 9, fontFamily: 'SaranaiGame'),
        text: ' to the following great people');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, y += 0.3 * buttonSize), 0, span);

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 9, fontFamily: 'SaranaiGame'),
        text: 'Bart barto - cyclists and listening to me whining');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, y += 0.3 * buttonSize), 0, span);

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 9, fontFamily: 'SaranaiGame'),
        text: 'thedarkbear.itch.io/3-parallax - the background in the menus');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, y += 0.3 * buttonSize), 0, span);

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 9, fontFamily: 'SaranaiGame'),
        text: 'kenney.nl - for the icons, foiliage and grass');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, y += 0.3 * buttonSize), 0, span);

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 9, fontFamily: 'SaranaiGame'),
        text: 'kidcomic.net - the game icon');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, y += 0.3 * buttonSize), 0, span);

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 9, fontFamily: 'SaranaiGame'),
        text: 'Saranai - the game UI');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, y += 0.3 * buttonSize), 0, span);

    backgroundHeader.renderPosition(
        canvas, Position(screenSize.width / 3, buttonSize * 0.21),
        size: Position(screenSize.width / 3, buttonSize * 0.8));

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'Credits');
    Offset position = Offset(screenSize.width / 2, buttonSize * 0.35);
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
