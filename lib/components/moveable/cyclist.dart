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
  Sprite cyclistYellowJerseySprite;
  Sprite cyclistWhiteJerseySprite;
  Sprite cyclistGreenJerseySprite;
  Sprite cyclistBouledJerseySprite;
  bool wearsYellowJersey = false;
  bool wearsWhiteJersey = false;
  bool wearsGreenJersey = false;
  bool wearsBouledJersey = false;

  Cyclist(this.team, this.number, this.rank) {
    cyclistSprite = this.team.getSprite(this.number % 2 == 0);
    cyclistYellowJerseySprite =
        Sprite('cyclists/geel${this.number % 2 == 0 ? '2' : ''}.png');
    cyclistWhiteJerseySprite =
        Sprite('cyclists/wit${this.number % 2 == 0 ? '2' : ''}.png');
    cyclistGreenJerseySprite =
        Sprite('cyclists/lichtgroen${this.number % 2 == 0 ? '2' : ''}.png');
    cyclistBouledJerseySprite =
        Sprite('cyclists/bollekes${this.number % 2 == 0 ? '2' : ''}.png');
  }

  void render(Canvas canvas, Offset offset, double size, double angle) {
    if (cyclistSprite != null) {
      if (cyclistSprite.loaded()) {
        canvas.save();
        canvas.translate(offset.dx, offset.dy);
        canvas.rotate(pi / 2 + angle);
        Sprite sprite = cyclistSprite;
        Color textColor = team.getTextColor();
        if (wearsYellowJersey) {
          sprite = cyclistYellowJerseySprite;
          textColor = Colors.black;
        } else if (wearsGreenJersey) {
          sprite = cyclistGreenJerseySprite;
          textColor = Colors.black;
        } else if (wearsWhiteJersey) {
          sprite = cyclistWhiteJerseySprite;
          textColor = Colors.black;
        } else if (wearsBouledJersey) {
          sprite = cyclistBouledJerseySprite;
          textColor = Colors.black;
        }
        sprite.renderCentered(canvas, flamePosition.Position(0, 0),
            size: flamePosition.Position(size * 3, size * 6));

        TextSpan span = new TextSpan(
            style: new TextStyle(
                color: textColor, fontSize: 10.0, fontFamily: 'SaranaiGame'),
            text: number.toString());
        CanvasUtils.drawText(canvas, Offset(0, -size / 3), 0, span);

        canvas.restore();
      }
    }
  }
}
