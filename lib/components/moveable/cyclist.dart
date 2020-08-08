import 'dart:ui';

import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/positions/position.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:flutter/material.dart';

class Cyclist {
  final int number;
  int rank;
  final Team team;
  int lastUsedOnTurn = 0;
  Position lastPosition;

  Cyclist(this.team, this.number, this.rank);

  void render(Canvas canvas, Offset offset, double size) {
    Color color = team.getColor();
    if (rank == 0) {
      Paint paintJersey = Paint()
        ..color = Colors.yellow
        ..style = PaintingStyle.fill;
      canvas.drawCircle(offset, size * 1.5, paintJersey);
    }
    Paint paintCyclist = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(offset, size, paintCyclist);

    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'),
        text: number.toString());
    CanvasUtils.drawText(canvas, offset - Offset(0, size / 2), 0, span);
  }
}
