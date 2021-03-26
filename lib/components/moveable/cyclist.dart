import 'dart:math';
import 'dart:ui';

import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:cycling_escape/components/data/team.dart';
import 'package:cycling_escape/components/positions/position.dart';
import 'package:cycling_escape/utils/canvasUtils.dart';
import 'package:cycling_escape/utils/saveUtil.dart';
import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
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

  Cyclist(this.team, this.number, this.rank, SpriteManager? spriteManager, {this.isPlaceHolder: false}) {
    if (isPlaceHolder) {
      return;
    }
    cyclistSprite = this.team!.getSprite(this.number % 2 == 0);
    cyclistYellowJerseySprite = spriteManager?.getSprite('cyclists/geel${this.number % 2 == 0 ? '2' : ''}.png');
    cyclistWhiteJerseySprite = spriteManager?.getSprite('cyclists/wit${this.number % 2 == 0 ? '2' : ''}.png');
    cyclistGreenJerseySprite = spriteManager?.getSprite('cyclists/lichtgroen${this.number % 2 == 0 ? '2' : ''}.png');
    cyclistBouledJerseySprite = spriteManager?.getSprite('cyclists/bollekes${this.number % 2 == 0 ? '2' : ''}.png');
  }

  moveTo(double percentage, List<Position?>? route) {
    if (percentage >= 0.99 || route!.length == 1) {
      movingOffset = (route!.last!.p1 + route.last!.p2) / 2;
      movingAngle = route.last!.getCyclistAngle();
    } else {
      double routePercentage = percentage * (route.length - 1);
      int index = (routePercentage).floor();
      double deltaPercentage = routePercentage % 1;
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

      TextSpan span = TextSpan(style: TextStyle(color: textColor, fontSize: 10.0, fontFamily: 'SaranaiGame'), text: number.toString());
      CanvasUtils.drawText(canvas, Offset(0, -size / 3), 0, span);

      canvas.restore();
    }
  }

  static Cyclist? fromJson(Map<String, dynamic>? json, List<Cyclist?> existingCyclists, List<Team?> existingTeams, SpriteManager? spriteManager) {
    if (json == null) {
      return null;
    }
    if (existingCyclists.length > 0) {
      Cyclist? c = existingCyclists.firstWhereOrNull(((element) => element?.id == json['id']));
      if (c != null) {
        return c;
      }
    }
    if (json['id'] != null && json['number'] == null) {
      Cyclist placeholder = Cyclist(null, 0, 0, null, isPlaceHolder: true);
      placeholder.id = json['id'];
      return placeholder;
    }

    Cyclist cyclist = Cyclist(
      Team.fromJson(json['team'], existingCyclists, existingTeams, spriteManager),
      json['number'],
      json['rank'],
      spriteManager,
    );
    cyclist.id = json['id'];
    existingCyclists.add(cyclist);

    cyclist.lastUsedOnTurn = json['lastUsedOnTurn'];
    cyclist.wearsYellowJersey = json['wearsYellowJersey'];
    cyclist.wearsWhiteJersey = json['wearsWhiteJersey'];
    cyclist.wearsGreenJersey = json['wearsGreenJersey'];
    cyclist.wearsBouledJersey = json['wearsBouledJersey'];
    cyclist.movingAngle = json['movingAngle'];
    cyclist.movingOffset = SaveUtil.offsetFromJson(json['movingOffset']);
    cyclist.lastPosition = Position.fromJson(json['lastPosition'], [], [], [], [], spriteManager, null);
    return cyclist;
  }

  Map<String, dynamic> toJson(bool idOnly) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (!idOnly) {
      data['number'] = this.number;
      data['team'] = this.team?.toJson(true);
      data['rank'] = this.rank;
      data['lastUsedOnTurn'] = this.lastUsedOnTurn;
      data['wearsYellowJersey'] = this.wearsYellowJersey;
      data['wearsWhiteJersey'] = this.wearsWhiteJersey;
      data['wearsGreenJersey'] = this.wearsGreenJersey;
      data['wearsBouledJersey'] = this.wearsBouledJersey;
      data['movingAngle'] = this.movingAngle;
      data['movingOffset'] = SaveUtil.offsetToJson(this.movingOffset);
      data['lastPosition'] = this.lastPosition?.toJson(true);
    }
    return data;
  }
}
