import 'package:cycling_escape/screen_game/base_view.dart';
import 'package:cycling_escape/screen_game/game_manager.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class MainMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Localization localizations;

  final NavigateType navigate;

  MainMenu(this.spriteManager, this.navigate, this.localizations);

  @override
  void onAttach() async {
    buttons = [];
    screenSize ??= const Size(1, 1);

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');

    await createButtons();
  }

  Future<void> createButtons() async {
    screenSize ??= const Size(1, 1);
    final bool canContinue = await SaveUtil.hasCyclingView();
    final double buttonSize = screenSize!.height / 7;
    buttons = [];
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize - buttonSize * 0.5),
      ButtonType.barYellow,
      () => {navigate(GameManagerState.careerMenu)},
      text: localizations.careerButton,
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize + buttonSize * 0.6),
      ButtonType.barBlue,
      () => {navigate(GameManagerState.courseSelectMenu)},
      text: localizations.singleRaceButton,
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize + buttonSize * 1.7),
      ButtonType.barRed,
      () => {navigate(GameManagerState.tourSelectMenu)},
      text: localizations.tourButton,
    ));
    buttons.add(Button(spriteManager, Offset(buttonSize / 2 + 5, screenSize!.height - buttonSize / 2 - 5), ButtonType.iconCredits, () => {navigate(GameManagerState.credits)}));
    buttons
        .add(Button(spriteManager, Offset(screenSize!.width - buttonSize / 2 - 5, buttonSize / 2 + 5), ButtonType.iconSettings, () => {navigate(GameManagerState.settingsMenu)}));
    buttons.add(Button(
        spriteManager, Offset(screenSize!.width - buttonSize / 2 - 5, screenSize!.height - buttonSize / 2 - 5), ButtonType.iconHelp, () => {navigate(GameManagerState.helpMenu)}));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize - buttonSize * 1.6),
      (canContinue == true ? ButtonType.barGreen : ButtonType.barBlack),
      () => {navigate(GameManagerState.playing, load: true)},
      text: localizations.continueButton,
    ));
    for (final element in buttons) {
      element.setScreenSize(screenSize!);
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

    buttonBackground?.render(canvas,
        position: Vector2(screenSize!.width / 3.3, buttonSize * 1.05), size: Vector2(screenSize!.width * 1.3 / 3.3, screenSize!.height - buttonSize * 1.5));

    for (final button in buttons) {
      button.render(canvas);
    }

    backgroundHeader?.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.8), size: Vector2(screenSize!.width / 3, buttonSize));

    const TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Cycling Escape');
    final Offset position = Offset(screenSize!.width / 2, buttonSize * 1.05);
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
