import 'package:collection/collection.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/moveable/cyclist.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Team {
  final bool? isPlayer;
  final int? numberStart;
  List<Cyclist?> cyclists = [];
  List<Sprite?> sprites = [];
  String? id = UniqueKey().toString();
  bool isPlaceHolder;

  Team(this.isPlayer, this.numberStart, SpriteManager? spriteManager, {this.isPlaceHolder = false}) {
    if (isPlaceHolder || spriteManager == null || sprites.isNotEmpty) return;
    sprites.add(spriteManager.getSprite('cyclists/rood.png'));
    sprites.add(spriteManager.getSprite('cyclists/rood2.png'));
    sprites.add(spriteManager.getSprite('cyclists/blauw.png'));
    sprites.add(spriteManager.getSprite('cyclists/blauw2.png'));
    sprites.add(spriteManager.getSprite('cyclists/zwart.png'));
    sprites.add(spriteManager.getSprite('cyclists/zwart2.png'));
    sprites.add(spriteManager.getSprite('cyclists/groen.png'));
    sprites.add(spriteManager.getSprite('cyclists/groen2.png'));
    sprites.add(spriteManager.getSprite('cyclists/bruin.png'));
    sprites.add(spriteManager.getSprite('cyclists/bruin2.png'));
    sprites.add(spriteManager.getSprite('cyclists/paars.png'));
    sprites.add(spriteManager.getSprite('cyclists/paars2.png'));
    sprites.add(spriteManager.getSprite('cyclists/grijs.png'));
    sprites.add(spriteManager.getSprite('cyclists/grijs2.png'));
    sprites.add(spriteManager.getSprite('cyclists/limoen.png'));
    sprites.add(spriteManager.getSprite('cyclists/limoen2.png'));
  }

  static Color getColorFromId(int id) {
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

  static int getIdFromCyclistNumber(int number) => number ~/ 10 - 2;

  static Color getTextColorFromId(int id) {
    switch (id) {
      case 6:
      case 7:
        return Colors.black;
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      default:
        return Colors.white;
    }
  }

  Color getColor() => getColorFromId(numberStart ?? -1);

  Color getTextColor() => getTextColorFromId(numberStart ?? -1);

  Sprite? getSprite(bool versie2) {
    // print({numberStart, numberStart * 2, numberStart * 2 + (versie2 ? 1 : 0)});
    return sprites[numberStart! * 2 + (versie2 ? 1 : 0)];
  }

  static Team? fromJson(Map<String, dynamic>? json, List<Cyclist?> existingCyclists, List<Team?> existingTeams, SpriteManager? spriteManager) {
    if (json == null) {
      return null;
    }
    if (existingTeams.isNotEmpty) {
      final Team? t = existingTeams.firstWhereOrNull(((element) => element!.id == json['id']));
      if (t != null) {
        return t;
      }
    }
    if (json['id'] != null && json['numberStart'] == null) {
      final Team placeholder = Team(false, 0, null, isPlaceHolder: true);
      placeholder.id = json['id'] as String;
      return placeholder;
    }

    final Team team = Team(json['isPlayer'] as bool?, json['numberStart'] as int?, spriteManager);
    team.id = json['id'] as String;
    existingTeams.add(team);
    if (json['cyclists'] != null) {
      for (final j in (json['cyclists'] as List)) {
        team.cyclists.add(Cyclist.fromJson(j as Map<String, dynamic>, existingCyclists, existingTeams, spriteManager));
      }
    }
    return team;
  }

  Map<String, dynamic> toJson(bool idOnly) {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (!idOnly) {
      data['isPlayer'] = isPlayer;
      data['numberStart'] = numberStart;
      data['cyclists'] = cyclists.map((i) => i!.toJson(false)).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Team && other.numberStart == numberStart;
  }

  @override
  int get hashCode => numberStart.hashCode;
}
