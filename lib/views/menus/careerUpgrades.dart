import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/saveUtil.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';
import 'careerMenu.dart';

class CareerUpgradesMenu implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;
  Sprite backText;
  Sprite backTextDisabled;
  Sprite barGreen;
  Sprite barBlue;
  Sprite barRed;
  Sprite barEmpty;
  int index = 0;
  Career career;

  final Function navigate;

  CareerUpgradesMenu(this.spriteManager, this.navigate, this.career);

  void onAttach() async {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }

    createButtons();

    backText = spriteManager.getSprite('yellow_button_01.png');
    backTextDisabled = spriteManager.getSprite('black_button_01.png');
    buttonBackground = spriteManager.getSprite('back_tour.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
    barGreen = spriteManager.getSprite('bar_green.png');
    barBlue = spriteManager.getSprite('bar_blue.png');
    barEmpty = spriteManager.getSprite('bar_empty.png');
    barRed = spriteManager.getSprite('bar_red.png');
  }

  createButtons() async {
    double buttonSize = screenSize.height / 7;
    buttons = [];
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 5.5 * buttonSize),
      ButtonType.BAR_RED,
      () => {navigate(GameManagerState.CAREER_MENU)},
      text: 'Career',
    ));
    buttons.add(Button(this.spriteManager, Offset(screenSize.width * 0.73, 2.9 * buttonSize), ButtonType.BAR_RED, () {
      if (career.riders < 6 && career.cash >= getRiderPrice()) {
        career.cash -= getRiderPrice();
        career.riders++;
        SaveUtil.saveCareer(career);
        createButtons();
      }
    }, text: '\$ ${priceToString(getRiderPrice())}', scale: 0.5));
    buttons.add(Button(this.spriteManager, Offset(screenSize.width * 0.73, (2.9 + 0.7) * buttonSize), ButtonType.BAR_GREEN, () {
      if (career.rankingTypes < 5 && career.cash >= getRankingPrice()) {
        career.cash -= getRankingPrice();
        career.rankingTypes++;
        SaveUtil.saveCareer(career);
        createButtons();
      }
    }, text: '\$ ${priceToString(getRankingPrice())}', scale: 0.5));
    buttons.add(Button(this.spriteManager, Offset(screenSize.width * 0.73, (2.9 + 1.4) * buttonSize), ButtonType.BAR_BLUE, () {
      if (career.raceTypes < 8 && career.cash >= getRacePrice()) {
        career.cash -= getRacePrice();
        career.raceTypes++;
        SaveUtil.saveCareer(career);
        createButtons();
      }
    }, text: '\$ ${priceToString(getRacePrice())}', scale: 0.5));
    buttons.forEach((element) {
      element.setScreenSize(screenSize);
    });
  }

  String priceToString(int earnings) {
    if (earnings == null) {
      return 'maxed';
    }
    if (earnings > 1000 * 1000) {
      return (earnings / 1000 / 1000).toString() + 'M';
    }
    if (earnings > 1000) {
      return (earnings / 1000).toString() + 'k';
    }
    return earnings.toString();
  }

  getRiderPrice() {
    switch (career.riders) {
      case 1:
        return 50;
      case 2:
        return 600;
      case 3:
        return 12000;
      case 4:
        return 50 * 1000;
      case 5:
        return 700 * 1000;
    }
  }

  getRankingPrice() {
    switch (career.rankingTypes) {
      case 1:
        return 200; // Sprints
      case 2:
        return 1000; // Team
      case 3:
        return 5000; // Mountain
      case 4:
        return 25000; // Young
    }
  }

  getRacePrice() {
    switch (career.raceTypes) {
      case 1:
        return 300;
      case 2:
        return 2000;
      case 3:
        return 12000;
      case 4:
        return 60 * 1000;
      case 5:
        return 160 * 1000;
      case 6:
        return 760 * 1000;
      case 7:
        return 5 * 1000 * 1000;
    }
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

    buttonBackground.render(canvas, position: Vector2(screenSize.width / 6, buttonSize * 1.05), size: Vector2(screenSize.width / 3 * 2, screenSize.height - buttonSize * 1.5));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader.render(canvas, position: Vector2(screenSize.width / 3, buttonSize * 0.8), size: Vector2(screenSize.width / 3, buttonSize));

    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Upgrades');
    Offset position = Offset(screenSize.width / 2, buttonSize * 1.05);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'You have: ${career.cash} \$');
    position = Offset(screenSize.width / 2, 2 * buttonSize);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: 'Your riders');
    position = Offset(screenSize.width / 3, buttonSize * 2.7);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: 'Rankings');
    position = Offset(screenSize.width / 3, buttonSize * (2.7 + 0.7));
    CanvasUtils.drawText(canvas, position, 0, span);

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: 'Race type');
    position = Offset(screenSize.width / 3, buttonSize * (2.7 + 1.4));
    CanvasUtils.drawText(canvas, position, 0, span);

    for (int i = 0; i < 8; i++) {
      Sprite sprite = (i < career.riders) ? barRed : barEmpty;
      if (i < 6) {
        renderBar(canvas, sprite, i, 0, buttonSize);
      }
      sprite = (i < career.rankingTypes) ? barGreen : barEmpty;
      if (i < 5) {
        renderBar(canvas, sprite, i, 1, buttonSize);
      }
      sprite = (i < career.raceTypes) ? barBlue : barEmpty;
      renderBar(canvas, sprite, i, 2, buttonSize);
    }
  }

  renderBar(Canvas canvas, Sprite sprite, int horizontalOffset, int verticalOffset, double buttonSize) {
    sprite.render(canvas,
        position: Vector2(screenSize.width / 2.3 + screenSize.width / 60 * horizontalOffset * 1.5, buttonSize * 2.6 + buttonSize * 0.7 * verticalOffset),
        size: Vector2(screenSize.width / 60, buttonSize / 2));
  }

  @override
  void resize(Size size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}
