import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:cycling_escape/components/ui/button.dart';
import 'package:cycling_escape/utils/canvasUtils.dart';
import 'package:cycling_escape/utils/saveUtil.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:ui';

import '../baseView.dart';
import '../gameManager.dart';

class MainMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  AppLocalizations appLocalizations;

  final Function navigate;

  MainMenu(this.spriteManager, this.navigate, this.appLocalizations);

  void onAttach() async {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }

    createButtons();

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  createButtons() async {
    bool canContinue = await SaveUtil.hasCyclingView();
    double buttonSize = screenSize!.height / 7;
    buttons = [];
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize - buttonSize * 0.5),
      ButtonType.BAR_YELLOW,
      () => {navigate(GameManagerState.CAREER_MENU)},
      text: appLocalizations.careerButton,
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize + buttonSize * 0.6),
      ButtonType.BAR_BLUE,
      () => {navigate(GameManagerState.COURSE_SELECT_MENU)},
      text: appLocalizations.singleRaceButton,
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize + buttonSize * 1.7),
      ButtonType.BAR_RED,
      () => {navigate(GameManagerState.TOUR_SELECT_MENU)},
      text: appLocalizations.tourButton,
    ));
    buttons
        .add(Button(this.spriteManager, Offset(buttonSize / 2 + 5, screenSize!.height - buttonSize / 2 - 5), ButtonType.ICON_CREDITS, () => {navigate(GameManagerState.CREDITS)}));
    buttons.add(
        Button(this.spriteManager, Offset(screenSize!.width - buttonSize / 2 - 5, buttonSize / 2 + 5), ButtonType.ICON_SETTINGS, () => {navigate(GameManagerState.SETTINGS_MENU)}));
    buttons.add(Button(this.spriteManager, Offset(screenSize!.width - buttonSize / 2 - 5, screenSize!.height - buttonSize / 2 - 5), ButtonType.ICON_HELP,
        () => {navigate(GameManagerState.HELP_MENU)}));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize - buttonSize * 1.6),
      (canContinue == true ? ButtonType.BAR_GREEN : ButtonType.BAR_BLACK),
      () => {navigate(GameManagerState.PLAYING, load: true)},
      text: appLocalizations.continueButton,
    ));
    buttons.forEach((element) {
      element.setScreenSize(screenSize!);
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
    double buttonSize = screenSize!.height / 7;

    buttonBackground?.render(canvas,
        position: Vector2(screenSize!.width / 3.3, buttonSize * 1.05), size: Vector2(screenSize!.width * 1.3 / 3.3, screenSize!.height - buttonSize * 1.5));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader?.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.8), size: Vector2(screenSize!.width / 3, buttonSize));

    TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Cycling Escape');
    Offset position = Offset(screenSize!.width / 2, buttonSize * 1.05);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}
