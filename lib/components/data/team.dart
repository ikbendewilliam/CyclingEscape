import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Team {
  final bool isPlayer;
  final int numberStart;
  List<Cyclist> cyclists = [];

  Team(this.isPlayer, this.numberStart);

  static Color getColorFromId(id) {
    switch (id) {
      case 0:
        return Colors.red;
        break;
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.black;
        break;
      case 3:
        return Colors.green;
        break;
      case 4:
        return Colors.brown;
        break;
      case 5:
        return Colors.purple;
        break;
      case 6:
        return Colors.grey;
        break;
      case 7:
        return Colors.lime;
        break;
    }
  }

  Color getColor() {
    return getColorFromId(numberStart);
  }

  Sprite getSprite(versie2) {
    switch (numberStart) {
      case 0:
        return Sprite('cyclists/rood${versie2 ? '2' : ''}.png');
        break;
      case 1:
        return Sprite('cyclists/blauw${versie2 ? '2' : ''}.png');
        break;
      case 2:
        return Sprite('cyclists/zwart${versie2 ? '2' : ''}.png');
        break;
      case 3:
        return Sprite('cyclists/groen${versie2 ? '2' : ''}.png');
        break;
      case 4:
        return Sprite('cyclists/bruin${versie2 ? '2' : ''}.png');
        break;
      case 5:
        return Sprite('cyclists/paars${versie2 ? '2' : ''}.png');
        break;
      case 6:
        return Sprite('cyclists/grijs${versie2 ? '2' : ''}.png');
        break;
      case 7:
        return Sprite('cyclists/limoen${versie2 ? '2' : ''}.png');
        break;
      default:
        return null;
    }
  }
}
