import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/map/map_utils.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/moveable/cyclist.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const borderWidth = 0.05;

class Position {
  final int k;
  final int segment;
  final int? curvature;
  final bool isLast;
  final bool isCurved;
  final bool clockwise;
  final double i;
  final double j;
  final double radius;
  final double iValue;
  final double startAngle;
  Sprint? sprint;
  final PositionType? positionType;
  final PositionListener? listener;

  String id = const Uuid().v4();
  Offset p1;
  Offset p2;
  double fieldValue;
  Cyclist? cyclist;
  List<Position?>? connections = [];
  List<Position?>? route = [];
  PositionState? state = PositionState.normal;
  bool isPlaceHolder;

  Position(
    this.p1,
    this.p2,
    this.listener,
    this.isLast,
    this.segment,
    this.i,
    this.iValue,
    this.j,
    this.k,
    this.clockwise,
    this.startAngle,
    this.radius,
    this.isCurved,
    this.positionType, {
    this.curvature,
    this.fieldValue = 0,
    this.sprint,
    this.isPlaceHolder = false,
  });

  void render(Canvas canvas, double? tileSize, Offset center, double screenRange) {
    if (pow(center.dx - p1.dx, 2) + pow(center.dy - p1.dy, 2) > screenRange) {
      return;
    }
    final Paint paint = Paint()
      ..color = getColor(false)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize! * (1 - borderWidth);
    final Paint darkPaint = Paint()
      ..color = getColor(true)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize * (1 + borderWidth);
    final Paint darkPaintSmall = Paint()
      ..color = getColor(true)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize * borderWidth;

    final double angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);

    if (radius > 0) {
      canvas.save();
      canvas.translate((p1.dx - (1 - cos(startAngle + pi / 2)) * radius) * tileSize, (p1.dy - (1 - sin(startAngle + pi / 2)) * radius) * tileSize);

      double deltaAngle = (angle - startAngle) * 2;

      // Make sure the anlge is in the correct range
      if (deltaAngle > pi * 2) deltaAngle -= pi * 2;
      if (deltaAngle < -pi * 2) deltaAngle += pi * 2;
      if (deltaAngle < -pi) deltaAngle += pi * 2;
      if (deltaAngle > pi) deltaAngle -= pi * 2;

      canvas.drawArc(Rect.fromLTRB(0, 0, 2 * radius * tileSize, 2 * radius * tileSize), startAngle - pi / 2, deltaAngle * 1.01, false, darkPaint);
      canvas.drawArc(Rect.fromLTRB(0, 0, 2 * radius * tileSize, 2 * radius * tileSize), startAngle - pi / 2, deltaAngle, false, paint);

      canvas.restore();
      canvas.drawLine(
          Offset(p1.dx + sin(startAngle) / 2, p1.dy - cos(startAngle) / 2) * tileSize, Offset(p1.dx - sin(startAngle) / 2, p1.dy + cos(startAngle) / 2) * tileSize, darkPaintSmall);
      canvas.drawLine(Offset(p2.dx + sin(angle * 2 - startAngle) / 2, p2.dy - cos(angle * 2 - startAngle) / 2) * tileSize,
          Offset(p2.dx - sin(angle * 2 - startAngle) / 2, p2.dy + cos(angle * 2 - startAngle) / 2) * tileSize, darkPaintSmall);
    } else {
      canvas.drawLine(Offset(p1.dx * tileSize, p1.dy * tileSize), Offset(p2.dx * tileSize, p2.dy * tileSize), darkPaint);
      canvas.drawLine(Offset((p1.dx + cos(angle) * borderWidth / 2) * tileSize, (p1.dy + sin(angle) * borderWidth / 2) * tileSize),
          Offset((p2.dx - cos(angle) * borderWidth / 2) * tileSize, (p2.dy - sin(angle) * borderWidth / 2) * tileSize), paint);
    }

