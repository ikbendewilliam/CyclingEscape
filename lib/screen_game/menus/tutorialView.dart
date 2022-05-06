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

class TutorialView implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;

  List<Button> buttons = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;

  final NavigateType navigate;
  GameManagerState? previousState;
  BaseView? previousView;
  TutorialType? tutorialType;
  late List<String> selectedText;
  Localization localizations;

  TutorialView(this.spriteManager, this.navigate, this.localizations);

  @override
  void onAttach() {
    buttons = [];
    screenSize ??= const Size(1, 1);
    createButtons();

    buttonBackground = spriteManager.getSprite('options_back_01.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  void createButtons() {
    final double buttonSize = screenSize!.height / 7;
    buttons = [];
    buttons.add(Button(spriteManager, Offset(screenSize!.width / 3 * 2, 5.5 * buttonSize), ButtonType.iconYes, () => {navigate(GameManagerState.closeTutorial)}));
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
    if (previousView != null) {
      previousView!.render(canvas);
    }
    final Paint overlay = Paint()
      ..color = const Color(0x77000000)
      ..blendMode = BlendMode.darken;
    canvas.drawRect(Rect.fromLTRB(0, 0, screenSize!.width, screenSize!.height), overlay);

    final double buttonSize = screenSize!.height / 7;

    buttonBackground!.render(canvas, position: Vector2(screenSize!.width / 4, buttonSize), size: Vector2(screenSize!.width / 2, screenSize!.height - buttonSize * 1.75));

    for (final button in buttons) {
      button.render(canvas);
    }

    backgroundHeader!.render(canvas, position: Vector2(screenSize!.width / 3, buttonSize * 0.75), size: Vector2(screenSize!.width / 3, buttonSize));

    renderText(canvas);

    const TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: 'Tutorial');
    final Offset position = Offset(screenSize!.width / 2, buttonSize);
    CanvasUtils.drawText(canvas, position, 0, span);
  }

  void renderText(Canvas canvas) {
    selectedText.asMap().forEach((i, line) {
      renderLine(canvas, line, i);
    });
  }

  void renderLine(Canvas canvas, String? line, int yOffset) {
    final double buttonSize = screenSize!.height / 7;
    final TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 13.0, fontFamily: 'SaranaiGame'), text: line);
    CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, buttonSize / 2 * (yOffset / 2 + 4)), 0, span);
  }

  void setText() {
    final List<String> text = [];
    switch (tutorialType) {
      case TutorialType.firstOpen:
        text.add(localizations.tutorialWelcomeTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialWelcomeDescription));
        break;
      case TutorialType.career:
        text.add(localizations.tutorialCareerTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialCareerDescription));
        break;
      case TutorialType.singleRace:
        text.add(localizations.tutorialSingleRaceTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialSingleRaceDescription));
        break;
      case TutorialType.tour:
        text.add(localizations.tutorialTourTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialTourDescription));
        break;
      case TutorialType.openRace:
        text.add(localizations.tutorialOpenRaceTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialOpenRaceDescription));
        break;
      case TutorialType.throwDice:
        text.add(localizations.tutorialThrowDiceTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialThrowDiceDescription));
        break;
      case TutorialType.selectPosition:
        text.add(localizations.tutorialSelectPositionTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialSelectPositionDescription));
        break;
      case TutorialType.follow:
        text.add(localizations.tutorialFollowOrNotTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialFollowOrNotDescription));
        break;
      case TutorialType.noFollowAvailable:
        text.add(localizations.tutorialCantFollowTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialCantFollowDescription));
        break;
      case TutorialType.followAfterAutoFollow:
        text.add(localizations.tutorialStillFollowTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialStillFollowDescription));
        break;
      case TutorialType.fieldValue:
        text.add(localizations.tutorialDifficultTerrainTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialDifficultTerrainDescription));
        break;
      case TutorialType.fieldValuePositive:
        text.add(localizations.tutorialDownhillTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialDownhillDescription));
        break;
      case TutorialType.sprint:
        text.add(localizations.tutorialSprintTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialSprintDescription));
        break;
      case TutorialType.finish:
        text.add(localizations.tutorialFinishTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialFinishDescription));
        break;
      case TutorialType.rankings:
        text.add(localizations.tutorialRankingsTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialRankingsDescription));
        break;
      case TutorialType.settings:
        text.add(localizations.tutorialSettingsTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialSettingsDescription));
        break;
      case TutorialType.tourFirstFinished:
        text.add(localizations.tutorialFirstTourFinishedTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialFirstTourFinishedDescription));
        break;
      case TutorialType.careerFirstFinished:
        text.add(localizations.tutorialFirstCareerTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialFirstCareerDescription));
        break;
      case TutorialType.careerUpgrades:
        text.add(localizations.tutorialUpgradesTitle);
        text.add('');
        text.addAll(splitLongText(localizations.tutorialUpgradesDescription));
        break;
      case null:
        break;
    }
    selectedText = text;
  }

  List<String> splitLongText(String text) {
    final List<String> splitted = [];
    while (text.isNotEmpty) {
      if (text.length <= 30) {
        splitted.add(text);
        text = '';
      } else {
        final int end = text.indexOf(' ', 30);
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
    for (final element in buttons) {
      element.setScreenSize(size!);
    }
    if (previousView != null) {
      previousView!.resize(size);
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
      (json['typesViewed'] as List?)?.map((dynamic e) => getTutorialTypeFromString(e as String)).toList() ?? [],
      json['toursFinished'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['typesViewed'] = typesViewed.map<String>((e) => e.toString()).toList();
    data['toursFinished'] = toursFinished;
    return data;
  }
}

TutorialType getTutorialTypeFromString(String tutorialTypeAsString) {
  for (final TutorialType element in TutorialType.values) {
    if (element.toString() == tutorialTypeAsString) {
      return element;
    }
  }
  throw Exception('String is not getTutorialTypeFromString: $tutorialTypeAsString');
}

enum TutorialType {
  firstOpen,
  career,
  careerFirstFinished,
  careerUpgrades,
  singleRace,
  tour,
  openRace,
  throwDice,
  selectPosition,
  follow,
  noFollowAvailable,
  followAfterAutoFollow,
  fieldValue,
  fieldValuePositive,
  sprint,
  finish,
  rankings,
  settings,
  tourFirstFinished,
}
