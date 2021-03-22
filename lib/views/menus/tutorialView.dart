import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/ui/button.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/saveUtil.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

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

  TutorialView(this.spriteManager, this.navigate);

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

    buttonBackground!
        .render(canvas, anchor: Anchor.center, position: Vector2(screenSize!.width / 4, buttonSize), size: Vector2(screenSize!.width / 2, screenSize!.height - buttonSize * 1.75));

    buttons.forEach((button) {
      button.render(canvas);
    });

    backgroundHeader!.render(canvas, anchor: Anchor.center, position: Vector2(screenSize!.width / 3, buttonSize * 0.75), size: Vector2(screenSize!.width / 3, buttonSize));

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
        text.add('Welcome');
        text.add('');
        text.addAll(splitLongText(
            'Welcome to cycling escape, I hope you enjoy your stay. There are a few items that may be confusing, but I\'ll explain them when we encounter them. If you ever need more help, you can go to the help page (i right bottom). (Games are automatically saved). For now let\'s begin!'));
        break;
      case TutorialType.CAREER:
        text.add('Career');
        text.add('');
        text.addAll(splitLongText('TBD'));
        break;
      case TutorialType.SINGLE_RACE:
        text.add('Single race');
        text.add('');
        text.addAll(splitLongText(
            'This is a single race, the first to finish is the winner. You can pick how many teams compete, how many riders and the type of road. If you like a challenge go for a hilled or even heavy race.'));
        break;
      case TutorialType.TOUR:
        text.add('Tour');
        text.add('');
        text.addAll(splitLongText(
            'A tour constists of multiple races. You can pick one configuration or regenerate to pick a different one. All races use the same configuration, but will be different due to them being randomly generated each time.'));
        break;
      case TutorialType.OPEN_RACE:
        text.add('Race time');
        text.add('');
        text.addAll(splitLongText(
            'Welcome to the race. The goal is to win sprints and be the first and furthest over the finish line. Know that riders on the right hand side have priority. The rider that is furthest will go first and then every other one will get their turn. Then we select the new first rider and so on.'));
        break;
      case TutorialType.THROW_DICE:
        text.add('Your turn');
        text.add('');
        text.addAll(splitLongText('Your turn! Throw the dices by tapping on the screen. You will be able to move the value you throw.'));
        break;
      case TutorialType.SELECT_POSITION:
        text.add('Select a position');
        text.add('');
        text.addAll(splitLongText(
            'Well thrown! You can now move this many spaces. Don\'t worry, we already did the calculation for you. Simply select any highlited position and you will move there. Try to go as far as possible.'));
        break;
      case TutorialType.FOLLOW:
        text.add('Follow.. or not');
        text.add('');
        text.addAll(splitLongText(
            'You have the option to follow. This means that you will move the same number of spaces as the rider in front of you. I suggest only following when you need to throw a 7 or more. You can also use the auto follow command. The game will then decide for you based on your settings. For now this means that it will follow whenever you need to throw a 7 or more.'));
        break;
      case TutorialType.NO_FOLLOW_AVAILABLE:
        text.add('Can\'t follow');
        text.add('');
        text.addAll(splitLongText(
            'You would normally be able to follow, however this is not possible this time. This can be because of a number of reasons, either there is no free tile behind their new tile or they took a route that makes it impossible to reach the tile behind them in the same number of steps. You will have to throw for this rider when it\'s their turn.'));
        break;
      case TutorialType.FOLLOW_AFTER_AUTO_FOLLOW:
        text.add('Maybe still follow');
        text.add('');
        text.addAll(splitLongText(
            'When you select auto follow you will still receive a popup whenever the amount needed to follow is less than 7. This is because it you might still want to follow. If you don\'t want this you can disable this in settings.'));
        break;
      case TutorialType.FIELDVALUE:
        text.add('Difficult terrain');
        text.add('');
        text.addAll(splitLongText(
            'This position is more difficult. Whenever you start on a tile that has a negative value on it, that value will be subtracted from the number you throw. This means that some moves you will be unable to move. Know that this is only when you stop, you can go over them without any problems.'));
        break;
      case TutorialType.FIELDVALUE_POSITIVE:
        text.add('Downhill!');
        text.add('');
        text.addAll(splitLongText(
            'Downhill gives you extra speed! Whenever you start on a tile that has a positive value on it, that value will be added from the number you throw. This means that you can go much further! Enjoy the ride.'));
        break;
      case TutorialType.SPRINT:
        text.add('Sprint!');
        text.add('');
        text.addAll(splitLongText(
            'You just passed a sprint. Depending on the colour it is a normal sprint (green) or a mountain sprint (red). After each turn we check if any riders have passed the sprint and the person that is furthest (or more on the right if they are as far) might get points. The first gets 5 points, the second to fourth get 3, 2 and 1 respectivly.'));
        break;
      case TutorialType.FINISH:
        text.add('Finish!');
        text.add('');
        text.addAll(splitLongText(
            'Congratulations, you\'ve just finished. We use how many turns that took to determine your "time" and rank. After each turn we check if any riders have passed the finish and the person that is furthest (or more on the right if they are as far) finishes first. The riders that finish will be removed from the board. When all riders have finished, we show the rankings.'));
        break;
      case TutorialType.RANKINGS:
        text.add('Rankings');
        text.add('');
        text.addAll(splitLongText(
            'How did you do? You can now see all rankings (use the arrows to change the ranking showed). In a tour, the first in every ranking (except team) get a special jersey they wear in the next race. This way you can always see where the best riders are.'));
        break;
      case TutorialType.SETTINGS:
        text.add('Settings');
        text.add('');
        text.addAll(splitLongText(
            'Change the settings to make your experience more enjoyable. If you want more information on what does what, you can go to help (main menu > i in the corner).'));
        break;
      case TutorialType.TOUR_FIRST_FINISHED:
        text.add('On to the next one');
        text.add('');
        text.addAll(splitLongText(
            'Well done, you\'ve just finished your first tour. Hopefully you did well. If you enjoyed it (or didn\'t), consider rating the game and please continue with more races, tours and the career!'));
        break;
      case TutorialType.CAREER_FIRST_FINISHED:
        text.add('Money!');
        text.add('');
        text.addAll(splitLongText('Well done, you\'ve just earned your first money, you can spend this in upgrades to improve your team.'));
        break;
      case TutorialType.CAREER_UPGRADES:
        text.add('Upgrades');
        text.add('');
        text.addAll(splitLongText('You can upgrade your team by hiring more riders, unlocking more rankings (sprints, team, mountain and young) or unlock better races'));
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

TutorialType? getTutorialTypeFromString(String tutorialTypeAsString) {
  for (TutorialType element in TutorialType.values) {
    if (element.toString() == tutorialTypeAsString) {
      return element;
    }
  }
  return null;
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
