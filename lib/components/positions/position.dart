import 'dart:math';
import 'dart:ui';

import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:cycling_escape/components/data/team.dart';
import 'package:cycling_escape/components/positions/sprint.dart';
import 'package:cycling_escape/utils/canvasUtils.dart';
import 'package:cycling_escape/utils/mapUtils.dart';
import 'package:cycling_escape/utils/saveUtil.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../moveable/cyclist.dart';

const BORDER_WIDTH = 0.05;

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

  String id = UniqueKey().toString();
  Offset p1;
  Offset p2;
  double fieldValue;
  Cyclist? cyclist;
  List<Position?>? connections = [];
  List<Position?>? route = [];
  PositionState? state = PositionState.NORMAL;
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
    this.isPlaceHolder: false,
  });

  void render(Canvas canvas, double? tileSize, Offset center, double screenRange) {
    if (pow(center.dx - p1.dx, 2) + pow(center.dy - p1.dy, 2) > screenRange) {
      return;
    }
    Paint paint = Paint()
      ..color = getColor(false)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize! * (1 - BORDER_WIDTH);
    Paint darkPaint = Paint()
      ..color = getColor(true)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize * (1 + BORDER_WIDTH);
    Paint darkPaintSmall = Paint()
      ..color = getColor(true)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize * BORDER_WIDTH;

    double angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);

    if (radius > 0) {
      canvas.save();
      canvas.translate((p1.dx - (1 - cos(startAngle + pi / 2)) * radius) * tileSize, (p1.dy - (1 - sin(startAngle + pi / 2)) * radius) * tileSize);

      double deltaAngle = (angle - startAngle) * 2;
      if (deltaAngle > pi * 2) {
        deltaAngle -= pi * 2;
      }
      if (deltaAngle < -pi * 2) {
        deltaAngle += pi * 2;
      }
      if (deltaAngle < -pi) {
        deltaAngle = pi * 2 + deltaAngle;
      }
      if (deltaAngle > pi) {
        deltaAngle = -pi * 2 + deltaAngle;
      }
      canvas.drawArc(Rect.fromLTRB(0, 0, 2 * radius * tileSize, 2 * radius * tileSize), startAngle - pi / 2, deltaAngle * 1.01, false, darkPaint);
      canvas.drawArc(Rect.fromLTRB(0, 0, 2 * radius * tileSize, 2 * radius * tileSize), startAngle - pi / 2, deltaAngle, false, paint);
      canvas.restore();
      canvas.drawLine(
          Offset(p1.dx + sin(startAngle) / 2, p1.dy - cos(startAngle) / 2) * tileSize, Offset(p1.dx - sin(startAngle) / 2, p1.dy + cos(startAngle) / 2) * tileSize, darkPaintSmall);
      canvas.drawLine(Offset(p2.dx + sin(angle * 2 - startAngle) / 2, p2.dy - cos(angle * 2 - startAngle) / 2) * tileSize,
          Offset(p2.dx - sin(angle * 2 - startAngle) / 2, p2.dy + cos(angle * 2 - startAngle) / 2) * tileSize, darkPaintSmall);
    } else {
      canvas.drawLine(Offset(p1.dx * tileSize, p1.dy * tileSize), Offset(p2.dx * tileSize, p2.dy * tileSize), darkPaint);
      canvas.drawLine(Offset((p1.dx + cos(angle) * BORDER_WIDTH / 2) * tileSize, (p1.dy + sin(angle) * BORDER_WIDTH / 2) * tileSize),
          Offset((p2.dx - cos(angle) * BORDER_WIDTH / 2) * tileSize, (p2.dy - sin(angle) * BORDER_WIDTH / 2) * tileSize), paint);
    }

    if (cyclist != null) {
      cyclist!.render(canvas, (p1 + p2) / 2 * tileSize, tileSize / 3, getCyclistAngle());
    }
  }

  getCyclistAngle() {
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
          double deltaAngle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
          angle = deltaAngle * 2 - startAngle;
        }
        if (clockwise) {
          angle += pi;
        }
      }
      TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: 'Roboto'), text: fieldValue.toInt().toString());

      CanvasUtils.drawText(c, Offset(((k == -1 ? p2 : p1).dx + cos(angle) * 0.6) * tileSize!, ((k == -1 ? p2 : p1).dy + sin(angle) * 0.6) * tileSize), angle + pi / 2, span);
    }
  }

  void update(double t) {}

  Color? getColor(bool darker) {
    MaterialColor color;
    switch (positionType) {
      case PositionType.COBBLE:
        color = Colors.teal;
        break;
      case PositionType.UPHILL:
        color = Colors.red;
        break;
      case PositionType.DOWNHILL:
        color = Colors.yellow;
        break;
      default:
        color = Colors.amber;
    }

    if (darker) {
      return color[700];
    }
    switch (state) {
      case PositionState.NOT_SELECTABLE:
        return color[50];
      case PositionState.SELECTABLE:
      default:
        return color[200];
    }
  }

  void setState(PositionState newState, [double? maxValue, List<Position?>? currentRoute, Cyclist? cyclist]) {
    if (newState == PositionState.SELECTABLE) {
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
        Position? priorityPosition = connections!.firstWhereOrNull(((element) => element?.j == j));
        if (priorityPosition != null) {
          priorityPosition.setState(newState, maxValue, currentRoute.toList(), cyclist);
        }

        this.connections!.forEach((pos) => pos!.setState(newState, maxValue, currentRoute.toList(), cyclist));
      }
    }
    state = newState;
  }

  double getValue(bool includingTurnUsed) {
    double value = this.j + this.iValue * 1000 + this.segment * 1000 * 1000;
    if (this.cyclist != null && includingTurnUsed) {
      value -= this.cyclist!.lastUsedOnTurn! * 1000 * 1000 * 1000;
    }
    return value;
  }

  void addConnection(Position pos) {
    connections!.add(pos);
  }

  void addCyclist(Cyclist? _cyclist) {
    cyclist = _cyclist;
  }

  Cyclist? removeCyclist() {
    Cyclist? temp = cyclist;
    cyclist = null;
    return temp;
  }

  void clickedEvent(Offset clickedEvent) {
    double angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    if (MapUtils.isInside(clickedEvent, p1, p2, 1, angle)) {
      if (this.state != PositionState.NOT_SELECTABLE) {
        this.listener!.selectPosition(route);
      }
    }
  }

  static Position? fromJson(Map<String, dynamic>? json, List<Position?> existingPositions, List<Sprint?> existingSprints, List<Cyclist?> existingCyclists,
      List<Team?> existingTeams, SpriteManager? spriteManager, PositionListener? listener) {
    if (json == null) {
      return null;
    }
    if (existingPositions.length > 0) {
      Position? c = existingPositions.firstWhereOrNull(((element) => element?.id == json['id']));
      if (c != null) {
        return c;
      }
    }
    if (json['id'] != null && json['segment'] == null) {
      Position placeholder = Position(Offset(0, 0), Offset(0, 0), listener, false, 0, 0, 0, 0, 0, false, 0, 0, false, PositionType.FLAT, isPlaceHolder: true);
      placeholder.id = json['id'];
      return placeholder;
    }
    Position position = Position(
      SaveUtil.offsetFromJson(json['p1'])!,
      SaveUtil.offsetFromJson(json['p2'])!,
      listener,
      json['isLast'],
      json['segment'],
      json['i'],
      json['iValue'],
      json['j'],
      json['k'],
      json['clockwise'],
      json['startAngle'],
      json['radius'],
      json['isCurved'],
      getPositionTypeFromString(json['positionType']),
      curvature: json['curvature'],
      fieldValue: json['fieldValue'],
      sprint: Sprint.fromJson(json['sprint'], existingSprints),
      isPlaceHolder: true,
    );
    position.id = json['id'];
    existingPositions.add(position);

    position.cyclist = Cyclist.fromJson(json['cyclist'], existingCyclists, existingTeams, spriteManager);
    position.connections =
        json['connections']?.map<Position>((e) => Position.fromJson(e, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, listener)!)?.toList();
    position.route =
        json['route']?.map<Position>((e) => Position.fromJson(e, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, listener)!)?.toList();
    position.state = getPositionStateFromString(json['state']);

    return position;
  }

  Map<String, dynamic> toJson(bool idOnly) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (!idOnly) {
      data['k'] = this.k;
      data['segment'] = this.segment;
      data['curvature'] = this.curvature;
      data['isLast'] = this.isLast;
      data['isCurved'] = this.isCurved;
      data['clockwise'] = this.clockwise;
      data['i'] = this.i;
      data['j'] = this.j;
      data['radius'] = this.radius;
      data['iValue'] = this.iValue;
      data['startAngle'] = this.startAngle;
      data['fieldValue'] = this.fieldValue;

      data['sprint'] = this.sprint?.toJson(true);
      data['cyclist'] = this.cyclist?.toJson(false);

      data['p1'] = SaveUtil.offsetToJson(this.p1);
      data['p2'] = SaveUtil.offsetToJson(this.p2);

      data['positionType'] = this.positionType.toString();
      data['state'] = this.state.toString();

      data['connections'] = this.connections?.map((v) => v!.toJson(true)).toList();
      data['route'] = this.route?.map((v) => v!.toJson(true)).toList();
    }
    return data;
  }
}

abstract class PositionListener {
  void selectPosition(List<Position?>? position);
}

PositionState? getPositionStateFromString(String? positionStateAsString) {
  for (PositionState element in PositionState.values) {
    if (element.toString() == positionStateAsString) {
      return element;
    }
  }
  return null;
}

PositionType? getPositionTypeFromString(String? positionTypeAsString) {
  for (PositionType element in PositionType.values) {
    if (element.toString() == positionTypeAsString) {
      return element;
    }
  }
  return null;
}

enum PositionState { NORMAL, SELECTABLE, NOT_SELECTABLE }
enum PositionType { FLAT, UPHILL, DOWNHILL, COBBLE }
