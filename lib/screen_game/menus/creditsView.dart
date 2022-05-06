import 'package:cycling_escape/screen_game/baseView.dart';
import 'package:cycling_escape/screen_game/gameManager.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class CreditsView implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;

  final NavigateType navigate;

  CreditsView(this.spriteManager, this.navigate, this.localizations);

  @override
  void onAttach() {
    buttons = [];
    screenSize ??= const Size(1, 1);
    const double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  void createButtons(double buttonSize) {
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 6 * buttonSize),
      ButtonType.iconNo,
      () => {navigate(GameManagerState.mainMenu)},
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

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 10, buttonSize * 0.4), size: Vector2(screenSize!.width / 5 * 4, screenSize!.height / 1.1));

    for (final button in buttons) {
      button.render(canvas);
    }

    double y = buttonSize * 1.1;
    TextSpan span =
        const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: 'This game is made by me (WiVe or simply William Verhaeghe)');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.3 * buttonSize), 0, span);

    span = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: 'This game is made possible thanks ');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.6 * buttonSize), 0, span);
    span = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: ' to the following great people');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.3 * buttonSize), 0, span);

    span = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: 'Bart barto - cyclists and listening to me whining');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.3 * buttonSize), 0, span);

    span = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: 'thedarkbear.itch.io/3-parallax - the background in the menus');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.3 * buttonSize), 0, span);

    span = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: 'kenney.nl - for the icons, foiliage and grass');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.3 * buttonSize), 0, span);

    span = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: 'kidcomic.net - the game icon');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.3 * buttonSize), 0, span);

    span = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: 'Saranai - the game UI');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.3 * buttonSize), 0, span);

    span = const TextSpan(style: TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'), text: 'Megan - for playing Harry Potter with me!');
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, y += 0.3 * buttonSize), 0, span);

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.21), size: Vector2(screenSize!.width / 3, buttonSize * 0.8));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.creditsTitle);
    final Offset position = Offset(screenSize!.width / 2, buttonSize * 0.35);
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
