import 'dart:math';

import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:cycling_escape/components/data/team.dart';
import 'package:cycling_escape/components/ui/button.dart';
import 'package:cycling_escape/utils/canvasUtils.dart';
import 'package:cycling_escape/utils/mapUtils.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class TourSelectMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final AppLocalizations appLocalizations;

  int selectedColor = 0;
  Tour? selectedTour;
  List<Tour> tours = [];
  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Sprite? backgroundTour;
  Sprite? backText;

  final Function navigate;

  TourSelectMenu(this.spriteManager, this.navigate, this.appLocalizations);

  void onAttach() {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('back_tour.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
    backText = spriteManager.getSprite('yellow_button_01.png');
    backgroundTour = spriteManager.getSprite('options_back_01.png');

    generateTours();
  }

  generateTours() {
    tours = [];
    generateTour();
    // tours.add(Tour(3, 3, 5, MapType.HILLS, MapLength.SHORT));
    generateTour();
    generateTour();
    generateTour();
  }

  generateTour() {
    MapLength mapLength = [MapLength.SHORT, MapLength.MEDIUM, MapLength.LONG, MapLength.VERY_LONG][Random().nextInt(4)];
    MapType mapType = [MapType.FLAT, MapType.COBBLE, MapType.HILLS, MapType.HEAVY][Random().nextInt(4)];
    int teams = Random().nextInt(7) + 2;
    int riders = Random().nextInt(5) + 2;
    int races = (Random().nextInt(4) + 1) * 2;
    tours.add(Tour(teams, riders, races, mapType, mapLength));
  }

  createButtons(double buttonSize) {
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 7 * 3, 5.25 * buttonSize),
      ButtonType.ICON_NO,
      () => {navigate(GameManagerState.MAIN_MENU)},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2, 5.25 * buttonSize),
      ButtonType.ICON_RELOAD,
      () => {generateTours()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 7 * 4, 5.25 * buttonSize),
      ButtonType.ICON_PLAY,
      () => {selectedTour != null ? navigate(GameManagerState.PLAYING, tourSettings: selectedTour, team: selectedColor) : null},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 7 * 3, 4.3 * buttonSize),
      ButtonType.ICON_SMALL_LEFT,
      () => {selectedColor = (selectedColor - 1 + 8) % 8},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 7 * 4, 4.3 * buttonSize),
      ButtonType.ICON_SMALL_RIGHT,
      () => {selectedColor = (selectedColor + 1) % 8},
    ));
  }

  mapTypeAsString(MapType mapType) {
    switch (mapType) {
      case MapType.FLAT:
        return appLocalizations.raceTypeFlat;
      case MapType.COBBLE:
        return appLocalizations.raceTypeCobbled;
      case MapType.HILLS:
        return appLocalizations.raceTypeHilled;
      case MapType.HEAVY:
        return appLocalizations.raceTypeHeavy;
    }
  }

  mapLengthAsString(MapLength mapLength) {
    switch (mapLength) {
      case MapLength.SHORT:
        return appLocalizations.raceDurationShort;
      case MapLength.MEDIUM:
        return appLocalizations.raceDurationMedium;
      case MapLength.LONG:
        return appLocalizations.raceDurationLong;
      case MapLength.VERY_LONG:
        return appLocalizations.raceDurationVeryLong;
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

    double buttonSize = screenSize!.height / 7;
    tours.asMap().forEach((i, element) {
      Offset start = Offset(screenSize!.width / 6 * 1.1 * (i + 0.77), buttonSize * 1.7);
      if (MapUtils.isInsideRect(details.globalPosition, start, start + Offset(screenSize!.width / 6, buttonSize * 2.2))) {
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
    double buttonSize = screenSize!.height / 7;

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 8, buttonSize), size: Vector2(screenSize!.width / 8 * 6, screenSize!.height / 1.4));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.81), size: Vector2(screenSize!.width / 3, buttonSize * 0.8));

    Paint paint = Paint()
      ..color = Team.getColorFromId(selectedColor)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(screenSize!.width / 2, buttonSize * 4.3), buttonSize / 4, paint);

    TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'SaranaiGame'), text: '${(selectedColor + 2) * 10}');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize * 4.15), 0, span);

    tours.asMap().forEach((i, element) {
      Color? drawColor = element == selectedTour ? Colors.green[600] : Colors.white;
      backgroundTour!.render(canvas, position: Vector2(screenSize!.width / 6 * 1.1 * (i + 0.77), buttonSize * 1.7), size: Vector2(screenSize!.width / 6, buttonSize * 2.2));

      Offset position = Offset(screenSize!.width / 6 * 1.1 * (i + 1.27), buttonSize * 1.8);

      TextSpan span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: appLocalizations.raceTeams + ' ${element.teams}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 0), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: appLocalizations.raceRiders + ' ${element.ridersPerTeam * element.teams}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 1), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: appLocalizations.races + ' ${element.races}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 2), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: appLocalizations.raceType + ' ${mapTypeAsString(element.mapType)}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 3), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: appLocalizations.raceDuration);
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 4), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: '${mapLengthAsString(element.mapLength)}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 5), 0, span);
    });

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: appLocalizations.tourTitle);
    Offset position = Offset(screenSize!.width / 2, buttonSize * 0.95);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    double buttonSize = screenSize!.height / 7;
    buttons = [];
    createButtons(buttonSize);
    buttons.forEach((element) {
      element.setScreenSize(size!);
    });
  }

  @override
  void update(double t) {}
}

class Tour {
  final int teams;
  final int ridersPerTeam;
  final int races;
  final MapType mapType;
  final MapLength mapLength;
  String? id = UniqueKey().toString();

  Tour(this.teams, this.ridersPerTeam, this.races, this.mapType, this.mapLength);

  static Tour fromJson(Map<String, dynamic> json) {
    Tour tour = Tour(
      json['teams'],
      json['ridersPerTeam'],
      json['races'],
      getMapTypeFromString(json['mapType']),
      getMapLengthFromString(json['mapLength']),
    );
    tour.id = json['id'];
    return tour;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['teams'] = this.teams;
    data['ridersPerTeam'] = this.ridersPerTeam;
    data['races'] = this.races;
    data['mapType'] = this.mapType.toString();
    data['mapLength'] = this.mapLength.toString();
    return data;
  }
}
