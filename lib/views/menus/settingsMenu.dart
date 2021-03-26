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

class SettingsMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final AppLocalizations appLocalizations;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Sprite? backText;

  Settings settings;

  final Function navigate;

  SettingsMenu(this.spriteManager, this.navigate, this.settings, this.appLocalizations);

  void onAttach() {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    double dy = 54;
    createButtons(dy);

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
    backText = spriteManager.getSprite('yellow_button_01.png');
  }

  createButtons(double buttonSize) {
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize - buttonSize * 0.9),
      ButtonType.ICON_MINUS,
      () {
        settings.autofollowThreshold = (settings.autofollowThreshold! - 1 - 2 + 11) % 11 + 2;
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize - buttonSize * 0.9),
      ButtonType.ICON_PLUS,
      () {
        settings.autofollowThreshold = (settings.autofollowThreshold! + 1 - 2 + 11) % 11 + 2;
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize),
      settings.autofollowAsk == true ? ButtonType.SWITCH_BUTTON_ON : ButtonType.SWITCH_BUTTON_OFF,
      (isOn) {
        settings.autofollowAsk = isOn;
        saveSettings();
      },
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1),
      ButtonType.ICON_MINUS,
      () => {decreaseCyclistMovement()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1),
      ButtonType.ICON_PLUS,
      () => {increaseCyclistMovement()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 2),
      ButtonType.ICON_MINUS,
      () => {decreaseCameraMovement()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 2),
      ButtonType.ICON_PLUS,
      () => {increaseCameraMovement()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.ICON_MINUS,
      () => {decreaseDifficulty()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.ICON_PLUS,
      () => {increaseDifficulty()},
    ));
    buttons.add(Button(
      this.spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 3.3, 2.7 * buttonSize + buttonSize * 1.1 * 3),
      ButtonType.ICON_YES,
      () => {navigate(GameManagerState.MAIN_MENU)},
    ));
  }

  increaseCyclistMovement() {
    switch (settings.cyclistMovement) {
      case CyclistMovementType.FAST:
        settings.cyclistMovement = CyclistMovementType.SKIP;
        break;
      case CyclistMovementType.NORMAL:
        settings.cyclistMovement = CyclistMovementType.FAST;
        break;
      case CyclistMovementType.SLOW:
        settings.cyclistMovement = CyclistMovementType.NORMAL;
        break;
      case CyclistMovementType.SKIP:
        settings.cyclistMovement = CyclistMovementType.SLOW;
        break;
      case null:
        throw Exception("settings.cyclistMovement shouldn't be null");
    }
    saveSettings();
  }

  decreaseCyclistMovement() {
    switch (settings.cyclistMovement) {
      case CyclistMovementType.FAST:
        settings.cyclistMovement = CyclistMovementType.NORMAL;
        break;
      case CyclistMovementType.NORMAL:
        settings.cyclistMovement = CyclistMovementType.SLOW;
        break;
      case CyclistMovementType.SLOW:
        settings.cyclistMovement = CyclistMovementType.SKIP;
        break;
      case CyclistMovementType.SKIP:
        settings.cyclistMovement = CyclistMovementType.FAST;
        break;
      case null:
        throw Exception("settings.cyclistMovement shouldn't be null");
    }
    saveSettings();
  }

  increaseCameraMovement() {
    switch (settings.cameraMovement) {
      case CameraMovementType.AUTO:
        settings.cameraMovement = CameraMovementType.NONE;
        break;
      case CameraMovementType.NONE:
        settings.cameraMovement = CameraMovementType.SELECT_ONLY;
        break;
      case CameraMovementType.SELECT_ONLY:
        settings.cameraMovement = CameraMovementType.AUTO;
        break;
      case null:
        throw Exception("settings.cameraMovement shouldn't be null");
    }
    saveSettings();
  }

  decreaseCameraMovement() {
    switch (settings.cameraMovement) {
      case CameraMovementType.AUTO:
        settings.cameraMovement = CameraMovementType.SELECT_ONLY;
        break;
      case CameraMovementType.NONE:
        settings.cameraMovement = CameraMovementType.AUTO;
        break;
      case CameraMovementType.SELECT_ONLY:
        settings.cameraMovement = CameraMovementType.NONE;
        break;
      case null:
        throw Exception("settings.cameraMovement shouldn't be null");
    }
    saveSettings();
  }

  increaseDifficulty() {
    switch (settings.difficulty) {
      case DifficultyType.EASY:
        settings.difficulty = DifficultyType.NORMAL;
        break;
      case DifficultyType.NORMAL:
        settings.difficulty = DifficultyType.HARD;
        break;
      case DifficultyType.HARD:
        settings.difficulty = DifficultyType.EASY;
        break;
      case null:
        throw Exception("settings.difficulty shouldn't be null");
    }
    saveSettings();
  }

  decreaseDifficulty() {
    switch (settings.difficulty) {
      case DifficultyType.EASY:
        settings.difficulty = DifficultyType.HARD;
        break;
      case DifficultyType.NORMAL:
        settings.difficulty = DifficultyType.EASY;
        break;
      case DifficultyType.HARD:
        settings.difficulty = DifficultyType.NORMAL;
        break;
      case null:
        throw Exception("settings.difficulty shouldn't be null");
    }
    saveSettings();
  }

  cyclistMovementAsString() {
    switch (settings.cyclistMovement) {
      case CyclistMovementType.FAST:
        return appLocalizations.settingsCyclistMoveSpeedFast;
      case CyclistMovementType.NORMAL:
        return appLocalizations.settingsCyclistMoveSpeedNormal;
      case CyclistMovementType.SLOW:
        return appLocalizations.settingsCyclistMoveSpeedSlow;
      case CyclistMovementType.SKIP:
        return appLocalizations.settingsCyclistMoveSpeedSkip;
      case null:
        throw Exception("settings.cyclistMovement shouldn't be null");
    }
  }

  cameraMovementAsString() {
    switch (settings.cameraMovement) {
      case CameraMovementType.AUTO:
        return appLocalizations.settingsCameraAutoMoveSelectAndFollow;
      case CameraMovementType.SELECT_ONLY:
        return appLocalizations.settingsCameraAutoMoveSelectOnly;
      case CameraMovementType.NONE:
        return appLocalizations.settingsCameraAutoMoveDisabled;
      case null:
        throw Exception("settings.cameraMovement shouldn't be null");
    }
  }

  difficultyAsString() {
    switch (settings.difficulty) {
      case DifficultyType.EASY:
        return appLocalizations.settingsDifficultyEasy;
      case DifficultyType.NORMAL:
        return appLocalizations.settingsDifficultyNormal;
      case DifficultyType.HARD:
        return appLocalizations.settingsDifficultyHard;
      case null:
        throw Exception("settings.difficulty shouldn't be null");
    }
  }

  saveSettings() {
    SaveUtil.saveSettings(settings);
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

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 6, buttonSize * 0.4), size: Vector2(screenSize!.width / 3 * 2, screenSize!.height / 1.1));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 0.9), size: Vector2(buttonSize * 3.5, buttonSize * 0.7));

    TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: appLocalizations.settingsAutofollowThreshold);
    Offset position = Offset(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 1.1 - buttonSize * 0.4);

    CanvasUtils.drawText(canvas, position, 0, span);
    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: '${settings.autofollowThreshold}');
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize - buttonSize * 1.1 - buttonSize * 0.05);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: appLocalizations.settingsAutofollowAskBelowThreshold);
    position = Offset(screenSize!.width / 2 - buttonSize * 0.5, 2.7 * buttonSize - buttonSize * 0.15);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1), size: Vector2(buttonSize * 3.5, buttonSize * 0.7));

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: appLocalizations.settingsCyclistMoveSpeed);
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 - buttonSize * 0.6);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: cyclistMovementAsString());
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2), size: Vector2(buttonSize * 3.5, buttonSize * 0.7));

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: appLocalizations.settingsCameraAutoMove);
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2 - buttonSize * 0.6);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: cameraMovementAsString());
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 2 - buttonSize * 0.2);
    CanvasUtils.drawText(canvas, position, 0, span);

    backText!.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 3), size: Vector2(buttonSize * 3.5, buttonSize * 0.7));

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: appLocalizations.settingsDifficulty);
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 3 - buttonSize * 0.6);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: difficultyAsString());
    position = Offset(screenSize!.width / 2, 2.7 * buttonSize + buttonSize * 1.1 * 3 - buttonSize * 0.3);
    CanvasUtils.drawText(canvas, position, 0, span);

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.21), size: Vector2(screenSize!.width / 3, buttonSize * 0.8));

    span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: appLocalizations.settingsTitle);
    position = Offset(screenSize!.width / 2, buttonSize * 0.35);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    double buttonSize = screenSize!.height / 7;
    buttons = [];
    createButtons(buttonSize);
    buttons.forEach((element) {
      if (element.type == ButtonType.ICON_YES) {
        element.setScreenSize(size!);
      } else {
        element.setScreenSize(size! * 0.7);
      }
    });
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
    if (this.autofollowThreshold == null) {
      this.autofollowThreshold = 7;
    }
    if (this.autofollowAsk == null) {
      this.autofollowAsk = true;
    }
    if (this.cyclistMovement == null) {
      this.cyclistMovement = CyclistMovementType.NORMAL;
    }
    if (this.cameraMovement == null) {
      this.cameraMovement = CameraMovementType.SELECT_ONLY;
    }
    if (this.difficulty == null) {
      this.difficulty = DifficultyType.NORMAL;
    }
  }

  static Settings fromJson(Map<String, dynamic> json) {
    return Settings(
      json['autofollowThreshold'],
      json['autofollowAsk'],
      getCyclistMovementTypeFromString(json['cyclistMovement']),
      getCameraMovementTypeFromString(json['cameraMovement']),
      getDifficultyTypeFromString(json['difficulty']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['autofollowThreshold'] = this.autofollowThreshold;
    data['autofollowAsk'] = this.autofollowAsk;
    data['cyclistMovement'] = this.cyclistMovement.toString();
    data['cameraMovement'] = this.cameraMovement.toString();
    data['difficulty'] = this.difficulty.toString();
    return data;
  }
}

CyclistMovementType? getCyclistMovementTypeFromString(String? cyclistMovementTypeAsString) {
  for (CyclistMovementType element in CyclistMovementType.values) {
    if (element.toString() == cyclistMovementTypeAsString) {
      return element;
    }
  }
  return null;
}

CameraMovementType? getCameraMovementTypeFromString(String? cameraMovementTypeAsString) {
  for (CameraMovementType element in CameraMovementType.values) {
    if (element.toString() == cameraMovementTypeAsString) {
      return element;
    }
  }
  return null;
}

DifficultyType? getDifficultyTypeFromString(String? difficultyTypeAsString) {
  for (DifficultyType element in DifficultyType.values) {
    if (element.toString() == difficultyTypeAsString) {
      return element;
    }
  }
  return null;
}

enum CyclistMovementType { FAST, NORMAL, SLOW, SKIP }

enum CameraMovementType { AUTO, SELECT_ONLY, NONE }

enum DifficultyType { EASY, NORMAL, HARD }
