import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:flutter/material.dart';

class Team {
  final bool isPlayer;
  final int numberStart;
  List<Cyclist> cyclists = [];

  Team(this.isPlayer, this.numberStart);

  static getColorFromId(id) {
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

  getColor() {
    return getColorFromId(numberStart);
  }
}
