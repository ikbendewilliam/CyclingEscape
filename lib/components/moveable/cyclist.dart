import 'dart:math';
import 'dart:ui';

import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/positions/position.dart';
import 'package:CyclingEscape/utils/canvasUtils.dart';
import 'package:flame/position.dart' as flamePosition;
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Cyclist {
  final int number;
  int rank;
  final Team team;
  int lastUsedOnTurn = 0;
  Position lastPosition;
  Sprite cyclistSprite;

  Cyclist(this.team, this.number, this.rank) {
    cyclistSprite = this.team.getSprite(this.number % 2 == 0);
  }

  void render(Canvas canvas, Offset offset, double size, double angle) {
    Color color = team.getColor();
    if (cyclistSprite != null) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(pi / 2 + angle);
      cyclistSprite.renderCentered(canvas, flamePosition.Position(0, 0),
          size: flamePosition.Position(size * 3, size * 6));

      TextSpan span = new TextSpan(
          style: new TextStyle(
              color: Colors.white, fontSize: 10.0, fontFamily: 'SaranaiGame'),
          text: number.toString());
      CanvasUtils.drawText(canvas, Offset(0, -size / 3), 0, span);

      canvas.restore();
      // } else {
      //   if (rank == 0) {
      //     Paint paintJersey = Paint()
      //       ..color = Colors.yellow
      //       ..style = PaintingStyle.fill;
      //     canvas.drawCircle(offset, size * 1.5, paintJersey);
      //   }
      //   Paint paintCyclist = Paint()
      //     ..color = color
      //     ..style = PaintingStyle.fill;
      //   canvas.drawCircle(offset, size, paintCyclist);

      //   TextSpan span = new TextSpan(
      //       style: new TextStyle(
      //           color: Colors.white, fontSize: 12.0, fontFamily: 'SaranaiGame'),
      //       text: number.toString());
      //   CanvasUtils.drawText(canvas, offset - Offset(0, size / 2), 0, span);
    }
  }
}
