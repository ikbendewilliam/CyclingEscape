import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/mapUtils.dart';
import 'package:CyclingEscape/views/menus/tourSelect.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class CareerMenu implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  List<RaceType> raceTypes = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;
  Sprite backText;
  Sprite backTextDisabled;
  int index = 0;

  final Function navigate;

  CareerMenu(this.spriteManager, this.navigate) {
    raceTypes.add(RaceType(
        'local race', 50, Tour(8, 1, 1, MapType.FLAT, MapLength.SHORT)));
    raceTypes.add(RaceType(
        'national race', 300, Tour(6, 2, 1, MapType.COBBLE, MapLength.MEDIUM)));
    raceTypes.add(RaceType('continental race', 2000,
        Tour(5, 3, 1, MapType.HILLS, MapLength.LONG)));
    raceTypes.add(RaceType(
        'national tour', 6000, Tour(4, 3, 1, MapType.FLAT, MapLength.SHORT)));
    raceTypes.add(RaceType('continental tour', 30 * 1000,
        Tour(5, 4, 1, MapType.HILLS, MapLength.MEDIUM)));
    raceTypes.add(RaceType('international race', 84 * 1000,
        Tour(7, 5, 1, MapType.HEAVY, MapLength.VERY_LONG)));
    raceTypes.add(RaceType('international tour', 1500 * 1000,
        Tour(6, 5, 8, MapType.HEAVY, MapLength.LONG)));
    raceTypes.add(RaceType('World tour', 5 * 1000 * 1000,
        Tour(8, 6, 20, MapType.HEAVY, MapLength.VERY_LONG)));
  }

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
  }

  createButtons() async {
    double buttonSize = screenSize.height / 7;
    buttons = [];
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 - buttonSize * 3.25, 3 * buttonSize),
      ButtonType.ICON_HELP,
      () {},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 - buttonSize * 2.25, 3 * buttonSize),
      ButtonType.ICON_MINUS,
      () {
        index = (index - 1 < 0) ? raceTypes.length - 1 : index - 1;
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 + buttonSize * 2.25, 3 * buttonSize),
      ButtonType.ICON_PLUS,
      () {
        index = index + 1 >= raceTypes.length ? 0 : index + 1;
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 + buttonSize * 3.25, 3 * buttonSize),
      ButtonType.ICON_PLAY,
      () {},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 4.4 * buttonSize),
      ButtonType.BAR_GREEN,
      () => {navigate(GameManagerState.CAREER_UPGRADES_MENU)},
      'Upgrades',
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2, 5.5 * buttonSize),
      ButtonType.BAR_RED,
      () => {navigate(GameManagerState.MAIN_MENU)},
      'Main menu',
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
        canvas, Position(screenSize.width / 6, buttonSize * 1.05),
        size: Position(
            screenSize.width / 3 * 2, screenSize.height - buttonSize * 1.5));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader.renderPosition(
        canvas, Position(screenSize.width / 3, buttonSize * 0.8),
        size: Position(screenSize.width / 3, buttonSize));

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'Career');
    Offset position = Offset(screenSize.width / 2, buttonSize * 1.05);

    CanvasUtils.drawText(canvas, position, 0, span);

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'You have: 2051 \$');
    position = Offset(screenSize.width / 2, 2 * buttonSize);

    CanvasUtils.drawText(canvas, position, 0, span);

    Sprite sprite = raceTypes[index]?.tour?.ridersPerTeam == 1
        ? backText
        : backTextDisabled;
    sprite.renderCentered(
        canvas, Position(screenSize.width / 2, 3 * buttonSize),
        size: Position(buttonSize * 3.5, buttonSize));

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'),
        text: raceTypes[index].name);
    position = Offset(screenSize.width / 2, 3 * buttonSize - buttonSize * 0.25);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'),
        text: 'winner earns: \$' + earningsToString(raceTypes[index].earnings));
    position = Offset(screenSize.width / 2, 3 * buttonSize + buttonSize * 0.5);

    CanvasUtils.drawText(canvas, position, 0, span);
  }

  String earningsToString(int earnings) {
    if (earnings > 1000 * 1000) {
      return (earnings / 1000 / 1000).toString() + 'M';
    }
    if (earnings > 1000) {
      return (earnings / 1000).toString() + 'k';
    }
    return earnings.toString();
  }

  @override
  void resize(Size size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}

class RaceType {
  final String name;
  final int earnings;
  final Tour tour;

  RaceType(this.name, this.earnings, this.tour);
}
