import 'dart:math';
import 'dart:ui';

import 'package:CyclingEscape/components/data/cyclistPlace.dart';
import 'package:flutter/material.dart';

class Sprint {
  final SprintType type;
  final double angle;
  final int segment;
  final int width;
  final List<CyclistPlace> cyclistPlaces = [];

  Offset offset;
  String id;

  Sprint(this.type, this.offset, this.width, this.angle, this.segment) {
    this.id = UniqueKey().toString();
  }

  void render(Canvas canvas, tileSize) {
    Paint paint = Paint()
      ..color = getColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize / 3;
    canvas.drawLine(
        Offset((offset.dx - sin(angle) / 2 + cos(angle) / 6) * tileSize,
            (offset.dy - cos(angle) / 2 - sin(angle) / 6) * tileSize),
        Offset(
            (offset.dx + sin(angle) * (width - 1 / 2) + cos(angle) / 6) *
                tileSize,
            (offset.dy + cos(angle) * (width - 1 / 2) - sin(angle) / 6) *
                tileSize),
        paint);
  }

  addCyclistPlace(CyclistPlace cyclistPlace) {
    cyclistPlaces.add(cyclistPlace);
    // print('$type (${cyclistPlaces.length})');
  }

  Color getColor() {
    switch (type) {
      case SprintType.SPRINT:
        return Colors.green;
      case SprintType.MOUNTAIN_SPRINT:
        return Colors.red;
      case SprintType.START:
      case SprintType.FINISH:
      default:
        return Colors.white;
    }
  }

  getPoints(int rank) {
    if (type == SprintType.FINISH) {
      if (rank == 0) {
        return 10;
      } else if (rank == 1) {
        return 7;
      } else if (rank < 7) {
        return 7 - rank;
      }
      return 0;
    } else if (type == SprintType.SPRINT ||
        type == SprintType.MOUNTAIN_SPRINT) {
      if (rank == 0) {
        return 5;
      } else if (rank < 4) {
        return 4 - rank;
      }
      return 0;
    }
  }

  getPointsName() {
    switch (type) {
      case SprintType.SPRINT:
        return 'p';
      case SprintType.MOUNTAIN_SPRINT:
        return 'mp';
      default:
        return '';
    }
  }
}

enum SprintType { START, SPRINT, MOUNTAIN_SPRINT, FINISH }
