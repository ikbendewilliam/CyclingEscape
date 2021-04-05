import 'dart:math';
import 'dart:ui';

import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class MenuBackground {
  List<Sprite?> backgrounds = [];
  List<MovingObject> objects = [];
  double horizontalOffset = 0;
  Sprite? cyclistSillouhette;
  Sprite? cloud1, cloud2, cloud3, cloud4, cloud5;
  Sprite? tardis;
  Size? screenSize;

  MenuBackground(SpriteManager spriteManager) {
    backgrounds.add(spriteManager.getSprite('bg_1.png'));
    backgrounds.add(spriteManager.getSprite('bg_2.png'));
    backgrounds.add(spriteManager.getSprite('bg_3.png'));
    backgrounds.add(spriteManager.getSprite('bg_4.png'));
    cloud1 = spriteManager.getSprite('cloud1.png');
    cloud2 = spriteManager.getSprite('cloud2.png');
    cloud3 = spriteManager.getSprite('cloud3.png');
    cloud4 = spriteManager.getSprite('cloud4.png');
    cloud5 = spriteManager.getSprite('cloud5.png');
    tardis = spriteManager.getSprite('tardis.png');
    cyclistSillouhette = spriteManager.getSprite('cyclistSillouhette.png');
  }

  void render(Canvas canvas, Size? newScreenSize) {
    screenSize = newScreenSize;
    Paint bgPaint = Paint()..color = Colors.blue[100]!;
    canvas.drawRect(Rect.fromLTRB(0, 0, screenSize!.width, screenSize!.height), bgPaint);

    double offset = screenSize!.height / 7;
    horizontalOffset %= screenSize!.width * 8;

    for (int i = 0; i < backgrounds.length - 1; i++) {
      drawBackground(backgrounds[i], canvas, i, screenSize!, offset);
    }

    List<MovingObject> toDelete = [];
    objects.forEach((element) {
      double x = ((horizontalOffset - element.horizontalOffset) * 8 * element.speed) - offset;
      if (element.sprite != cyclistSillouhette && element.sprite != tardis) {
        x = screenSize!.width - x;
      }
      element.sprite!.render(canvas, position: Vector2(x, element.height), size: Vector2(element.scale * offset / 1.5, element.scale * offset / 2));
      if (((horizontalOffset - element.horizontalOffset) * 8 * element.speed) * -offset * 2 > screenSize!.width) {
        toDelete.add(element);
      }
    });

    toDelete.forEach((element) {
      objects.remove((x) => x == element);
    });
    drawBackground(backgrounds[backgrounds.length - 1]!, canvas, backgrounds.length - 1, screenSize!, offset);
  }

  void drawBackground(Sprite? background, Canvas canvas, int i, Size screenSize, double offset) {
    background?.render(canvas,
        position: Vector2(-((horizontalOffset * pow(2, i)) % screenSize.width), offset * (i + 1)), size: Vector2(screenSize.width, screenSize.height - offset * (i + 1)));
    backgrounds[i]?.render(canvas,
        position: Vector2(screenSize.width - 1 - (horizontalOffset * pow(2, i)) % screenSize.width, offset * (i + 1)),
        size: Vector2(screenSize.width, screenSize.height - offset * (i + 1)));
  }

  void update(double t) {
    if (screenSize == null) {
      return;
    }
    double offset = screenSize!.height / 7;
    horizontalOffset += t * 3;
    if (Random().nextDouble() < 0.005) {
      objects.add(MovingObject(cyclistSillouhette, (0.5 - Random().nextDouble()) / 10 + 1, horizontalOffset, offset * 5.5, 1));
    } else if (Random().nextDouble() < 0.01) {
      Sprite? sprite = cloud1;
      switch (Random().nextInt(5)) {
        case 0:
          sprite = cloud1;
          break;
        case 1:
          sprite = cloud2;
          break;
        case 2:
          sprite = cloud3;
          break;
        case 3:
          sprite = cloud4;
          break;
        case 4:
          sprite = cloud5;
          break;
      }
      objects.add(MovingObject(
        sprite,
        (0.5 - Random().nextDouble()) / 5 + 1,
        horizontalOffset,
        offset * (Random().nextDouble() + 0.5),
        sprite == cloud2 ? 1 : (Random().nextDouble() * 3 + 1),
      ));
    } else if (Random().nextDouble() < 0.001) {
      objects.add(MovingObject(tardis, 10, horizontalOffset, offset * 4, 1));
    }
  }
}

class MovingObject {
  final Sprite? sprite;
  final double speed;
  final double horizontalOffset;
  final double height;
  final double scale;

  MovingObject(this.sprite, this.speed, this.horizontalOffset, this.height, this.scale);
}
