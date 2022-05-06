import 'package:cycling_escape/screen_game/baseView.dart';
import 'package:cycling_escape/screen_game/gameManager.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class SettingsMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Sprite? backText;

  Settings settings;

  final NavigateType navigate;

  SettingsMenu(this.spriteManager, this.navigate, this.settings, this.localizations);

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
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize - buttonSize * 0.9),
      ButtonType.iconMinus,
      () {
        settings.autofollowThreshold = (settings.autofollowThreshold! - 1 - 2 + 11) % 11 + 2;
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize - buttonSize * 0.9),
      ButtonType.iconPlus,
      () {
        settings.autofollowThreshold = (settings.autofollowThreshold! + 1 - 2 + 11) % 11 + 2;
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize),
      settings.autofollowAsk == true ? ButtonType.switchButtonOn : ButtonType.switchButtonOff,
      (bool? isOn) {
        settings.autofollowAsk = isOn;
        saveSettings();
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1),
      ButtonType.iconMinus,
      () => {decreaseCyclistMovement()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1),
      ButtonType.iconPlus,
      () => {increaseCyclistMovement()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 2),
      ButtonType.iconMinus,
      () => {decreaseCameraMovement()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 2),
      ButtonType.iconPlus,
      () => {increaseCameraMovement()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.iconMinus,
      () => {decreaseDifficulty()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.iconPlus,
      () => {increaseDifficulty()},
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 3.3, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.iconYes,
      () => {navigate(GameManagerState.mainMenu)},
    ));
  }

  void increaseCyclistMovement() {
    switch (settings.cyclistMovement) {
      case CyclistMovementType.fast:
        settings.cyclistMovement = CyclistMovementType.skip;
        break;
      case CyclistMovementType.normal:
        settings.cyclistMovement = CyclistMovementType.fast;
        break;
      case CyclistMovementType.slow:
        settings.cyclistMovement = CyclistMovementType.normal;
        break;
      case CyclistMovementType.skip:
        settings.cyclistMovement = CyclistMovementType.slow;
        break;
      case null:
        throw Exception("settings.cyclistMovement shouldn't be null");
    }
    saveSettings();
  }

  void decreaseCyclistMovement() {
    switch (settings.cyclistMovement) {
      case CyclistMovementType.fast:
        settings.cyclistMovement = CyclistMovementType.normal;
        break;
      case CyclistMovementType.normal:
        settings.cyclistMovement = CyclistMovementType.slow;
        break;
      case CyclistMovementType.slow:
        settings.cyclistMovement = CyclistMovementType.skip;
        break;
      case CyclistMovementType.skip:
        settings.cyclistMovement = CyclistMovementType.fast;
        break;
      case null:
        throw Exception("settings.cyclistMovement shouldn't be null");
    }
    saveSettings();
  }

  void increaseCameraMovement() {
    switch (settings.cameraMovement) {
      case CameraMovementType.auto:
        settings.cameraMovement = CameraMovementType.none;
        break;
      case CameraMovementType.none:
        settings.cameraMovement = CameraMovementType.selectOnly;
        break;
      case CameraMovementType.selectOnly:
        settings.cameraMovement = CameraMovementType.auto;
        break;
      case null:
        throw Exception("settings.cameraMovement shouldn't be null");
    }
    saveSettings();
  }

  void decreaseCameraMovement() {
    switch (settings.cameraMovement) {
      case CameraMovementType.auto:
        settings.cameraMovement = CameraMovementType.selectOnly;
        break;
      case CameraMovementType.none:
        settings.cameraMovement = CameraMovementType.auto;
        break;
      case CameraMovementType.selectOnly:
        settings.cameraMovement = CameraMovementType.none;
        break;
      case null:
        throw Exception("settings.cameraMovement shouldn't be null");
    }
    saveSettings();
  }

  void increaseDifficulty() {
    switch (settings.difficulty) {
      case DifficultyType.easy:
        settings.difficulty = DifficultyType.normal;
        break;
      case DifficultyType.normal:
        settings.difficulty = DifficultyType.hard;
        break;
      case DifficultyType.hard:
        settings.difficulty = DifficultyType.easy;
        break;
      case null:
        throw Exception("settings.difficulty shouldn't be null");
    }
    saveSettings();
  }

  void decreaseDifficulty() {
    switch (settings.difficulty) {
      case DifficultyType.easy:
        settings.difficulty = DifficultyType.hard;
        break;
      case DifficultyType.normal:
        settings.difficulty = DifficultyType.easy;
        break;
      case DifficultyType.hard:
        settings.difficulty = DifficultyType.normal;
        break;
      case null:
        throw Exception("settings.difficulty shouldn't be null");
    }
    saveSettings();
  }

  String cyclistMovementAsString() {
    switch (settings.cyclistMovement) {
      case CyclistMovementType.fast:
        return localizations.settingsCyclistMoveSpeedFast;
      case CyclistMovementType.normal:
        return localizations.settingsCyclistMoveSpeedNormal;
      case CyclistMovementType.slow:
        return localizations.settingsCyclistMoveSpeedSlow;
      case CyclistMovementType.skip:
        return localizations.settingsCyclistMoveSpeedSkip;
      case null:
        throw Exception("settings.cyclistMovement shouldn't be null");
    }
  }

  String cameraMovementAsString() {
    switch (settings.cameraMovement) {
      case CameraMovementType.auto:
        return localizations.settingsCameraAutoMoveSelectAndFollow;
      case CameraMovementType.selectOnly:
        return localizations.settingsCameraAutoMoveSelectOnly;
      case CameraMovementType.none:
        return localizations.settingsCameraAutoMoveDisabled;
      case null:
        throw Exception("settings.cameraMovement shouldn't be null");
    }
  }

  String difficultyAsString() {
    switch (settings.difficulty) {
      case DifficultyType.easy:
        return localizations.settingsDifficultyEasy;
      case DifficultyType.normal:
        return localizations.settingsDifficultyNormal;
      case DifficultyType.hard:
        return localizations.settingsDifficultyHard;
      case null:
        throw Exception("settings.difficulty shouldn't be null");
    }
  }

  void saveSettings() {
    SaveUtil.saveSettings(settings);
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

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 6, buttonSize * 0.4), size: Vector2(screenSize!.width / 3 * 2, screenSize!.height / 1.1));

    for (final button in buttons) {
      button.render(canvas);
    }

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 0.9), size: Vector2(buttonSize * 3.5, buttonSize * 0.7));

    TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: localizations.settingsAutofollowThreshold);
    Offset position = Offset(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 1.1 - buttonSize * 0.4);

    CanvasUtils.drawText(canvas, position, 0, span);
    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: '${settings.autofollowThreshold}');
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 1.1 - buttonSize * 0.05);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: localizations.settingsAutofollowAskBelowThreshold);
    position = Offset(screenSize!.width / 2 - buttonSize * 0.5, 2.7 * buttonSize - buttonSize * 0.15);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1), size: Vector2(buttonSize * 3.5, buttonSize * 0.7));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: localizations.settingsCyclistMoveSpeed);
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 - buttonSize * 0.6);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: cyclistMovementAsString());
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2), size: Vector2(buttonSize * 3.5, buttonSize * 0.7));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: localizations.settingsCameraAutoMove);
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2 - buttonSize * 0.6);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: cameraMovementAsString());
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2 - buttonSize * 0.2);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 3), size: Vector2(buttonSize * 3.5, buttonSize * 0.7));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: localizations.settingsDifficulty);
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 3 - buttonSize * 0.6);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: difficultyAsString());
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 3 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.21), size: Vector2(screenSize!.width / 3, buttonSize * 0.8));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.settingsTitle);
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
      if (element.type == ButtonType.iconYes) {
        element.setScreenSize(size!);
      } else {
        element.setScreenSize(size! * 0.7);
      }
    }
  }

  @override
  void update(double t) {}
}

