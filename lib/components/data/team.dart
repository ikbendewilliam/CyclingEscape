import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Team {
  final bool isPlayer;
  final int numberStart;
  List<Cyclist> cyclists = [];
  List<Sprite> sprites = [];
  String id = UniqueKey().toString();
  bool isPlaceHolder;

  Team(this.isPlayer, this.numberStart, SpriteManager spriteManager,
      {this.isPlaceHolder: false}) {
    if (isPlaceHolder) {
      return;
    }
    if (sprites.length == 0) {
      sprites.add(spriteManager?.getSprite('cyclists/rood.png'));
      sprites.add(spriteManager?.getSprite('cyclists/rood2.png'));
      sprites.add(spriteManager?.getSprite('cyclists/blauw.png'));
      sprites.add(spriteManager?.getSprite('cyclists/blauw2.png'));
      sprites.add(spriteManager?.getSprite('cyclists/zwart.png'));
      sprites.add(spriteManager?.getSprite('cyclists/zwart2.png'));
      sprites.add(spriteManager?.getSprite('cyclists/groen.png'));
      sprites.add(spriteManager?.getSprite('cyclists/groen2.png'));
      sprites.add(spriteManager?.getSprite('cyclists/bruin.png'));
      sprites.add(spriteManager?.getSprite('cyclists/bruin2.png'));
      sprites.add(spriteManager?.getSprite('cyclists/paars.png'));
      sprites.add(spriteManager?.getSprite('cyclists/paars2.png'));
      sprites.add(spriteManager?.getSprite('cyclists/grijs.png'));
      sprites.add(spriteManager?.getSprite('cyclists/grijs2.png'));
      sprites.add(spriteManager?.getSprite('cyclists/limoen.png'));
      sprites.add(spriteManager?.getSprite('cyclists/limoen2.png'));
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
    // print({numberStart, numberStart * 2, numberStart * 2 + (versie2 ? 1 : 0)});
    return sprites[numberStart * 2 + (versie2 ? 1 : 0)];
  }

  static Team fromJson(
      Map<String, dynamic> json,
      List<Cyclist> existingCyclists,
      List<Team> existingTeams,
      SpriteManager spriteManager) {
    if (json == null) {
      return null;
    }
    if (existingTeams != null && existingTeams.length > 0) {
      Team t = existingTeams.firstWhere((element) => element.id == json['id'],
          orElse: () => null);
      if (t != null) {
        return t;
      }
    }
    if (json['id'] != null && json['numberStart'] == null) {
      Team placeholder = Team(false, 0, null, isPlaceHolder: true);
      placeholder.id = json['id'];
      return placeholder;
    }

    Team team = Team(json['isPlayer'], json['numberStart'], spriteManager);
    team.id = json['id'];
    existingTeams.add(team);
    if (json['cyclists'] != null) {
      json['cyclists'].forEach((j) {
        team.cyclists.add(Cyclist.fromJson(
            j, existingCyclists, existingTeams, spriteManager));
      });
    }
    return team;
  }

  Map<String, dynamic> toJson(bool idOnly) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (!idOnly) {
      data['isPlayer'] = this.isPlayer;
      data['numberStart'] = this.numberStart;
      data['cyclists'] = this.cyclists?.map((i) => i.toJson(true));
    }
    return data;
  }
}
