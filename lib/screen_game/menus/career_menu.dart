import 'package:cycling_escape/screen_game/base_view.dart';
import 'package:cycling_escape/screen_game/game_manager.dart';
import 'package:cycling_escape/screen_game/menus/tour_select.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/map/map_utils.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class CareerMenu implements BaseView {
  @override
  Size? screenSize;
  @override
  final SpriteManager spriteManager;
  final Localization localizations;

  List<Button> buttons = [];
  List<RaceType> raceTypes = [];
  Sprite? buttonBackground;
  Sprite? backgroundHeader;
  Sprite? backText;
  Sprite? backTextDisabled;
  int index = 0;
  Career career;

  final NavigateType navigate;

  CareerMenu(this.spriteManager, this.navigate, this.career, this.localizations) {
    raceTypes.add(RaceType(localizations.careerLocalRace, 50, Tour(8, 1, 1, MapType.flat, MapLength.short)));
    raceTypes.add(RaceType(localizations.careerNationalRace, 300, Tour(6, 2, 1, MapType.cobble, MapLength.medium)));
    raceTypes.add(RaceType(localizations.careerContinentalRace, 2000, Tour(5, 3, 1, MapType.hills, MapLength.long)));
    raceTypes.add(RaceType(localizations.careerNationalTour, 6000, Tour(4, 3, 1, MapType.flat, MapLength.short)));
    raceTypes.add(RaceType(localizations.careerContinentalTour, 30 * 1000, Tour(5, 4, 1, MapType.hills, MapLength.medium)));
    raceTypes.add(RaceType(localizations.careerInternationalRace, 84 * 1000, Tour(7, 5, 1, MapType.heavy, MapLength.veryLong)));
    raceTypes.add(RaceType(localizations.careerInternationalTour, 350 * 1000, Tour(6, 5, 8, MapType.heavy, MapLength.long)));
    raceTypes.add(RaceType(localizations.careerWorldTour, 5 * 1000 * 1000, Tour(8, 6, 20, MapType.heavy, MapLength.veryLong)));
  }

  @override
  void onAttach() async {
    buttons = [];
    screenSize ??= const Size(1, 1);

    createButtons();

    backText = spriteManager.getSprite('yellow_button_01.png');
    backTextDisabled = spriteManager.getSprite('black_button_01.png');
    buttonBackground = spriteManager.getSprite('back_tour.png');
    backgroundHeader = spriteManager.getSprite('back_text_01.png');
  }

  void createButtons() async {
    final double buttonSize = screenSize!.height / 7;
    buttons = [];
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 3.25, 3 * buttonSize),
      ButtonType.iconHelp,
      () {
        String text = '';
        text += raceTypes[index].name! + '\n';
        text += localizations.careerWinnerEarnings + '\$' + earningsToString(raceTypes[index].earnings!) + '\n';
        text += localizations.raceTeams + ' ' + raceTypes[index].tour.teams.toString() + '\n';
        text += localizations.careerRaceRiders + ' ' + raceTypes[index].tour.ridersPerTeam.toString() + '\n';
        text += localizations.races + ' ' + raceTypes[index].tour.races.toString() + '\n';
        text += localizations.careerRaceDuration + ' ' + mapLengthAsString(raceTypes[index].tour.mapLength, localizations) + '\n';
        text += localizations.careerRaceType + ' ' + mapTypeAsString(raceTypes[index].tour.mapType, localizations);
        navigate(GameManagerState.info, infoText: text);
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 - buttonSize * 2.25, 3 * buttonSize),
      ButtonType.iconMinus,
      () {
        index = (index - 1 < 0) ? raceTypes.length - 1 : index - 1;
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 2.25, 3 * buttonSize),
      ButtonType.iconPlus,
      () {
        index = index + 1 >= raceTypes.length ? 0 : index + 1;
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2 + buttonSize * 3.25, 3 * buttonSize),
      ButtonType.iconPlay,
      () {
        if (index < career.raceTypes) {
          navigate(GameManagerState.playing, careerRaceType: raceTypes[index]);
        }
      },
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 4.4 * buttonSize),
      ButtonType.barGreen,
      () => {navigate(GameManagerState.careerUpgradesMenu)},
      text: localizations.upgradesButton,
    ));
    buttons.add(Button(
      spriteManager,
      Offset(screenSize!.width / 2, 5.5 * buttonSize),
      ButtonType.barRed,
      () => {navigate(GameManagerState.mainMenu)},
      text: localizations.mainMenuButton,
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
  void onScaleStart(ScaleStartInfo info) {}

  @override
  void onTapUp(TapUpInfo info) {
    for (final button in buttons) {
      button.onTapUp(info);
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

    TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.careerButton);
    Offset position = Offset(screenSize!.width / 2, buttonSize * 1.05);

    CanvasUtils.drawText(canvas, position, 0, span);

    span =
        TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'SaranaiGame'), text: localizations.careerMoney + ' \$' + earningsToString(career.cash));
    position = Offset(screenSize!.width / 2, 2 * buttonSize);

    CanvasUtils.drawText(canvas, position, 0, span);

    final Sprite sprite = index < career.raceTypes ? backText! : backTextDisabled!;
    sprite.renderCentered(canvas, position: Vector2(screenSize!.width / 2, 3 * buttonSize), size: Vector2(buttonSize * 3.5, buttonSize));

    span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: raceTypes[index].name);
    position = Offset(screenSize!.width / 2, 3 * buttonSize - buttonSize * 0.25);
    CanvasUtils.drawText(canvas, position, 0, span);

    span = TextSpan(
        style: const TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'),
        text: index < career.raceTypes ? (localizations.careerWinnerEarnings + ' \$' + earningsToString(raceTypes[index].earnings!)) : localizations.careerBlocked);
    position = Offset(screenSize!.width / 2, 3 * buttonSize + buttonSize * 0.5);

    CanvasUtils.drawText(canvas, position, 0, span);
  }

  String earningsToString(int earnings) {
    if (earnings > 1000 * 1000) {
      return (earnings / 1000 / 1000).toStringAsFixed(2) + 'M';
    }
    if (earnings > 1000) {
      return (earnings / 1000).toStringAsFixed(2) + 'k';
    }
    return earnings.toString();
  }

  @override
  void resize(Size? size) {
    screenSize = size;
    createButtons();
  }

  @override
  void update(double t) {}
}

class RaceType {
  final String? name;
  final int? earnings;
  final Tour tour;

  RaceType(this.name, this.earnings, this.tour);

  static RaceType? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return RaceType(json['name'] as String?, json['earnings'] as int?, Tour.fromJson(json['tour'] as Map<String, dynamic>));
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['earnings'] = earnings;
    data['tour'] = tour.toJson();
    return data;
  }
}

class Career {
  int riders;
  int rankingTypes;
  int raceTypes;
  int cash;

  Career([
    this.riders = 1,
    this.rankingTypes = 1,
    this.raceTypes = 1,
    this.cash = 0,
  ]);

  static Career? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Career(
      json['riders'] as int,
      json['rankingTypes'] as int,
      json['raceTypes'] as int,
      json['cash'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['riders'] = riders;
    data['rankingTypes'] = rankingTypes;
    data['raceTypes'] = raceTypes;
    data['cash'] = cash;
    return data;
  }
}
