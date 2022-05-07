import 'package:cycling_escape/screen_game/base_view.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class FollowSelect implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundText;

  final ValueChanged<FollowType> returnValue;
  final int minThrow;

  FollowSelect(this.spriteManager, this.returnValue, this.minThrow, this.localizations);

  @override
  void onAttach() {
    buttons = [];
    screenSize ??= const Size(1, 1);
    const double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundText = spriteManager.getSprite('back_text_04.png');
  }

  void createButtons(double buttonSize) {
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize - buttonSize * 1.1),
      ButtonType.barGreen,
      () => {returnValue(FollowType.follow)},
      text: localizations.followFollow,
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize),
      ButtonType.barYellow,
      () => {returnValue(FollowType.leave)},
      text: localizations.followLeave,
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 4 * buttonSize + buttonSize * 1.1),
      ButtonType.barYellow,
      () => {returnValue(FollowType.autoFollow)},
      text: localizations.followAuto,
    ));
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

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 3, 2 * buttonSize), size: Vector2(screenSize!.width / 3, screenSize!.height - buttonSize * 3));

    for (final button in buttons) {
      button.render(canvas);
    }

    backgroundText!.render(canvas, position: Vector2(screenSize!.width / 2 - buttonSize * 1.75, buttonSize * 1.4), size: Vector2(buttonSize * 3.5, buttonSize * 0.4));

    final TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'SaranaiGame'), text: '${localizations.followAmount} $minThrow');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize * 1.45), 0, span);
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

enum FollowType {
  follow,
  leave,
  autoFollow,
}
