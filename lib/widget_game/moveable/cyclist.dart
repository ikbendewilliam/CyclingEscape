import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/positions/position.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Cyclist {
  final int number;
  Team? team;
  int? rank;
  int? lastUsedOnTurn = 0;
  bool isPlaceHolder = false;
  bool? wearsYellowJersey = false;
  bool? wearsWhiteJersey = false;
  bool? wearsGreenJersey = false;
  bool? wearsBouledJersey = false;
  double? movingAngle;
  Offset? movingOffset;
  Sprite? cyclistSprite;
  Sprite? cyclistYellowJerseySprite;
  Sprite? cyclistWhiteJerseySprite;
  Sprite? cyclistGreenJerseySprite;
  Sprite? cyclistBouledJerseySprite;
  Position? lastPosition;
  String? id = UniqueKey().toString();

  Cyclist(this.team, this.number, this.rank, SpriteManager? spriteManager, {this.isPlaceHolder = false}) {
    if (isPlaceHolder) {
      return;
    }
    cyclistSprite = team!.getSprite(number % 2 == 0);
    cyclistYellowJerseySprite = spriteManager?.getSprite('cyclists/geel${number % 2 == 0 ? '2' : ''}.png');
    cyclistWhiteJerseySprite = spriteManager?.getSprite('cyclists/wit${number % 2 == 0 ? '2' : ''}.png');
    cyclistGreenJerseySprite = spriteManager?.getSprite('cyclists/lichtgroen${number % 2 == 0 ? '2' : ''}.png');
    cyclistBouledJerseySprite = spriteManager?.getSprite('cyclists/bollekes${number % 2 == 0 ? '2' : ''}.png');
  }

  void moveTo(double percentage, List<Position?>? route) {
    if (percentage >= 0.99 || route!.length == 1) {
      movingOffset = (route!.last!.p1 + route.last!.p2) / 2;
      movingAngle = route.last!.getCyclistAngle();
    } else {
      final double routePercentage = percentage * (route.length - 1);
      final int index = (routePercentage).floor();
      final double deltaPercentage = routePercentage % 1;
      movingOffset = (route[index]!.p1 + route[index]!.p2) * (1 - deltaPercentage) + (route[index + 1]!.p1 + route[index + 1]!.p2) * deltaPercentage;
      movingOffset = movingOffset! / 2;
      movingAngle = route[index]!.getCyclistAngle() * (1 - deltaPercentage) + route[index + 1]!.getCyclistAngle() * deltaPercentage;
    }
  }

  void render(Canvas canvas, Offset offset, double size, double? angle) {
    if (cyclistSprite != null) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(pi / 2 + angle!);
      Sprite? sprite = cyclistSprite;
      Color textColor = team!.getTextColor();
      if (wearsYellowJersey!) {
        sprite = cyclistYellowJerseySprite;
        textColor = Colors.black;
      } else if (wearsGreenJersey!) {
        sprite = cyclistGreenJerseySprite;
        textColor = Colors.black;
      } else if (wearsWhiteJersey!) {
        sprite = cyclistWhiteJerseySprite;
        textColor = Colors.black;
      } else if (wearsBouledJersey!) {
        sprite = cyclistBouledJerseySprite;
        textColor = Colors.black;
      }
      sprite!.renderCentered(canvas, position: Vector2.zero(), size: Vector2(size * 3, size * 6));

      final TextSpan span = TextSpan(style: TextStyle(color: textColor, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: number.toString());
      CanvasUtils.drawText(canvas, Offset(0, -size / 3), 0, span);

      canvas.restore();
    }
  }

  static Cyclist? fromJson(Map<String, dynamic>? json, List<Cyclist?> existingCyclists, List<Team?> existingTeams, SpriteManager? spriteManager) {
    if (json == null) {
      return null;
    }
    if (existingCyclists.isNotEmpty) {
      final Cyclist? c = existingCyclists.firstWhereOrNull(((element) => element?.id == json['id']));
      if (c != null) {
        return c;
      }
    }
    if (json['id'] != null && json['number'] == null) {
      final Cyclist placeholder = Cyclist(null, 0, 0, null, isPlaceHolder: true);
      placeholder.id = json['id'] as String;
      return placeholder;
    }

    final Cyclist cyclist = Cyclist(
      Team.fromJson(json['team'] as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager),
      json['number'] as int,
      json['rank'] as int?,
      spriteManager,
    );
    cyclist.id = json['id'] as String?;
    existingCyclists.add(cyclist);

    cyclist.lastUsedOnTurn = json['lastUsedOnTurn'] as int?;
    cyclist.wearsYellowJersey = json['wearsYellowJersey'] as bool?;
    cyclist.wearsWhiteJersey = json['wearsWhiteJersey'] as bool?;
    cyclist.wearsGreenJersey = json['wearsGreenJersey'] as bool?;
    cyclist.wearsBouledJersey = json['wearsBouledJersey'] as bool?;
    cyclist.movingAngle = json['movingAngle'] as double?;
    cyclist.movingOffset = SaveUtil.offsetFromJson(json['movingOffset'] as Map<String, dynamic>?);
    cyclist.lastPosition = Position.fromJson(json['lastPosition'] as Map<String, dynamic>?, [], [], [], [], spriteManager, null);
    return cyclist;
  }

  Map<String, dynamic> toJson(bool idOnly) {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (!idOnly) {
      data['number'] = number;
      data['team'] = team?.toJson(true);
      data['rank'] = rank;
      data['lastUsedOnTurn'] = lastUsedOnTurn;
      data['wearsYellowJersey'] = wearsYellowJersey;
      data['wearsWhiteJersey'] = wearsWhiteJersey;
      data['wearsGreenJersey'] = wearsGreenJersey;
      data['wearsBouledJersey'] = wearsBouledJersey;
      data['movingAngle'] = movingAngle;
      data['movingOffset'] = SaveUtil.offsetToJson(movingOffset);
      data['lastPosition'] = lastPosition?.toJson(true);
    }
    return data;
  }
}
