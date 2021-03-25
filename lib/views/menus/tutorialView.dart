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

class TutorialView implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;

  final Function navigate;
  GameManagerState? previousState;
  BaseView? previousView;
  TutorialType? tutorialType;
  late List<String> selectedText;
  AppLocalizations appLocalizations;

  TutorialView(this.spriteManager, this.navigate, this.appLocalizations);

  void onAttach() {
    buttons = [];
    if (screenSize == null) {
      screenSize = Size(1, 1);
    }
    createButtons();

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  createButtons() {
    double buttonSize = screenSize!.height / 7;
    buttons = [];
    buttons.add(Button(this.spriteManager, Offset(screenSize!.width / 3 * 2, 5.5 * buttonSize), ButtonType.ICON_YES, () => {navigate(GameManagerState.CLOSE_TUTORIAL)}));
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
    if (this.previousView != null) {
      this.previousView!.render(canvas);
    }
    Paint overlay = Paint()
      ..color = Color(0x77000000)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTRB(0, 0, screenSize!.width, screenSize!.height), overlay);

    double buttonSize = screenSize!.height / 7;

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 4, buttonSize), size: Vector2(screenSize!.width / 2, screenSize!.height - buttonSize * 1.75));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.75), size: Vector2(screenSize!.width / 3, buttonSize));

    renderText(canvas);

    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Tutorial');
    Offset position = Offset(screenSize!.width / 2, buttonSize);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  renderText(canvas) {
    selectedText.asMap().forEach((i, line) {
      renderLine(canvas, line, i);
    });
  }

  renderLine(canvas, line, yOffset) {
    double buttonSize = screenSize!.height / 7;
    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.white, fontSize: 13.0, fontFamily: 'SaranaiGame'), text: line);
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize / 2 * (yOffset / 2 + 4)), 0, span);
  }

  setText() {
    List<String> text = [];
    switch (tutorialType) {
      case TutorialType.FIRST_OPEN:
        text.add(appLocalizations.tutorialWelcomeTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialWelcomeDescription));
        break;
      case TutorialType.CAREER:
        text.add(appLocalizations.tutorialCareerTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialCareerDescription));
        break;
      case TutorialType.SINGLE_RACE:
        text.add(appLocalizations.tutorialSingleRaceTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialSingleRaceDescription));
        break;
      case TutorialType.TOUR:
        text.add(appLocalizations.tutorialTourTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialTourDescription));
        break;
      case TutorialType.OPEN_RACE:
        text.add(appLocalizations.tutorialOpenRaceTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialOpenRaceDescription));
        break;
      case TutorialType.THROW_DICE:
        text.add(appLocalizations.tutorialThrowDiceTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialThrowDiceDescription));
        break;
      case TutorialType.SELECT_POSITION:
        text.add(appLocalizations.tutorialSelectPositionTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialSelectPositionDescription));
        break;
      case TutorialType.FOLLOW:
        text.add(appLocalizations.tutorialFollowOrNotTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialFollowOrNotDescription));
        break;
      case TutorialType.NO_FOLLOW_AVAILABLE:
        text.add(appLocalizations.tutorialCantFollowTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialCantFollowDescription));
        break;
      case TutorialType.FOLLOW_AFTER_AUTO_FOLLOW:
        text.add(appLocalizations.tutorialStillFollowTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialStillFollowDescription));
        break;
      case TutorialType.FIELDVALUE:
        text.add(appLocalizations.tutorialDifficultTerrainTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialDifficultTerrainDescription));
        break;
      case TutorialType.FIELDVALUE_POSITIVE:
        text.add(appLocalizations.tutorialDownhillTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialDownhillDescription));
        break;
      case TutorialType.SPRINT:
        text.add(appLocalizations.tutorialSprintTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialSprintDescription));
        break;
      case TutorialType.FINISH:
        text.add(appLocalizations.tutorialFinishTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialFinishDescription));
        break;
      case TutorialType.RANKINGS:
        text.add(appLocalizations.tutorialRankingsTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialRankingsDescription));
        break;
      case TutorialType.SETTINGS:
        text.add(appLocalizations.tutorialSettingsTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialSettingsDescription));
        break;
      case TutorialType.TOUR_FIRST_FINISHED:
        text.add(appLocalizations.tutorialFirstTourFinishedTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialFirstTourFinishedDescription));
        break;
      case TutorialType.CAREER_FIRST_FINISHED:
        text.add(appLocalizations.tutorialFirstCareerTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialFirstCareerDescription));
        break;
      case TutorialType.CAREER_UPGRADES:
        text.add(appLocalizations.tutorialUpgradesTitle);
        text.add('');
        text.addAll(splitLongText(appLocalizations.tutorialUpgradesDescription));
        break;
      case null:
        break;
    }
    selectedText = text;
  }

  splitLongText(String text) {
    List<String> splitted = [];
    while (text.length > 0) {
      if (text.length <= 30) {
        splitted.add(text);
        text = '';
      } else {
        int end = text.indexOf(' ', 30);
        if (end == -1) {
          splitted.add(text);
          text = '';
        } else {
          splitted.add(text.substring(0, end));
          text = text.substring(end);
        }
      }
    }
    return splitted;
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    createButtons();
    buttons.forEach((element) {
      element.setScreenSize(size!);
    });
    if (this.previousView != null) {
      this.previousView!.resize(size);
    }
  }

  @override
  void update(double t) {}
}

class TutorialsViewed {
  List<TutorialType> typesViewed;
  int toursFinished;

  TutorialsViewed([this.typesViewed = const [], this.toursFinished = 0]);

  bool hasViewed(TutorialType type) {
    return typesViewed.contains(type);
  }

  void save() {
    SaveUtil.saveTutorialsViewed(this);
  }

  void addViewed(TutorialType type) {
    typesViewed.add(type);
    save();
  }

  static TutorialsViewed? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return TutorialsViewed(
      json['typesViewed']?.map<TutorialType>((e) => getTutorialTypeFromString(e))?.toList(),
      json['toursFinished'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typesViewed'] = this.typesViewed.map<String>((e) => e.toString()).toList();
    data['toursFinished'] = this.toursFinished;
    return data;
  }
}

TutorialType getTutorialTypeFromString(String tutorialTypeAsString) {
  for (TutorialType element in TutorialType.values) {
    if (element.toString() == tutorialTypeAsString) {
      return element;
    }
  }
  throw Exception('String is not getTutorialTypeFromString: $tutorialTypeAsString');
}

enum TutorialType {
  FIRST_OPEN,
  CAREER, // Not implemented!
  CAREER_FIRST_FINISHED, // Not implemented!
  CAREER_UPGRADES, // Not implemented!
  SINGLE_RACE,
  TOUR,
  OPEN_RACE,
  THROW_DICE,
  SELECT_POSITION,
  FOLLOW,
  NO_FOLLOW_AVAILABLE,
  FOLLOW_AFTER_AUTO_FOLLOW,
  FIELDVALUE,
  FIELDVALUE_POSITIVE,
  SPRINT,
  FINISH,
  RANKINGS,
  SETTINGS,
  TOUR_FIRST_FINISHED,
}
