import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class TutorialView implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;

  final Function navigate;
  BaseView backgroundView;
  TutorialType tutorialType;

  TutorialView(this.spriteManager, this.navigate, this.backgroundView,
      this.tutorialType);

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
        Offset(screenSize.width / 2, 4 * buttonSize + buttonSize * 1.1),
        ButtonType.ICON_YES,
        () => {navigate(GameManagerState.CLOSE_TUTORIAL)}));
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

  getText() {
    List<String> text = [];
    switch (tutorialType) {
      case TutorialType.FIRST_OPEN:
        text.add('Welcome');
        break;
      case TutorialType.CAREER:
        text.add('Career');
        break;
      case TutorialType.SINGLE_RACE:
        text.add('Single race');
        break;
      case TutorialType.TOUR:
        text.add('Tour');
        break;
      case TutorialType.OPEN_RACE:
        text.add('Race time');
        break;
      case TutorialType.THROW_DICE:
        text.add('Your turn');
        break;
      case TutorialType.SELECT_POSITION:
        text.add('Select a position');
        break;
      case TutorialType.FOLLOW:
        text.add('Follow.. or not');
        break;
      case TutorialType.NO_FOLLOW_AVAILABLE:
        text.add('Can\'t follow');
        break;
      case TutorialType.FOLLOW_AFTER_AUTO_FOLLOW:
        text.add('Maybe still follow');
        break;
      case TutorialType.FIELDVALUE:
        text.add('Difficult terrain');
        break;
      case TutorialType.FIELDVALUE_POSITIVE:
        text.add('Downhill!');
        break;
      case TutorialType.SPRINT:
        text.add('Sprint!');
        break;
      case TutorialType.FINISH:
        text.add('Finish!');
        break;
      case TutorialType.RANKINGS:
        text.add('Rankings');
        break;
      case TutorialType.SETTINGS:
        text.add('Settings');
        break;
      case TutorialType.TOUR_FIRST_FINISHED:
        text.add('On to the next one');
        break;
    }
    return text;
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

enum TutorialType {
  FIRST_OPEN,
  CAREER,
  SINGLE_RACE,
  TOUR,
  OPEN_RACE,
  THROW_DICE,
  SELECT_POSITION,
  FOLLOW,
  NO_FOLLOW_AVAILABLE,
  FOLLOW_AFTER_AUTO_FOLLOW,
  FIELDVALUE,
  FIELDVALUE_POSITIVE,
  SPRINT,
  FINISH,
  RANKINGS,
  SETTINGS,
  TOUR_FIRST_FINISHED,
}
