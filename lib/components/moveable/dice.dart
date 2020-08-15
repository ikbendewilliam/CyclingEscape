import 'dart:math';
import 'dart:ui';

import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

class Dice {
  List<Sprite> sprites = [];
  final SpriteManager spriteManager;

  int diceValue;
  int direction = 1;
  int currentIndex;
  int endIndex;
  int directionCountDown = 0;
  bool rolling = false;
  double angle = 0;
  double scale = 3;
  double countdown = 0.1;
  List<int> diceAnimation = [];

  final DiceListener listener;

  Dice(this.spriteManager, this.listener) {
    sprites = this.spriteManager.getDiceSprites();
    List<int> indexes = [0, 49, 53, 57, 61, 113];
    endIndex = indexes[Random().nextInt(indexes.length)];
    currentIndex = indexes[Random().nextInt(indexes.length)];
    diceAnimation = getDiceAnimation(indexes);
    currentIndex = 0;
  }

  getDiceAnimation(indexes, {again: true}) {
    int index = endIndex;
    int counter = 1;
    List<int> animation = [index];
    while ((indexes.indexOf(index) == -1 || counter < 40) && counter < 1000) {
      index = getNewIndex(index);
      animation.add(index);
      counter++;
    }
    if (animation.length > 500 && again) {
      List<int> animation2 = getDiceAnimation(indexes, again: false);
      if (animation.length > animation2.length) {
        return animation2;
      }
    }
    return animation.reversed.toList();
  }

  start() {
    rolling = true;
  }

  render(Canvas canvas, int xOffset, double tileSize) {
    if (sprites.length > 0 && currentIndex >= 0 && diceAnimation.length > 0) {
      canvas.save();
      canvas.translate((xOffset + 0.5) * tileSize * 3, 100);
      canvas.rotate(angle);
      if (currentIndex < diceAnimation.length) {
        sprites[diceAnimation[currentIndex]].renderCentered(
            canvas, Position(0, 0),
            size: Position(tileSize * scale, tileSize * scale));
      } else {
        sprites[diceAnimation.last].renderCentered(canvas, Position(0, 0));
      }
      canvas.restore();
    }
  }

  update(double t) {
    if (rolling) {
      countdown -= t;
      if (countdown <= 0) {
        angle += (Random().nextDouble() - 0.5) * t * 10;
        currentIndex++;
        countdown += 0.02;
        if (currentIndex >= diceAnimation.length) {
          // diceValue = getValue();
          rolling = false;
          listener.diceStopped();
        }
      }
      if (scale > 1) {
        scale -= t * 3;
        if (scale < 1) {
          scale = 1;
        }
      }
    }
  }

  getIJ(int current) {
    int i = 0;
    int j = 0;
    if (current == 0) {
      // i and j are already correct
    } else if (current == sprites.length - 1) {
      i = 0;
      j = 8;
    } else {
      i = (current + 15) % 16;
      j = ((current + 15) / 16).floor();
    }
    return [i, j];
  }

  int getValue() {
    final ij = getIJ(endIndex);
    int i = ij[0], j = ij[1];
    if (j == 0) {
      return 4;
    } else if (j == 8) {
      return 3;
    } else if (j == 4 && i % 4 == 0) {
      switch ((i / 4).floor()) {
        case 0:
          return 1;
        case 1:
          return 2;
        case 2:
          return 6;
        case 3:
          return 5;
      }
    }
    return 0;
  }

  getNewIndex(int current) {
    final ij = getIJ(current);
    int i = ij[0], j = ij[1];
    directionCountDown--;
    if (directionCountDown <= 0) {
      direction = Random().nextInt(4);
      directionCountDown = Random().nextInt(10) + 5;
    }
    bool moveHorizontal = !(j <= 0 || j >= 8) && direction / 2 == 0;
    bool increase = direction % 2 == 0;
    if (moveHorizontal) {
      i = (i + (increase ? 1 : -1) + 16) % 16;
    } else {
      if (j <= 0 || j >= 8) {
        direction += 1;
        angle += pi;
        i = Random().nextInt(4) * 4;
        if (j <= 0) {
          j = 1;
        } else {
          j = 7;
        }
      } else {
        j = j + (increase ? 1 : -1);
      }
    }
    if (j <= 0) {
      return 0;
    } else if (j >= 8) {
      return sprites.length - 1;
    } else {
      return i + (j - 1) * 16 + 1;
    }
  }
}

abstract class DiceListener {
  void diceStopped();
}
