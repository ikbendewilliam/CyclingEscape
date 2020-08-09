import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Team {
  final bool isPlayer;
  final int numberStart;
  List<Cyclist> cyclists = [];
  List<Sprite> sprites = [];

  Team(this.isPlayer, this.numberStart) {
    if (sprites.length == 0) {
      sprites.add(Sprite('cyclists/rood.png'));
      sprites.add(Sprite('cyclists/rood2.png'));
      sprites.add(Sprite('cyclists/blauw.png'));
      sprites.add(Sprite('cyclists/blauw2.png'));
      sprites.add(Sprite('cyclists/zwart.png'));
      sprites.add(Sprite('cyclists/zwart2.png'));
      sprites.add(Sprite('cyclists/groen.png'));
      sprites.add(Sprite('cyclists/groen2.png'));
      sprites.add(Sprite('cyclists/bruin.png'));
      sprites.add(Sprite('cyclists/bruin2.png'));
      sprites.add(Sprite('cyclists/paars.png'));
      sprites.add(Sprite('cyclists/paars2.png'));
      sprites.add(Sprite('cyclists/grijs.png'));
      sprites.add(Sprite('cyclists/grijs2.png'));
      sprites.add(Sprite('cyclists/limoen.png'));
      sprites.add(Sprite('cyclists/limoen2.png'));
    }
  }

  static Color getColorFromId(id) {
    switch (id) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.black;
      case 3:
        return Colors.green;
      case 4:
        return Colors.brown;
      case 5:
        return Colors.purple;
      case 6:
        return Colors.grey;
      case 7:
        return Colors.lime;
      case 0:
      default:
        return Colors.red;
    }
  }

  Color getColor() {
    return getColorFromId(numberStart);
  }

  Color getTextColor() {
    switch (numberStart) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        return Colors.white;
      case 6:
      case 7:
      default:
        return Colors.black;
    }
  }

  Sprite getSprite(versie2) {
    print({numberStart, numberStart * 2, numberStart * 2 + (versie2 ? 1 : 0)});
    return sprites[numberStart * 2 + (versie2 ? 1 : 0)];
  }
}
