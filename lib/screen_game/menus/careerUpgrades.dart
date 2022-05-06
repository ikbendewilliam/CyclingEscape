import 'package:cycling_escape/screen_game/baseView.dart';
import 'package:cycling_escape/screen_game/gameManager.dart';
import 'package:cycling_escape/screen_game/menus/careerMenu.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class CareerUpgradesMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Sprite? backText;
  Sprite? backTextDisabled;
  Sprite? barGreen;
  Sprite? barBlue;
  Sprite? barRed;
  Sprite? barEmpty;
  int index = 0;
  Career career;

  final NavigateType navigate;

  CareerUpgradesMenu(this.spriteManager, this.navigate, this.career, this.localizations);

  @override
  void onAttach() async {
    buttons = [];
    screenSize ??= const Size(1, 1);
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

  void createButtons() async {
    final buttonSize = screenSize!.height / 7;
    buttons = [];
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 5.5 * buttonSize),
      ButtonType.barRed,
      () => navigate(GameManagerState.careerMenu),
      text: localizations.careerButton,
    ));
    buttons.add(Button(spriteManager, Offset(screenSize!.width * 0.73, 2.9 * buttonSize), ButtonType.barRed, () {
      if (career.riders < 6 && career.cash >= getRiderPrice()) {
        career.cash -= getRiderPrice();
        career.riders++;
        SaveUtil.saveCareer(career);
        createButtons();
      }
    }, text: '\$ ${priceToString(getRiderPrice())}', scale: 0.5));
    buttons.add(Button(spriteManager, Offset(screenSize!.width * 0.73, (2.9 + 0.7) * buttonSize), ButtonType.barGreen, () {
      if (career.rankingTypes < 5 && career.cash >= getRankingPrice()) {
        career.cash -= getRankingPrice();
        career.rankingTypes++;
        SaveUtil.saveCareer(career);
        createButtons();
      }
    }, text: '\$ ${priceToString(getRankingPrice())}', scale: 0.5));
    buttons.add(Button(spriteManager, Offset(screenSize!.width * 0.73, (2.9 + 1.4) * buttonSize), ButtonType.barBlue, () {
      if (career.raceTypes < 8 && career.cash >= getRacePrice()) {
        career.cash -= getRacePrice();
        career.raceTypes++;
        SaveUtil.saveCareer(career);
        createButtons();
      }
    }, text: '\$ ${priceToString(getRacePrice())}', scale: 0.5));
    for (final element in buttons) {
      element.setScreenSize(screenSize!);
    }
  }

  String priceToString(int? earnings) {
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

  int getRiderPrice() {
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
    return 1000 * 1000;
  }

  int getRankingPrice() {
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
    return 1000 * 1000;
  }

  int getRacePrice() {
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
    return 1000 * 1000;
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

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 6, buttonSize * 1.05), size: Vector2(screenSize!.width / 3 * 2, screenSize!.height - buttonSize * 1.5));

    for (final button in buttons) {
      button.render(canvas);
    }

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.8), size: Vector2(screenSize!.width / 3, buttonSize));

    TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.upgradesButton);
    Offset position = Offset(screenSize!.width / 2, buttonSize * 1.05);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.careerMoney + ' ${career.cash} \$');
    position = Offset(screenSize!.width / 2, 2 * buttonSize);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: localizations.upgradesRiders);
    position = Offset(screenSize!.width / 3, buttonSize * 2.7);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: localizations.upgradesRankings);
    position = Offset(screenSize!.width / 3, buttonSize * (2.7 + 0.7));
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: localizations.upgradesRaceTypes);
    position = Offset(screenSize!.width / 3, buttonSize * (2.7 + 1.4));
    CanvasUtils.drawText(canvas, position, 0, span);

    for (int i = 0; i < 8; i++) {
      Sprite? sprite = (i < career.riders) ? barRed : barEmpty;
      if (i < 6) {
        renderBar(canvas, sprite!, i, 0, buttonSize);
      }
      sprite = (i < career.rankingTypes) ? barGreen : barEmpty;
      if (i < 5) {
        renderBar(canvas, sprite!, i, 1, buttonSize);
      }
      sprite = (i < career.raceTypes) ? barBlue : barEmpty;
      renderBar(canvas, sprite!, i, 2, buttonSize);
    }
  }

  void renderBar(Canvas canvas, Sprite sprite, int horizontalOffset, int verticalOffset, double buttonSize) {
    sprite.render(canvas,
        position: Vector2(screenSize!.width / 2.3 + screenSize!.width / 60 * horizontalOffset * 1.5, buttonSize * 2.6 + buttonSize * 0.7 * verticalOffset),
        size: Vector2(screenSize!.width / 60, buttonSize / 2));
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}
