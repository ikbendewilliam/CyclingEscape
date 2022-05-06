import 'package:cycling_escape/screen_game/baseView.dart';
import 'package:cycling_escape/screen_game/gameManager.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/map/map_utils.dart';
import 'package:cycling_escape/widget_game/data/playSettings.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class CourseSelectMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  int teams = 4;
  int ridersPerTeam = 4;
  int selectedColor = 0;
  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Sprite? backText;
  MapType maptype = MapType.flat;
  MapLength mapLength = MapLength.medium;

  final NavigateType navigate;

  CourseSelectMenu(this.spriteManager, this.navigate, this.localizations);

  @override
  void onAttach() {
    buttons = [];
    screenSize ??= const Size(1, 1);
    const double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
    backText = spriteManager.getSprite('yellow_button_01.png');
  }

  void createButtons(double buttonSize) {
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize - buttonSize * 1.1),
      ButtonType.iconMinus,
      () {
        teams--;
        teams = teams <= 0 ? 8 : teams;
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize - buttonSize * 1.1),
      ButtonType.iconPlus,
      () {
        teams++;
        teams = teams > 8 ? 1 : teams;
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize),
      ButtonType.iconMinus,
      () {
        ridersPerTeam--;
        ridersPerTeam = ridersPerTeam <= 0 ? 6 : ridersPerTeam;
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize),
      ButtonType.iconPlus,
      () {
        ridersPerTeam++;
        ridersPerTeam = ridersPerTeam > 6 ? 1 : ridersPerTeam;
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1),
      ButtonType.iconMinus,
      () => {decreaseType()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1),
      ButtonType.iconPlus,
      () => {increaseType()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 2),
      ButtonType.iconMinus,
      () => {decreaseLength()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 2),
      ButtonType.iconPlus,
      () => {increaseLength()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 9 * 3, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.iconNo,
      () => {navigate(GameManagerState.mainMenu)},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 9 * 6, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.iconPlay,
      () => {navigate(GameManagerState.playing, playSettings: PlaySettings(teams, ridersPerTeam, maptype, mapLength), team: selectedColor)},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 7 * 3, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.iconSmallLeft,
      () => {selectedColor = (selectedColor - 1 + 8) % 8},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 7 * 4, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.iconSmallRight,
      () => {selectedColor = (selectedColor + 1) % 8},
    ));
  }

  void increaseType() {
    switch (maptype) {
      case MapType.flat:
        maptype = MapType.cobble;
        break;
      case MapType.cobble:
        maptype = MapType.hills;
        break;
      case MapType.hills:
        maptype = MapType.heavy;
        break;
      case MapType.heavy:
        maptype = MapType.flat;
        break;
    }
  }

  void decreaseType() {
    switch (maptype) {
      case MapType.flat:
        maptype = MapType.heavy;
        break;
      case MapType.cobble:
        maptype = MapType.flat;
        break;
      case MapType.hills:
        maptype = MapType.cobble;
        break;
      case MapType.heavy:
        maptype = MapType.hills;
        break;
    }
  }

  void increaseLength() {
    switch (mapLength) {
      case MapLength.short:
        mapLength = MapLength.medium;
        break;
      case MapLength.medium:
        mapLength = MapLength.long;
        break;
      case MapLength.long:
        mapLength = MapLength.veryLong;
        break;
      case MapLength.veryLong:
        mapLength = MapLength.short;
        break;
    }
  }

  void decreaseLength() {
    switch (mapLength) {
      case MapLength.short:
        mapLength = MapLength.veryLong;
        break;
      case MapLength.medium:
        mapLength = MapLength.short;
        break;
      case MapLength.long:
        mapLength = MapLength.medium;
        break;
      case MapLength.veryLong:
        mapLength = MapLength.long;
        break;
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

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 4, buttonSize * 0.4), size: Vector2(screenSize!.width / 2, screenSize!.height / 1.1));

    for (final button in buttons) {
      button.render(canvas);
    }

    final Paint paint = Paint()
      ..color = Team.getColorFromId(selectedColor)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(screenSize!.width / 2, buttonSize * 6), buttonSize / 4, paint);

    TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'SaranaiGame'), text: '${(selectedColor + 2) * 10}');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize * 5.85), 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 1.1), size: Vector2(buttonSize * 3.5, buttonSize));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.raceTeams + ' $teams');
    Offset position = Offset(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 1.1 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize), size: Vector2(buttonSize * 3.5, buttonSize));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.raceRiders + ' ${ridersPerTeam * teams}');
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1), size: Vector2(buttonSize * 3.5, buttonSize));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: mapTypeAsString(maptype, localizations));
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2), size: Vector2(buttonSize * 3.5, buttonSize));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: mapLengthAsString(mapLength, localizations));
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.21), size: Vector2(screenSize!.width / 3, buttonSize * 0.8));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.singleRaceTitle);
    position = Offset(screenSize!.width / 2, buttonSize * 0.35);
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
