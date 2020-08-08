import 'dart:math';

import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/mapUtils.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class TourSelectMenu implements BaseView {
  int selectedColor = 0;
  @override
  Size screenSize;
  Tour selectedTour;
  List<Tour> tours = [];
  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;
  Sprite backgroundTour;
  Sprite backText;

  final Function navigate;

  TourSelectMenu(this.navigate);

  void onAttach() {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    double dy = 54;
    createButtons(dy);

    buttonBackground = Sprite('back_tour.png');
    backgroundHeader = Sprite('back_text_01.png');
    backText = Sprite('yellow_button_01.png');
    backgroundTour = Sprite('options_back_01.png');

    generateTours();
  }

  generateTours() {
    tours = [];
    generateTour();
    generateTour();
    generateTour();
    generateTour();
  }

  generateTour() {
    MapLength mapLength = [
      MapLength.SHORT,
      MapLength.MEDIUM,
      MapLength.LONG,
      MapLength.VERY_LONG
    ][Random().nextInt(4)];
    MapType mapType = [
      MapType.FLAT,
      MapType.COBBLE,
      MapType.HILLS,
      MapType.HEAVY
    ][Random().nextInt(4)];
    int teams = Random().nextInt(7) + 2;
    int riders = Random().nextInt(5) + 2;
    int races = Random().nextInt(4) + 2;
    tours.add(Tour(teams, riders, races, mapType, mapLength));
  }

  createButtons(double buttonSize) {
    buttons.add(Button(
      Offset(screenSize.width / 7 * 3, 5.25 * buttonSize),
      ButtonType.ICON_NO,
      () => {navigate(GameManagerState.MAIN_MENU)},
    ));
    buttons.add(Button(
      Offset(screenSize.width / 2, 5.25 * buttonSize),
      ButtonType.ICON_RELOAD,
      () => {generateTours()},
    ));
    buttons.add(Button(
      Offset(screenSize.width / 7 * 4, 5.25 * buttonSize),
      ButtonType.ICON_PLAY,
      () => {
        selectedTour != null
            ? navigate(GameManagerState.PLAYING,
                tourSettings: selectedTour, team: selectedColor)
            : null
      },
    ));
    buttons.add(Button(
      Offset(screenSize.width / 7 * 3, 4.3 * buttonSize),
      ButtonType.ICON_SMALL_LEFT,
      () => {selectedColor = (selectedColor - 1 + 8) % 8},
    ));
    buttons.add(Button(
      Offset(screenSize.width / 7 * 4, 4.3 * buttonSize),
      ButtonType.ICON_SMALL_RIGHT,
      () => {selectedColor = (selectedColor + 1) % 8},
    ));
  }

  mapTypeAsString(MapType mapType) {
    switch (mapType) {
      case MapType.FLAT:
        return 'Flat';
      case MapType.COBBLE:
        return 'Cobbled';
      case MapType.HILLS:
        return 'Hilled';
      case MapType.HEAVY:
        return 'HEAVY';
    }
  }

  mapLengthAsString(MapLength mapLength) {
    switch (mapLength) {
      case MapLength.SHORT:
        return 'Short';
      case MapLength.MEDIUM:
        return 'Medium';
      case MapLength.LONG:
        return 'Long';
      case MapLength.VERY_LONG:
        return 'Very long';
    }
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

    double buttonSize = screenSize.height / 7;
    tours.asMap().forEach((i, element) {
      Offset start =
          Offset(screenSize.width / 6 * 1.1 * (i + 0.77), buttonSize * 1.7);
      if (MapUtils.isInsideRect(details.globalPosition, start,
          start + Offset(screenSize.width / 6, buttonSize * 2.2))) {
        selectedTour = element;
      }
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
        canvas, Position(screenSize.width / 8, buttonSize),
        size: Position(screenSize.width / 8 * 6, screenSize.height / 1.4));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader.renderPosition(
        canvas, Position(screenSize.width / 3, buttonSize * 0.81),
        size: Position(screenSize.width / 3, buttonSize * 0.8));

    Paint paint = Paint()
      ..color = Team.getColorFromId(selectedColor)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(screenSize.width / 2, buttonSize * 4.3), buttonSize / 4, paint);

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 12, fontFamily: 'SaranaiGame'),
        text: '${(selectedColor + 2) * 10}');
    CanvasUtils.drawText(
        canvas, Offset(screenSize.width / 2, buttonSize * 4.15), 0, span);

    tours.asMap().forEach((i, element) {
      Color drawColor =
          element == selectedTour ? Colors.green[600] : Colors.white;
      backgroundTour.renderPosition(canvas,
          Position(screenSize.width / 6 * 1.1 * (i + 0.77), buttonSize * 1.7),
          size: Position(screenSize.width / 6, buttonSize * 2.2));

      Offset position =
          Offset(screenSize.width / 6 * 1.1 * (i + 1.27), buttonSize * 1.8);

      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'),
          text: 'Teams: ${element.teams}');
      CanvasUtils.drawText(
          canvas, position + Offset(0, buttonSize / 3 * 0), 0, span);
      span = new TextSpan(
          style: new TextStyle(
              color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'),
          text: 'Riders: ${element.ridersPerTeam * element.teams}');
      CanvasUtils.drawText(
          canvas, position + Offset(0, buttonSize / 3 * 1), 0, span);
      span = new TextSpan(
          style: new TextStyle(
              color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'),
          text: 'Races: ${element.races}');
      CanvasUtils.drawText(
          canvas, position + Offset(0, buttonSize / 3 * 2), 0, span);
      span = new TextSpan(
          style: new TextStyle(
              color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'),
          text: 'Type: ${mapTypeAsString(element.mapType)}');
      CanvasUtils.drawText(
          canvas, position + Offset(0, buttonSize / 3 * 3), 0, span);
      span = new TextSpan(
          style: new TextStyle(
              color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'),
          text: 'Length:');
      CanvasUtils.drawText(
          canvas, position + Offset(0, buttonSize / 3 * 4), 0, span);
      span = new TextSpan(
          style: new TextStyle(
              color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'),
          text: '${mapLengthAsString(element.mapLength)}');
      CanvasUtils.drawText(
          canvas, position + Offset(0, buttonSize / 3 * 5), 0, span);
    });

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'Start a tour');
    Offset position = Offset(screenSize.width / 2, buttonSize * 0.95);
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
  void update(double t) {
    // TODO: implement update
  }
}

class Tour {
  final int teams;
  final int ridersPerTeam;
  final int races;
  final MapType mapType;
  final MapLength mapLength;

  Tour(
      this.teams, this.ridersPerTeam, this.races, this.mapType, this.mapLength);
}
