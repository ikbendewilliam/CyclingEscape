import 'dart:math';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

class Dice {
  final List<Sprite> sprites = [];
  int diceValue;
  int direction = 1;
  int currentIndex;
  int directionCountDown = 0;
  bool rolling = false;
  double angle = 0;
  double scale = 3;
  double countdown = 0.1;
  double minCountDown = 1;

  final DiceListener listener;

  Dice(this.listener) {
    for (int j = 0; j < 9; j++) {
      for (int i = 0; i < ((j == 0 || j == 8) ? 1 : 16); i++) {
        sprites.add(Sprite('dice2.png',
            x: 37.5 * i * 4,
            y: 37.5 * j * 4,
            height: 37 * 4.0,
            width: 37 * 4.0));
      }
    }
    List<int> indexes = [0, 49, 53, 57, 61, 113];
    currentIndex = indexes[Random().nextInt(indexes.length)];
  }

  start() {
    rolling = true;
  }

  render(Canvas canvas, int xOffset) {
    if (sprites.length > 0 && currentIndex >= 0) {
      canvas.save();
      canvas.translate((xOffset + 1) * 100.0, 100);
      canvas.rotate(angle);
      canvas.scale(scale / 4);
      sprites[currentIndex].renderCentered(canvas, Position(0, 0));
      canvas.restore();
    }
  }

  update(double t) {
    if (rolling) {
      minCountDown -= t;
      countdown -= t;
      if (countdown <= 0) {
        currentIndex = getNewIndex(t);
        countdown += 0.02;
      }
      diceValue = checkIndex();
      if (diceValue != 0 && minCountDown <= 0) {
        rolling = false;
        listener.diceStopped(diceValue);
      }
      scale -= t * 3;
      if (scale < 1) {
        scale = 1;
      }
    }
  }

  getIJ() {
    int i = 0;
    int j = 0;
    if (currentIndex == 0) {
      // i and j are already correct
    } else if (currentIndex == sprites.length - 1) {
      i = 0;
      j = 9;
    } else {
      i = (currentIndex + 15) % 16;
      j = ((currentIndex + 15) / 16).floor();
    }
    return [i, j];
  }

  checkIndex() {
    final ij = getIJ();
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

  getNewIndex(double t) {
    angle += (Random().nextDouble() - 0.5) * t * 10;
    final ij = getIJ();
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
  void diceStopped(int diceValue);
}
