import 'dart:math';
import 'dart:ui';

import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Dice {
  late final SpriteSheet sprites;
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

  Dice(this.spriteManager, this.listener, {bool generate = true, required DifficultyType difficulty, bool? isPlayer}) {
    sprites = spriteManager.getDiceSpriteSheet();
    if (generate) {
      // 1, 2, 3, 4, 5, 6 respectivly
      final List<int> indexes = [49, 53, 113, 0, 61, 57];
      var index = Random().nextInt(indexes.length);
      if (isPlayer == true && difficulty.diceAddition > 0) {
        index += difficulty.diceAddition;
      } else if (isPlayer == false && difficulty.diceAddition < 0) {
        index -= difficulty.diceAddition;
      }
      endIndex = indexes[index.clamp(0, indexes.length - 1)];
      currentIndex = indexes[Random().nextInt(indexes.length)];
      diceAnimation = getDiceAnimation(indexes);
    }
    currentIndex = 0;
  }

  List<int> getDiceAnimation(List<int> indexes, {bool again = true}) {
    int index = endIndex;
    int counter = 1;
    final List<int> animation = [index];
    while ((!indexes.contains(index) || counter < 40) && counter < 1000) {
      index = getNewIndex(index);
      animation.add(index);
      counter++;
    }
    if (animation.length > 500 && again) {
      final List<int> animation2 = getDiceAnimation(indexes, again: false);
      if (animation.length > animation2.length) {
        return animation2;
      }
    }
    return animation.reversed.toList();
  }

  void start() {
    rolling = true;
  }

  void render(Canvas canvas, Offset offset, double tileSize) {
    if (currentIndex >= 0 && diceAnimation.isNotEmpty) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      List<int> ij;
      ij = getIJ((currentIndex < diceAnimation.length) ? diceAnimation[currentIndex] : diceAnimation.last);
      sprites.getSprite(ij[1], ij[0]).render(canvas, position: Vector2.zero(), size: Vector2(tileSize * scale, tileSize * scale));
      canvas.restore();
    }
  }

  void update(double t) {
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

  List<int> getIJ(int current) {
    if (current == 0) {
      return [0, 0];
    } else if (current + sprites.columns > sprites.columns * (sprites.rows - 1)) {
      return [0, 8];
    }
    final currentTranslated = current + sprites.columns - 1;
    return [currentTranslated % sprites.columns, (currentTranslated / sprites.columns).floor()];
  }

  int getValue() {
    final ij = getIJ(endIndex);
    final int i = ij[0];
    final j = ij[1];
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

  int getNewIndex(int current) {
    final ij = getIJ(current);
    int? i = ij[0], j = ij[1];
    directionCountDown--;
    if (directionCountDown <= 0) {
      direction = Random().nextInt(4);
      directionCountDown = Random().nextInt(10) + 5;
    }
    final bool moveHorizontal = !(j <= 0 || j >= 8) && direction / 2 == 0;
    final bool increase = direction % 2 == 0;
    if (moveHorizontal) {
      i = (i + (increase ? 1 : -1) + sprites.columns) % sprites.columns;
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
      return (sprites.rows - 1) * sprites.columns;
    } else {
      return i + (j - 1) * sprites.columns + 1;
    }
  }

  // static Dice? fromJson(Map<String, dynamic>? json, DiceListener listener, SpriteManager spriteManager) {
  //   if (json == null) {
  //     return null;
  //   }
  //   final Dice dice = Dice(spriteManager, listener, generate: false);
  //   dice.diceValue = json['diceValue'] as int?;
  //   dice.direction = json['direction'] as int;
  //   dice.currentIndex = json['currentIndex'] as int;
  //   dice.endIndex = json['endIndex'] as int;
  //   dice.directionCountDown = json['directionCountDown'] as int;
  //   dice.rolling = json['rolling'] as bool;
  //   dice.angle = json['angle'] as double;
  //   dice.scale = json['scale'] as double;
  //   dice.countdown = json['countdown'] as double;
  //   dice.diceAnimation = json['diceAnimation'] != null ? List<int>.from(json['diceAnimation'] as List) : [];
  //   return dice;
  // }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    // data['diceValue'] = diceValue;
    // data['direction'] = direction;
    // data['currentIndex'] = currentIndex;
    // data['endIndex'] = endIndex;
    // data['directionCountDown'] = directionCountDown;
    // data['rolling'] = rolling;
    // data['angle'] = angle;
    // data['scale'] = scale;
    // data['countdown'] = countdown;
    // data['diceAnimation'] = diceAnimation;
    return data;
  }
}

abstract class DiceListener {
  void diceStopped();
}
