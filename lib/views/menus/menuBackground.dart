import 'dart:math';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class MenuBackground {
  List<Sprite> backgrounds = [];
  List<Sprite> cyclists = [];
  List<double> cyclistsStart = [];
  List<double> cyclistsDelta = [];
  double horizontalOffset = 0;

  MenuBackground() {
    backgrounds.add(Sprite('bg_1.png'));
    backgrounds.add(Sprite('bg_2.png'));
    backgrounds.add(Sprite('bg_3.png'));
    backgrounds.add(Sprite('bg_4.png'));
  }

  void render(Canvas canvas, Size screenSize) {
    Paint bgPaint = Paint()..color = Colors.blue[50];
    canvas.drawRect(
        Rect.fromLTRB(0, 0, screenSize.width, screenSize.height), bgPaint);

    double offset = screenSize.height / 7;
    horizontalOffset %= screenSize.width * 8;

    for (int i = 0; i < backgrounds.length - 1; i++) {
      drawBackground(backgrounds[i], canvas, i, screenSize, offset);
    }

    for (int i = 0; i < cyclists.length; i++) {
      cyclists[i].renderPosition(
          canvas,
          Position(
              ((horizontalOffset - cyclistsStart[i]) * 8 * cyclistsDelta[i]) -
                  offset,
              offset * 5.5),
          size: Position(offset / 1.5, offset / 2));
      if (((horizontalOffset - cyclistsStart[i]) * 8) - offset * 2 >
          screenSize.width) {
        cyclists[i] = null;
        cyclistsStart[i] = null;
        cyclistsDelta[i] = null;
      }
    }
    cyclists = cyclists.where((element) => element != null).toList();
    cyclistsStart = cyclistsStart.where((element) => element != null).toList();
    cyclistsDelta = cyclistsDelta.where((element) => element != null).toList();
    drawBackground(backgrounds[backgrounds.length - 1], canvas,
        backgrounds.length - 1, screenSize, offset);
  }

  void drawBackground(
      Sprite background, Canvas canvas, int i, Size screenSize, double offset) {
    background.renderPosition(
        canvas,
        Position(-((horizontalOffset * pow(2, i)) % screenSize.width),
            offset * (i + 1)),
        size: Position(screenSize.width, screenSize.height - offset * (i + 1)));
    backgrounds[i].renderPosition(
        canvas,
        Position(
            screenSize.width -
                1 -
                (horizontalOffset * pow(2, i)) % screenSize.width,
            offset * (i + 1)),
        size: Position(screenSize.width, screenSize.height - offset * (i + 1)));
  }

  void update(double t) {
    horizontalOffset += t * 3;
    if (Random().nextDouble() < 0.005) {
      cyclists.add(Sprite('cyclistSillouhette.png'));
      cyclistsStart.add(horizontalOffset);
      cyclistsDelta.add((0.5 - Random().nextDouble()) / 10 + 1);
    }
  }
}
