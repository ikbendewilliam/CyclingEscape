import 'dart:math';

import 'package:cycling_escape/screen_game/base_view.dart';
import 'package:cycling_escape/screen_game/game_manager.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/map/map_utils.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class TourSelectMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  int selectedColor = 0;
  Tour? selectedTour;
  List<Tour> tours = [];
  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Sprite? backgroundTour;
  Sprite? backText;

  final NavigateType navigate;

  TourSelectMenu(this.spriteManager, this.navigate, this.localizations);

  @override
  void onAttach() {
    buttons = [];
    screenSize ??= const Size(1, 1);
    const double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('back_tour.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
    backText = spriteManager.getSprite('yellow_button_01.png');
    backgroundTour = spriteManager.getSprite('options_back_01.png');

    generateTours();
  }

  void generateTours() {
    tours = [];
    generateTour();
    // tours.add(Tour(3, 3, 5, MapType.hills, MapLength.short));
    generateTour();
    generateTour();
    generateTour();
  }

  void generateTour() {
    final MapLength mapLength = [MapLength.short, MapLength.medium, MapLength.long, MapLength.veryLong][Random().nextInt(4)];
    final MapType mapType = [MapType.flat, MapType.cobble, MapType.hills, MapType.heavy][Random().nextInt(4)];
    final int teams = Random().nextInt(7) + 2;
    final int riders = Random().nextInt(5) + 2;
    final int races = (Random().nextInt(4) + 1) * 2;
    tours.add(Tour(teams, riders, races, mapType, mapLength));
  }

  void createButtons(double buttonSize) {
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 7 * 3, 5.25 * buttonSize),
      ButtonType.iconNo,
      () => {navigate(GameManagerState.mainMenu)},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 5.25 * buttonSize),
      ButtonType.iconReload,
      () => {generateTours()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 7 * 4, 5.25 * buttonSize),
      ButtonType.iconPlay,
      () => {selectedTour != null ? navigate(GameManagerState.playing, tourSettings: selectedTour, team: selectedColor) : null},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 7 * 3, 4.3 * buttonSize),
      ButtonType.iconSmallLeft,
      () => {selectedColor = (selectedColor - 1 + 8) % 8},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 7 * 4, 4.3 * buttonSize),
      ButtonType.iconSmallRight,
      () => {selectedColor = (selectedColor + 1) % 8},
    ));
  }

  String mapTypeAsString(MapType mapType) {
    switch (mapType) {
      case MapType.flat:
        return localizations.raceTypeFlat;
      case MapType.cobble:
        return localizations.raceTypeCobbled;
      case MapType.hills:
        return localizations.raceTypeHilled;
      case MapType.heavy:
        return localizations.raceTypeHeavy;
    }
  }

  String mapLengthAsString(MapLength mapLength) {
    switch (mapLength) {
      case MapLength.short:
        return localizations.raceDurationShort;
      case MapLength.medium:
        return localizations.raceDurationMedium;
      case MapLength.long:
        return localizations.raceDurationLong;
      case MapLength.veryLong:
        return localizations.raceDurationVeryLong;
    }
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    for (final button in buttons) {
      button.onTapDown(info.raw.focalPoint);
    }
  }

  @override
  void onScaleStart(ScaleStartInfo details) {}

  @override
  void onTapUp(TapUpInfo details) {
    for (final button in buttons) {
      button.onTapUp(details);
    }

    final double buttonSize = screenSize!.height / 7;
    tours.asMap().forEach((i, element) {
      final Offset start = Offset(screenSize!.width / 6 * 1.1 * (i + 0.77), buttonSize * 1.7);
      if (MapUtils.isInsideRect(details.raw.globalPosition, start, start + Offset(screenSize!.width / 6, buttonSize * 2.2))) {
        selectedTour = element;
      }
    });
  }

  @override
  void onTapDown(TapDownInfo details) {
    for (final button in buttons) {
      button.onTapDown(details.raw.globalPosition);
    }
  }

  @override
  void render(Canvas canvas) {
    final double buttonSize = screenSize!.height / 7;

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 8, buttonSize), size: Vector2(screenSize!.width / 8 * 6, screenSize!.height / 1.4));

    for (final button in buttons) {
      button.render(canvas);
    }

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.81), size: Vector2(screenSize!.width / 3, buttonSize * 0.8));

    final Paint paint = Paint()
      ..color = Team.getColorFromId(selectedColor)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(screenSize!.width / 2, buttonSize * 4.3), buttonSize / 4, paint);

    TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'SaranaiGame'), text: '${(selectedColor + 2) * 10}');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize * 4.15), 0, span);

    tours.asMap().forEach((i, element) {
      final Color? drawColor = element == selectedTour ? Colors.green[600] : Colors.white;
      backgroundTour!.render(canvas, position: Vector2(screenSize!.width / 6 * 1.1 * (i + 0.77), buttonSize * 1.7), size: Vector2(screenSize!.width / 6, buttonSize * 2.2));

      final Offset position = Offset(screenSize!.width / 6 * 1.1 * (i + 1.27), buttonSize * 1.8);

      TextSpan span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: localizations.raceTeams + ' ${element.teams}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 0), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: localizations.raceRiders + ' ${element.ridersPerTeam * element.teams}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 1), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: localizations.races + ' ${element.races}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 2), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: localizations.raceType + ' ${mapTypeAsString(element.mapType)}');
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 3), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: localizations.raceDuration);
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 4), 0, span);
      span = TextSpan(style: TextStyle(color: drawColor, fontSize: 12, fontFamily: 'SaranaiGame'), text: mapLengthAsString(element.mapLength));
      CanvasUtils.drawText(canvas, position + Offset(0, buttonSize / 3 * 5), 0, span);
    });

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.tourTitle);
    final Offset position = Offset(screenSize!.width / 2, buttonSize * 0.95);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    final double buttonSize = screenSize!.height / 7;
    buttons = [];
    createButtons(buttonSize);
    for (final element in buttons) {
      element.setScreenSize(size!);
    }
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
    final Tour tour = Tour(
      json['teams'] as int,
      json['ridersPerTeam'] as int,
      json['races'] as int,
      getMapTypeFromString(json['mapType'] as String),
      getMapLengthFromString(json['mapLength'] as String),
    );
    tour.id = json['id'] as String;
    return tour;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['teams'] = teams;
    data['ridersPerTeam'] = ridersPerTeam;
    data['races'] = races;
    data['mapType'] = mapType.toString();
    data['mapLength'] = mapLength.toString();
    return data;
  }
}
