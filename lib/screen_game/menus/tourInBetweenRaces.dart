import 'package:cycling_escape/screen_game/baseView.dart';
import 'package:cycling_escape/screen_game/gameManager.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/activeTour.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class TourInBetweenRacesMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Sprite? backText;
  ActiveTour? activeTour;

  final NavigateType navigate;

  TourInBetweenRacesMenu(this.spriteManager, this.navigate, this.localizations);

  @override
  void onAttach({ActiveTour? activeTour}) {
    if (activeTour != null) this.activeTour = activeTour;
    screenSize ??= const Size(1, 1);
    const double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('back_results.png');
    backgroundHeader = spriteManager.getSprite('back_text_02.png');
    backText = spriteManager.getSprite('yellow_button_01.png');
  }

  void createButtons(double buttonSize) {
    buttons = [];
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 13 * 5, 4.7 * buttonSize),
      ButtonType.iconResults,
      () => {navigate(GameManagerState.results)},
    ));
    if (activeTour != null && activeTour!.racesDone < activeTour!.tour!.races) {
      buttons.add(Button(
        spriteManager,
        Offset(screenSize!.width / 13 * 7, 4.7 * buttonSize),
        ButtonType.iconNo,
        () => {navigate(GameManagerState.mainMenu)},
      ));
      buttons.add(Button(
        spriteManager,
        Offset(screenSize!.width / 13 * 6, 4.7 * buttonSize),
        ButtonType.iconTrash,
        () => {navigate(GameManagerState.mainMenu, deleteActiveTour: true)},
      ));
      buttons.add(Button(
        spriteManager,
        Offset(screenSize!.width / 13 * 8, 4.7 * buttonSize),
        ButtonType.iconPlay,
        () => {navigate(GameManagerState.playing)},
      ));
    } else {
      buttons.add(Button(
        spriteManager,
        Offset(screenSize!.width / 13 * 8, 4.7 * buttonSize),
        ButtonType.iconYes,
        () => {navigate(GameManagerState.mainMenu)},
      ));
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

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 3.5, buttonSize * 1.5), size: Vector2(screenSize!.width * 1.5 / 3.5, buttonSize * 4));

    for (final button in buttons) {
      button.render(canvas);
    }

    TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.nextRaceRacesDone);
    Offset position = Offset(screenSize!.width / 2, 2.4 * buttonSize);
    CanvasUtils.drawText(canvas, position, 0, span);

    if (activeTour != null) {
      span = TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
          text: '${activeTour!.racesDone} ${localizations.nextRaceOf} ${activeTour!.tour!.races}');
      position = Offset(screenSize!.width / 2, 2.8 * buttonSize);
      CanvasUtils.drawText(canvas, position, 0, span);

      int? bestRider = activeTour!.currentResults!.data.length;
      int? bestPlace = activeTour!.currentResults!.data.length;
      for (final element in activeTour!.currentResults!.data) {
        if (element!.team!.isPlayer! && bestPlace! > element.rank) {
          bestPlace = element.rank;
          bestRider = element.number;
        }
      }
      span = TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.nextRaceBestRider + ' $bestRider ${th(bestPlace! + 1)}');
      position = Offset(screenSize!.width / 2, 3.4 * buttonSize);
      CanvasUtils.drawText(canvas, position, 0, span);
    }
    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 2.7, buttonSize * 1.3), size: Vector2(screenSize!.width / 4, buttonSize * 0.8));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.nextRaceTitle);
    position = Offset(screenSize!.width / 2, buttonSize * 1.45);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  String th(int number) {
    if (number == 1) {
      return '1st';
    } else if (number == 2) {
      return '2nd';
    } else if (number == 3) {
      return '3rd';
    } else {
      return '${number}th';
    }
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