    if (cyclist != null) {
      cyclist!.render(canvas, (p1 + p2) / 2 * tileSize, tileSize / 3, getCyclistAngle());
    }
  }

  double getCyclistAngle() {
    return (atan2(p2.dy - p1.dy, p2.dx - p1.dx) + (k == -1 ? pi : 0) + pi * 5) % (pi * 2) - pi;
  }

  void renderText(Canvas c, double? tileSize, Offset center, double screenRange) {
    if (fieldValue != 0) {
      if (pow(center.dx - p1.dx, 2) + pow(center.dy - p1.dy, 2) > screenRange) {
        return;
      }
      double angle;
      if (radius == 0) {
        angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
      } else {
        angle = startAngle;
        if (k == -1) {
          final double deltaAngle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
          angle = deltaAngle * 2 - startAngle;
        }
        if (clockwise) {
          angle += pi;
        }
      }
      final TextSpan span = TextSpan(style: const TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'Roboto'), text: fieldValue.toInt().toString());

      CanvasUtils.drawText(c, Offset(((k == -1 ? p2 : p1).dx + cos(angle) * 0.6) * tileSize!, ((k == -1 ? p2 : p1).dy + sin(angle) * 0.6) * tileSize), angle + pi / 2, span);
    }
  }

  void update(double t) {}

  Color? getColor(bool darker) {
    MaterialColor color;
    switch (positionType) {
      case PositionType.cobble:
        color = Colors.teal;
        break;
      case PositionType.uphill:
        color = Colors.red;
        break;
      case PositionType.downhill:
        color = Colors.yellow;
        break;
      default:
        color = Colors.amber;
    }

    if (darker) {
      return color[700];
    }
    switch (state) {
      case PositionState.notSelectable:
        return color[50];
      case PositionState.selectable:
      default:
        return color[200];
    }
  }

  void setState(PositionState newState, [double? maxValue, List<Position?>? currentRoute, Cyclist? cyclist]) {
    if (newState == PositionState.selectable) {
      if (this.cyclist != null && cyclist != null && this.cyclist != cyclist) {
        return;
      }
    }
    if (currentRoute != null) {
      currentRoute.add(this);
      if (state == newState && route != null && currentRoute.length >= route!.length) {
        return;
      }
      route = currentRoute;
      // -1 since start is also in list
      if (maxValue != null && currentRoute.length - 1 < maxValue) {
        // priorityPosition is for nicer animation/movement of cyclists
        final Position? priorityPosition = connections!.firstWhereOrNull(((element) => element?.j == j));
        if (priorityPosition != null) {
          priorityPosition.setState(newState, maxValue, currentRoute.toList(), cyclist);
        }

        for (final pos in connections!) {
          pos!.setState(newState, maxValue, currentRoute.toList(), cyclist);
        }
      }
    }
    state = newState;
  }

  double getValue(bool includingTurnUsed) {
    double value = j + iValue * 1000 + segment * 1000 * 1000;
    if (cyclist != null && includingTurnUsed) {
      value -= cyclist!.lastUsedOnTurn! * 1000 * 1000 * 1000;
    }
    return value;
  }

  void addConnection(Position pos) {
    connections!.add(pos);
  }

  void addCyclist(Cyclist? cyclist) {
    this.cyclist = cyclist;
  }

  Cyclist? removeCyclist() {
    final Cyclist? temp = cyclist;
    cyclist = null;
    return temp;
  }

  void clickedEvent(Offset clickedEvent) {
    final double angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    if (MapUtils.isInside(clickedEvent, p1, p2, 1, angle)) {
      if (state != PositionState.notSelectable) {
        listener!.selectPosition(route);
      }
    }
  }

  static Position? fromJson(
    Map<String, dynamic>? json,
    List<Position?> existingPositions,
    List<Sprint?> existingSprints,
    List<Cyclist?> existingCyclists,
    List<Team?> existingTeams,
    SpriteManager? spriteManager,
    PositionListener? listener,
  ) {
    if (json == null) return null;

    if (existingPositions.isNotEmpty) {
      final existingPosition = existingPositions.firstWhereOrNull(((element) => element?.id == json['id']));
      if (existingPosition != null) return existingPosition;
    }
    if (json['id'] != null && json['segment'] == null) {
      final Position placeholder = Position(Offset.zero, Offset.zero, listener, false, 0, 0, 0, 0, 0, false, 0, 0, false, PositionType.flat, isPlaceHolder: true);
      placeholder.id = json['id'] as String;
      return placeholder;
    }
    final Position position = Position(
      SaveUtil.offsetFromJson(json['p1'] as Map<String, dynamic>?)!,
      SaveUtil.offsetFromJson(json['p2'] as Map<String, dynamic>?)!,
      listener,
      json['isLast'] as bool,
      json['segment'] as int,
      json['i'] as double,
      json['iValue'] as double,
      json['j'] as double,
      json['k'] as int,
      json['clockwise'] as bool,
      json['startAngle'] as double,
      json['radius'] as double,
      json['isCurved'] as bool,
      getPositionTypeFromString(json['positionType'] as String?),
      curvature: json['curvature'] as int?,
      fieldValue: json['fieldValue'] as double,
      sprint: Sprint.fromJson(json['sprint'] as Map<String, dynamic>?, existingSprints),
      isPlaceHolder: true,
    );
    position.id = json['id'] as String;
    existingPositions.add(position);

    position.cyclist = Cyclist.fromJson(json['cyclist'] as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager);
    position.connections = (json['connections'] as List<dynamic>?)
        ?.map<Position>((dynamic e) => Position.fromJson(e as Map<String, dynamic>?, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, listener)!)
        .toList();
    position.route = (json['route'] as List<dynamic>?)
        ?.map<Position>((dynamic e) => Position.fromJson(e as Map<String, dynamic>?, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, listener)!)
        .toList();
    position.state = getPositionStateFromString(json['state'] as String?);

    return position;
  }

  Map<String, dynamic> toJson(bool idOnly) {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (!idOnly) {
      data['k'] = k;
      data['segment'] = segment;
      data['curvature'] = curvature;
      data['isLast'] = isLast;
      data['isCurved'] = isCurved;
      data['clockwise'] = clockwise;
      data['i'] = i;
      data['j'] = j;
      data['radius'] = radius;
      data['iValue'] = iValue;
      data['startAngle'] = startAngle;
      data['fieldValue'] = fieldValue;

      data['sprint'] = sprint?.toJson(true);
      data['cyclist'] = cyclist?.toJson(false);

      data['p1'] = SaveUtil.offsetToJson(p1);
      data['p2'] = SaveUtil.offsetToJson(p2);

      data['positionType'] = positionType.toString();
      data['state'] = state.toString();

      data['connections'] = connections?.map((v) => v!.toJson(true)).toList();
      data['route'] = route?.map((v) => v!.toJson(true)).toList();
    }
    return data;
  }
}

abstract class PositionListener {
  void selectPosition(List<Position?>? position);
}

PositionState? getPositionStateFromString(String? positionStateAsString) {
  for (final PositionState element in PositionState.values) {
    if (element.toString() == positionStateAsString) {
      return element;
    }
  }
  return null;
}

PositionType? getPositionTypeFromString(String? positionTypeAsString) {
  for (final PositionType element in PositionType.values) {
    if (element.toString() == positionTypeAsString) {
      return element;
    }
  }
  return null;
}

enum PositionState { normal, selectable, notSelectable }

enum PositionType { flat, uphill, downhill, cobble }
