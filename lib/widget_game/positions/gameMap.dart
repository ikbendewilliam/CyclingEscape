import 'dart:math';
import 'dart:ui';

import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/moveable/cyclist.dart';

import 'foiliage.dart';
import 'position.dart';
import 'sprint.dart';

class GameMap {
  final List<Position>? positions;
  final List<Sprint>? sprints;
  List<Foiliage>? foiliage = [];
  Size? mapSize;
  late Size minMapSize;

  GameMap(this.positions, this.sprints, SpriteManager spriteManager, {bool createFoiliage = true}) {
    mapSize = const Size(0, 0);
    for (final position in positions!) {
      if (mapSize!.width < position.p1.dx) {
        mapSize = Size(position.p1.dx, mapSize!.height);
      }
      if (mapSize!.height < position.p1.dy) {
        mapSize = Size(mapSize!.width, position.p1.dy);
      }
    }
    minMapSize = Size(mapSize!.width, mapSize!.height);
    for (final position in positions!) {
      if (minMapSize.width > position.p1.dx) {
        minMapSize = Size(position.p1.dx, minMapSize.height);
      }
      if (minMapSize.height > position.p1.dy) {
        minMapSize = Size(minMapSize.width, position.p1.dy);
      }
    }
    minMapSize = Size(minMapSize.width - 50, minMapSize.height - 50);
    mapSize = Size(mapSize!.width + 100, mapSize!.height + 100);

    for (final position in positions!) {
      position.p1 -= Offset(minMapSize.width, minMapSize.height);
      position.p2 -= Offset(minMapSize.width, minMapSize.height);
    }
    for (final sprint in sprints!) {
      sprint.offset -= Offset(minMapSize.width, minMapSize.height);
    }
    mapSize = Size(mapSize!.width - minMapSize.width, mapSize!.height - minMapSize.height);

    if (createFoiliage) {
      doCreateFoiliage(spriteManager);
    }
  }

  void doCreateFoiliage(SpriteManager spriteManager) {
    final int foiliageCount = (mapSize!.width * mapSize!.height / 100).floor();
    final List<FoiliageType> types = [
      FoiliageType.rock1,
      FoiliageType.rock2,
      FoiliageType.rock3,
      FoiliageType.rock1,
      FoiliageType.rock2,
      FoiliageType.rock3,
      FoiliageType.rock1,
      FoiliageType.rock2,
      FoiliageType.rock3,
      FoiliageType.tentBlue1,
      FoiliageType.tentBlue2,
      FoiliageType.tentRed1,
      FoiliageType.tentRed2,
      FoiliageType.tree1,
      FoiliageType.tree2,
      FoiliageType.tree1,
      FoiliageType.tree2,
      FoiliageType.tree1,
      FoiliageType.tree2,
      FoiliageType.tree1,
      FoiliageType.tree2,
      FoiliageType.tree1,
      FoiliageType.tree2,
      FoiliageType.tree1,
      FoiliageType.tree2,
    ];
    for (int i = 0; i < foiliageCount; i++) {
      final Offset offset = Offset(Random().nextDouble() * mapSize!.width, Random().nextDouble() * mapSize!.height);
      if (isFree(offset)) {
        final double size = (Random().nextInt(3) + 2.0);
        final double angle = Random().nextDouble() * pi * 2;
        final FoiliageType type = types[Random().nextInt(types.length)];
        foiliage!.add(Foiliage(offset, size, type, spriteManager, angle));
      }
    }
    const double size = 3;
    for (final element in sprints!) {
      if (element.type == SprintType.finish || element.type == SprintType.start || Random().nextBool()) {
        final Offset offset = element.offset + Offset(sin(element.angle) * (element.width + 2), cos(element.angle) * (element.width + 2));
        foiliage!.add(Foiliage(offset, size, FoiliageType.tribune, spriteManager, -element.angle + pi));
      }
      if (element.type == SprintType.finish || element.type == SprintType.start || Random().nextBool()) {
        final Offset offset = element.offset - Offset(sin(element.angle) * 3, cos(element.angle) * 3);
        foiliage!.add(Foiliage(offset, size, FoiliageType.tribune, spriteManager, -element.angle));
      }
      if (element.type == SprintType.finish) {
        Offset offset = element.offset + Offset(sin(element.angle) * (element.width + 2), cos(element.angle) * (element.width + 2));
        Offset offset2 = element.offset - Offset(sin(element.angle) * 3, cos(element.angle) * 3);

        for (int i = 0; i < 4; i++) {
          offset += Offset(cos(element.angle) * 6, -sin(element.angle) * 6);
          foiliage!.add(Foiliage(offset, size, FoiliageType.tribune, spriteManager, -element.angle + pi));
          offset2 += Offset(cos(element.angle) * 6, -sin(element.angle) * 6);
          foiliage!.add(Foiliage(offset2, size, FoiliageType.tribune, spriteManager, -element.angle));
        }
      }
    }
  }

  bool isFree(Offset offset) {
    for (final Position element in positions!) {
      if (distanceSquaredTo(offset, element.p1) < 20) {
        return false;
      }
    }
    return true;
  }

  double distanceSquaredTo(Offset offset1, Offset offset2) {
    // DistanceSquared is cheaper
    return (offset1 - offset2).distanceSquared;
  }

  void render(Canvas c, double tileSize, Offset center, double screenRange) {
    for (final element in positions!) {
      element.render(c, tileSize, center, screenRange);
    }
    for (final element in sprints!) {
      element.render(c, tileSize);
    }
    for (final element in positions!) {
      element.renderText(c, tileSize, center, screenRange);
    } // Later so it is above the rest
    for (final element in foiliage!) {
      element.render(c, tileSize, center, screenRange, DrawHeight.bottom);
    }
    for (final element in foiliage!) {
      element.render(c, tileSize, center, screenRange, DrawHeight.middle);
    }
    for (final element in foiliage!) {
      element.render(c, tileSize, center, screenRange, DrawHeight.top);
    }
  }

  void update(double t) {
    for (final element in positions!) {
      element.update(t);
    }
  }

  void clickedEvent(Offset clickedEvent) {
    for (final element in positions!) {
      element.clickedEvent(clickedEvent);
    }
  }

  void setState(PositionState state) {
    for (final element in positions!) {
      element.setState(state);
    }
  }

  static GameMap? fromJson(Map<String, dynamic>? json, List<Position?> existingPositions, List<Sprint?> existingSprints, List<Cyclist?> existingCyclists, List<Team?> existingTeams,
      SpriteManager spriteManager, PositionListener listener) {
    if (json == null) {
      return null;
    }
    final List<Position>? positions = (json['positions'] as List?)
        ?.map<Position>((dynamic v) => Position.fromJson(v as Map<String, dynamic>?, existingPositions, existingSprints, existingCyclists, existingTeams, spriteManager, listener)!)
        .toList();
    final List<Sprint>? sprints = (json['sprints'] as List?)?.map<Sprint>((dynamic v) => Sprint.fromJson(v as Map<String, dynamic>?, existingSprints)!).toList();
    final GameMap gameMap = GameMap(positions, sprints, spriteManager, createFoiliage: false);
    gameMap.foiliage = (json['foiliage'] as List?)?.map<Foiliage>((dynamic v) => Foiliage.fromJson(v as Map<String, dynamic>, spriteManager)).toList();

    return gameMap;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['positions'] = positions?.map((i) => i.toJson(false)).toList();
    data['sprints'] = sprints?.map((i) => i.toJson(false)).toList();
    data['foiliage'] = foiliage?.map((i) => i.toJson()).toList();
    return data;
  }
}
