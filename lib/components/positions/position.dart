import 'dart:math';
import 'dart:ui';

import 'package:CyclingEscape/components/data/storage.dart';
import 'package:CyclingEscape/components/positions/sprint.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:CyclingEscape/utils/mapUtils.dart';
import 'package:flutter/material.dart';

import '../moveable/cyclist.dart';

const BORDER_WIDTH = 0.1;

class Position {
  final int curvature;
  final int segment;
  final bool isCurved;
  final bool isLast;
  final double i;
  final double iValue;
  final double j;
  final Sprint sprint;
  final PositionType positionType;
  final PositionListener listener;

  String id;
  Offset p1;
  Offset p2;
  double fieldValue = 0;
  List<Position> connections = [];
  Cyclist cyclist;
  PositionState state = PositionState.NORMAL;

  Position(this.p1, this.p2, this.listener, this.isLast, this.segment, this.i,
      this.iValue, this.j, this.isCurved, this.positionType,
      {this.curvature, this.fieldValue, this.sprint, this.id}) {
    this.id = UniqueKey().toString();
  }

  void render(Canvas c, double tileSize) {
    Paint paint = Paint()
      ..color = getColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize * (1 - BORDER_WIDTH);
    Paint blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize;
    double angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    c.drawLine(Offset((p1.dx) * tileSize, (p1.dy) * tileSize),
        Offset((p2.dx) * tileSize, (p2.dy) * tileSize), blackPaint);
    c.drawLine(
        Offset((p1.dx + cos(angle) * BORDER_WIDTH / 2) * tileSize,
            (p1.dy + sin(angle) * BORDER_WIDTH / 2) * tileSize),
        Offset((p2.dx - cos(angle) * BORDER_WIDTH / 2) * tileSize,
            (p2.dy - sin(angle) * BORDER_WIDTH / 2) * tileSize),
        paint);

    if (cyclist != null) {
      cyclist.render(
          c,
          (Offset((p1.dx + cos(angle) * BORDER_WIDTH / 2) * tileSize,
                      (p1.dy + sin(angle) * BORDER_WIDTH / 2) * tileSize) +
                  Offset((p2.dx - cos(angle) * BORDER_WIDTH / 2) * tileSize,
                      (p2.dy - sin(angle) * BORDER_WIDTH / 2) * tileSize)) /
              2,
          tileSize / 3);
    }
  }

  void renderText(Canvas c, double tileSize) {
    if (fieldValue != null && fieldValue != 0) {
      double angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: Colors.black, fontSize: 20.0, fontFamily: 'Roboto'),
          text: fieldValue.toInt().toString());

      CanvasUtils.drawText(
          c,
          Offset((p1.dx + cos(angle) * BORDER_WIDTH * 6) * tileSize,
              (p1.dy + sin(angle) * BORDER_WIDTH * 6) * tileSize),
          angle + pi / 2,
          span);
    }
  }

  void update(double t) {}

  Color getColor() {
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
        color = Colors.orange;
    }

    switch (state) {
      case PositionState.NOT_SELECTABLE:
        return color[50];
      case PositionState.SELECTABLE:
      default:
        return color[200];
    }
  }

  void setState(newState, [range, cyclist]) {
    if (newState == PositionState.SELECTABLE) {
      if (this.cyclist != null && cyclist != null && this.cyclist != cyclist) {
        return;
      }
    }
    state = newState;
    if (range != null && range > 0) {
      this
          .connections
          .forEach((pos) => pos.setState(newState, range - 1, cyclist));
    }
  }

  double getValue(bool includingTurnUsed) {
    double value = this.j + this.iValue * 1000 + this.segment * 1000 * 1000;
    if (this.cyclist != null && includingTurnUsed) {
      value -= this.cyclist.lastUsedOnTurn * 1000 * 1000 * 1000;
    }
    return value;
  }

  void addConnection(Position pos) {
    connections.add(pos);
  }

  void addCyclist(Cyclist _cyclist) {
    cyclist = _cyclist;
  }

  Cyclist removeCyclist() {
    Cyclist temp = cyclist;
    cyclist = null;
    return temp;
  }

  void clickedEvent(Offset clickedEvent) {
    double angle = atan2(p2.dy - p1.dy, p2.dx - p1.dx);
    if (MapUtils.isInside(clickedEvent, p1, p2, 1, angle)) {
      if (this.state != PositionState.NOT_SELECTABLE) {
        this.listener.selectPosition(this);
      }
    }
  }

//   static Position fromJson(Map<String, dynamic> json) {
//     return new Position(

//            json['p1'] != null ? OffsetFromJSON.fromJson(json['p1']) : null
//      , json['p2'] != null ? OffsetFromJSON.fromJson(json['p2']) : null
//      ,null
//      , json['isLast']
//      , json['segment']
//      , json['i']
//      , json['iValue']
//      , json['j']
//      , json['isCurved']
//      , json['positionType']
//      , curvature: json['curvature']
//      , sprint: json['sprint']
//      , fieldValue: json['fieldValue']
//      , json['connections'].cast<String>()
//      , json['cyclist'].cast<String>()
//      , json['state']
// ,json['id']
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['curvature'] = this.curvature;
//     data['segment'] = this.segment;
//     data['isCurved'] = this.isCurved;
//     data['isLast'] = this.isLast;
//     data['i'] = this.i;
//     data['iValue'] = this.iValue;
//     data['j'] = this.j;
//     data['sprint'] = this.sprint;
//     data['positionType'] = this.positionType;
//     if (this.p1 != null) {
//       data['p1'] = this.p1.toJson();
//     }
//     if (this.p2 != null) {
//       data['p2'] = this.p2.toJson();
//     }
//     data['fieldValue'] = this.fieldValue;
//     data['connections'] = this.connections;
//     data['cyclist'] = this.cyclist;
//     data['state'] = this.state;
//     return data;
//   }
}

abstract class PositionListener {
  void selectPosition(Position position);
}

enum PositionState { NORMAL, SELECTABLE, NOT_SELECTABLE }
enum PositionType { FLAT, UPHILL, DOWNHILL, COBBLE }
