import 'package:CyclingEscape/components/data/playSettings.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/mapUtils.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class CourseSelectMenu implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  int teams = 4;
  int ridersPerTeam = 4;
  int selectedColor = 0;
  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;
  Sprite backText;
  MapType maptype = MapType.FLAT;
  MapLength mapLength = MapLength.MEDIUM;

  final Function navigate;

  CourseSelectMenu(this.spriteManager, this.navigate);

  void onAttach() {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
    backText = spriteManager.getSprite('yellow_button_01.png');
  }

  createButtons(double buttonSize) {
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 - buttonSize * 2.25, 2.7 * buttonSize - buttonSize * 1.1),
      ButtonType.ICON_MINUS,
      () {
        teams--;
        teams = teams <= 0 ? 8 : teams;
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 + buttonSize * 2.25, 2.7 * buttonSize - buttonSize * 1.1),
      ButtonType.ICON_PLUS,
      () {
        teams++;
        teams = teams > 8 ? 1 : teams;
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 - buttonSize * 2.25, 2.7 * buttonSize),
      ButtonType.ICON_MINUS,
      () {
        ridersPerTeam--;
        ridersPerTeam = ridersPerTeam <= 0 ? 6 : ridersPerTeam;
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 + buttonSize * 2.25, 2.7 * buttonSize),
      ButtonType.ICON_PLUS,
      () {
        ridersPerTeam++;
        ridersPerTeam = ridersPerTeam > 6 ? 1 : ridersPerTeam;
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1),
      ButtonType.ICON_MINUS,
      () => {decreaseType()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1),
      ButtonType.ICON_PLUS,
      () => {increaseType()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 2),
      ButtonType.ICON_MINUS,
      () => {decreaseLength()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 2),
      ButtonType.ICON_PLUS,
      () => {increaseLength()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 9 * 3, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.ICON_NO,
      () => {navigate(GameManagerState.MAIN_MENU)},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 9 * 6, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.ICON_PLAY,
      () => {navigate(GameManagerState.PLAYING, playSettings: PlaySettings(teams, ridersPerTeam, maptype, mapLength), team: selectedColor)},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 7 * 3, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.ICON_SMALL_LEFT,
      () => {selectedColor = (selectedColor - 1 + 8) % 8},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 7 * 4, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.ICON_SMALL_RIGHT,
      () => {selectedColor = (selectedColor + 1) % 8},
    ));
  }

  increaseType() {
    switch (maptype) {
      case MapType.FLAT:
        maptype = MapType.COBBLE;
        break;
      case MapType.COBBLE:
        maptype = MapType.HILLS;
        break;
      case MapType.HILLS:
        maptype = MapType.HEAVY;
        break;
      case MapType.HEAVY:
        maptype = MapType.FLAT;
        break;
    }
  }

  decreaseType() {
    switch (maptype) {
      case MapType.FLAT:
        maptype = MapType.HEAVY;
        break;
      case MapType.COBBLE:
        maptype = MapType.FLAT;
        break;
      case MapType.HILLS:
        maptype = MapType.COBBLE;
        break;
      case MapType.HEAVY:
        maptype = MapType.HILLS;
        break;
    }
  }

  increaseLength() {
    switch (mapLength) {
      case MapLength.SHORT:
        mapLength = MapLength.MEDIUM;
        break;
      case MapLength.MEDIUM:
        mapLength = MapLength.LONG;
        break;
      case MapLength.LONG:
        mapLength = MapLength.VERY_LONG;
        break;
      case MapLength.VERY_LONG:
        mapLength = MapLength.SHORT;
        break;
    }
  }

  decreaseLength() {
    switch (mapLength) {
      case MapLength.SHORT:
        mapLength = MapLength.VERY_LONG;
        break;
      case MapLength.MEDIUM:
        mapLength = MapLength.SHORT;
        break;
      case MapLength.LONG:
        mapLength = MapLength.MEDIUM;
        break;
      case MapLength.VERY_LONG:
        mapLength = MapLength.LONG;
        break;
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

    buttonBackground.render(canvas, position: Vector2(screenSize.width / 4, buttonSize * 0.4), size: Vector2(screenSize.width / 2, screenSize.height / 1.1));

    buttons.forEach((button) {
      button.render(canvas);
    });

    Paint paint = Paint()
      ..color = Team.getColorFromId(selectedColor)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(screenSize.width / 2, buttonSize * 6), buttonSize / 4, paint);

    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'SaranaiGame'), text: '${(selectedColor + 2) * 10}');
    CanvasUtils.drawText(canvas, Offset(screenSize.width / 2, buttonSize * 5.85), 0, span);

    backText.render(canvas, position: Vector2(screenSize.width / 2, 2.7 * buttonSize - buttonSize * 1.1), anchor: Anchor.center, size: Vector2(buttonSize * 3.5, buttonSize));

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Teams: $teams');
    Offset position = Offset(screenSize.width / 2, 2.7 * buttonSize - buttonSize * 1.1 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText.render(canvas, position: Vector2(screenSize.width / 2, 2.7 * buttonSize), anchor: Anchor.center, size: Vector2(buttonSize * 3.5, buttonSize));

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Riders: ${ridersPerTeam * teams}');
    position = Offset(screenSize.width / 2, 2.7 * buttonSize - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText.render(canvas, position: Vector2(screenSize.width / 2, 2.7 * buttonSize + buttonSize * 1.1), anchor: Anchor.center, size: Vector2(buttonSize * 3.5, buttonSize));

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: mapTypeAsString(maptype));
    position = Offset(screenSize.width / 2, 2.7 * buttonSize + buttonSize * 1.1 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText.render(canvas, position: Vector2(screenSize.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2), anchor: Anchor.center, size: Vector2(buttonSize * 3.5, buttonSize));

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: mapLengthAsString(mapLength));
    position = Offset(screenSize.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundHeader.render(canvas, position: Vector2(screenSize.width / 3, buttonSize * 0.21), size: Vector2(screenSize.width / 3, buttonSize * 0.8));

    span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Configure game');
    position = Offset(screenSize.width / 2, buttonSize * 0.35);
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