class Settings {
  int? autofollowThreshold;
  bool? autofollowAsk;
  CyclistMovementType? cyclistMovement;
  CameraMovementType? cameraMovement;
  DifficultyType? difficulty;

  Settings([this.autofollowThreshold, this.autofollowAsk, this.cyclistMovement, this.cameraMovement, this.difficulty]) {
    autofollowThreshold ??= 7;
    autofollowAsk ??= true;
    cyclistMovement ??= CyclistMovementType.normal;
    cameraMovement ??= CameraMovementType.selectOnly;
    difficulty ??= DifficultyType.normal;
  }

  static Settings fromJson(Map<String, dynamic> json) {
    return Settings(
      json['autofollowThreshold'] as int?,
      json['autofollowAsk'] as bool?,
      getCyclistMovementTypeFromString(json['cyclistMovement'] as String?),
      getCameraMovementTypeFromString(json['cameraMovement'] as String?),
      getDifficultyTypeFromString(json['difficulty'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['autofollowThreshold'] = autofollowThreshold;
    data['autofollowAsk'] = autofollowAsk;
    data['cyclistMovement'] = cyclistMovement.toString();
    data['cameraMovement'] = cameraMovement.toString();
    data['difficulty'] = difficulty.toString();
    return data;
  }
}

CyclistMovementType? getCyclistMovementTypeFromString(String? cyclistMovementTypeAsString) {
  for (final CyclistMovementType element in CyclistMovementType.values) {
    if (element.toString() == cyclistMovementTypeAsString) {
      return element;
    }
  }
  return null;
}

CameraMovementType? getCameraMovementTypeFromString(String? cameraMovementTypeAsString) {
  for (final CameraMovementType element in CameraMovementType.values) {
    if (element.toString() == cameraMovementTypeAsString) {
      return element;
    }
  }
  return null;
}

DifficultyType? getDifficultyTypeFromString(String? difficultyTypeAsString) {
  for (final DifficultyType element in DifficultyType.values) {
    if (element.toString() == difficultyTypeAsString) {
      return element;
    }
  }
  return null;
}

enum CyclistMovementType { fast, normal, slow, skip }

enum CameraMovementType { auto, selectOnly, none }

enum DifficultyType { easy, normal, hard }
