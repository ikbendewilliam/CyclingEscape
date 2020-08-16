import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class TourInBetweenRacesMenu implements BaseView {
  @override
  Size screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite buttonBackground;
  Sprite backgroundHeader;
  Sprite backText;
  ActiveTour activeTour;

  final Function navigate;

  TourInBetweenRacesMenu(this.spriteManager, this.navigate);

  void onAttach({ActiveTour activeTour}) {
    if (activeTour != null) {
      this.activeTour = activeTour;
    }
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('back_results.png');
    backgroundHeader = spriteManager.getSprite('back_text_02.png');
    backText = spriteManager.getSprite('yellow_button_01.png');
  }

  createButtons(double buttonSize) {
    buttons = [];
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 13 * 5, 4.7 * buttonSize),
      ButtonType.ICON_RESULTS,
      () => {navigate(GameManagerState.RESULTS)},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 13 * 6, 4.7 * buttonSize),
      ButtonType.ICON_TRASH,
      () => {navigate(GameManagerState.MAIN_MENU, deleteActiveTour: true)},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize.width / 13 * 7, 4.7 * buttonSize),
      ButtonType.ICON_NO,
      () => {navigate(GameManagerState.MAIN_MENU)},
    ));
    if (activeTour.racesDone < activeTour.tour.races) {
      buttons.add(Button(
        this.spriteManager,
        Offset(screenSize.width / 13 * 8, 4.7 * buttonSize),
        ButtonType.ICON_PLAY,
        () => {navigate(GameManagerState.PLAYING)},
      ));
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
        canvas, Position(screenSize.width / 3.5, buttonSize * 1.5),
        size: Position(screenSize.width * 1.5 / 3.5, buttonSize * 4));

    buttons.forEach((button) {
      button.render(canvas);
    });

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'Races done:');
    Offset position = Offset(screenSize.width / 2, 2.4 * buttonSize);
    CanvasUtils.drawText(canvas, position, 0, span);

    if (activeTour != null) {
      span = new TextSpan(
          style: new TextStyle(
              color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
          text: '${activeTour.racesDone} out of ${activeTour.tour.races}');
      position = Offset(screenSize.width / 2, 2.8 * buttonSize);
      CanvasUtils.drawText(canvas, position, 0, span);

      int bestRider = activeTour.currentResults.data.length;
      int bestPlace = activeTour.currentResults.data.length;
      activeTour.currentResults.data.forEach((element) {
        if (element.team.isPlayer && bestPlace > element.rank) {
          bestPlace = element.rank;
          bestRider = element.number;
        }
      });
      span = new TextSpan(
          style: new TextStyle(
              color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
          text: 'Best rider: $bestRider ${th(bestPlace + 1)}');
      position = Offset(screenSize.width / 2, 3.4 * buttonSize);
      CanvasUtils.drawText(canvas, position, 0, span);
    }
    backgroundHeader.renderPosition(
        canvas, Position(screenSize.width / 2.7, buttonSize * 1.3),
        size: Position(screenSize.width / 4, buttonSize * 0.8));

    span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'),
        text: 'Next race');
    position = Offset(screenSize.width / 2, buttonSize * 1.45);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  th(int number) {
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
