import 'dart:math';
import 'dart:ui';

import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:cycling_escape/views/menus/settingsMenu.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Dice {
  List<Sprite> sprites = [];
  final SpriteManager spriteManager;

  int? diceValue;
  int direction = 1;
  late int currentIndex;
  int endIndex = 0;
  int directionCountDown = 0;
  bool rolling = false;
  double angle = 0;
  double scale = 3;
  double countdown = 0.1;
  List<int> diceAnimation = [];

  final DiceListener listener;

  Dice(this.spriteManager, this.listener, {bool generate: true, DifficultyType? difficulty, bool? isPlayer}) {
    sprites = this.spriteManager.getDiceSprites();
    if (generate) {
      // 1, 2, 3, 4, 5, 6 respectivly
      List<int> indexes = [49, 53, 113, 0, 61, 57];
      endIndex = indexes[Random().nextInt(indexes.length)];
      if (isPlayer == true && difficulty == DifficultyType.EASY) {
        increaseValue();
      } else if (isPlayer == false && difficulty == DifficultyType.HARD) {
        increaseValue();
      }
      currentIndex = indexes[Random().nextInt(indexes.length)];
      diceAnimation = getDiceAnimation(indexes);
    }
    currentIndex = 0;
  }

  List<int> getDiceAnimation(indexes, {again: true}) {
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

  render(Canvas canvas, Offset offset, double? tileSize) {
    if (sprites.length > 0 && currentIndex >= 0 && diceAnimation.length > 0) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      if (currentIndex < diceAnimation.length) {
        sprites[diceAnimation[currentIndex]].render(canvas, position: Vector2.zero(), size: Vector2(tileSize! * scale, tileSize * scale));
      } else {
        sprites[diceAnimation.last].render(canvas, position: Vector2.zero());
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

  getIJ(int? current) {
    int i = 0;
    int j = 0;
    if (current == 0) {
      // i and j are already correct
    } else if (current == sprites.length - 1) {
      i = 0;
      j = 8;
    } else {
      i = (current! + 15) % 16;
      j = ((current + 15) / 16).floor();
    }
    return [i, j];
  }

  int getValue() {
    final ij = getIJ(endIndex);
    int? i = ij[0], j = ij[1];
    if (j == 0) {
      return 4;
    } else if (j == 8) {
      return 3;
    } else if (j == 4 && i! % 4 == 0) {
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

  void increaseValue() {
    List<int> indexes = [49, 53, 113, 0, 61, 57];
    int newIndex = indexes.indexOf(endIndex) + 1;
    if (newIndex < indexes.length) {
      endIndex = indexes[newIndex];
    }
  }

  getNewIndex(int? current) {
    final ij = getIJ(current);
    int? i = ij[0], j = ij[1];
    directionCountDown--;
    if (directionCountDown <= 0) {
      direction = Random().nextInt(4);
      directionCountDown = Random().nextInt(10) + 5;
    }
    bool moveHorizontal = !(j! <= 0 || j >= 8) && direction / 2 == 0;
    bool increase = direction % 2 == 0;
    if (moveHorizontal) {
      i = (i! + (increase ? 1 : -1) + 16) % 16;
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
      return i! + (j - 1) * 16 + 1;
    }
  }

  static Dice? fromJson(Map<String, dynamic>? json, DiceListener listener, SpriteManager spriteManager) {
    if (json == null) {
      return null;
    }
    Dice dice = Dice(spriteManager, listener, generate: false);
    dice.diceValue = json['diceValue'];
    dice.direction = json['direction'];
    dice.currentIndex = json['currentIndex'];
    dice.endIndex = json['endIndex'];
    dice.directionCountDown = json['directionCountDown'];
    dice.rolling = json['rolling'];
    dice.angle = json['angle'];
    dice.scale = json['scale'];
    dice.countdown = json['countdown'];
    dice.diceAnimation = json['diceAnimation'] != null ? List<int>.from(json['diceAnimation']) : [];
    return dice;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['diceValue'] = this.diceValue;
    data['direction'] = this.direction;
    data['currentIndex'] = this.currentIndex;
    data['endIndex'] = this.endIndex;
    data['directionCountDown'] = this.directionCountDown;
    data['rolling'] = this.rolling;
    data['angle'] = this.angle;
    data['scale'] = this.scale;
    data['countdown'] = this.countdown;
    data['diceAnimation'] = this.diceAnimation;
    return data;
  }
}

abstract class DiceListener {
  void diceStopped();
}
