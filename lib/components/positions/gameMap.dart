import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/moveable/cyclist.dart';

import 'foiliage.dart';
import 'position.dart';
import 'sprint.dart';

class GameMap {
  final List<Position> positions;
  final List<Sprint> sprints;
  final List<Foiliage> foiliage = [];
  Size mapSize;
  Size minMapSize;

  GameMap(this.positions, this.sprints, SpriteManager spriteManager,
      {createFoiliage: true}) {
    mapSize = Size(0, 0);
    positions.forEach((position) {
      if (mapSize.width < position.p1.dx) {
        mapSize = Size(position.p1.dx, mapSize.height);
      }
      if (mapSize.height < position.p1.dy) {
        mapSize = Size(mapSize.width, position.p1.dy);
      }
    });
    minMapSize = Size(mapSize.width, mapSize.height);
    positions.forEach((position) {
      if (minMapSize.width > position.p1.dx) {
        minMapSize = Size(position.p1.dx, minMapSize.height);
      }
      if (minMapSize.height > position.p1.dy) {
        minMapSize = Size(minMapSize.width, position.p1.dy);
      }
    });
    minMapSize = Size(minMapSize.width - 50, minMapSize.height - 50);
    mapSize = Size(mapSize.width + 100, mapSize.height + 100);

    positions.forEach((position) {
      position.p1 -= Offset(minMapSize.width, minMapSize.height);
      position.p2 -= Offset(minMapSize.width, minMapSize.height);
    });
    sprints.forEach((sprint) {
      sprint.offset -= Offset(minMapSize.width, minMapSize.height);
    });
    mapSize = Size(
        mapSize.width - minMapSize.width, mapSize.height - minMapSize.height);

    if (createFoiliage) {
      doCreateFoiliage(spriteManager);
    }
  }

  doCreateFoiliage(SpriteManager spriteManager) {
    int foiliageCount = (mapSize.width * mapSize.height / 100).floor();
    List<FoiliageType> types = [
      FoiliageType.ROCK_1,
      FoiliageType.ROCK_2,
      FoiliageType.ROCK_3,
      FoiliageType.ROCK_1,
      FoiliageType.ROCK_2,
      FoiliageType.ROCK_3,
      FoiliageType.ROCK_1,
      FoiliageType.ROCK_2,
      FoiliageType.ROCK_3,
      FoiliageType.TENT_BLUE_1,
      FoiliageType.TENT_BLUE_2,
      FoiliageType.TENT_RED_1,
      FoiliageType.TENT_RED_2,
      FoiliageType.TREE_1,
      FoiliageType.TREE_2,
      FoiliageType.TREE_1,
      FoiliageType.TREE_2,
      FoiliageType.TREE_1,
      FoiliageType.TREE_2,
      FoiliageType.TREE_1,
      FoiliageType.TREE_2,
      FoiliageType.TREE_1,
      FoiliageType.TREE_2,
      FoiliageType.TREE_1,
      FoiliageType.TREE_2,
    ];
    for (int i = 0; i < foiliageCount; i++) {
      Offset offset = Offset(Random().nextDouble() * mapSize.width,
          Random().nextDouble() * mapSize.height);
      if (isFree(offset)) {
        double size = (Random().nextInt(3) + 2.0);
        double angle = Random().nextDouble() * pi * 2;
        FoiliageType type = types[Random().nextInt(types.length)];
        foiliage.add(Foiliage(offset, size, type, spriteManager, angle));
      }
    }
    double size = 3;
    sprints.forEach((element) {
      if (element.type == SprintType.FINISH ||
          element.type == SprintType.START ||
          Random().nextBool()) {
        Offset offset = element.offset +
            Offset(sin(element.angle) * (element.width + 2),
                cos(element.angle) * (element.width + 2));
        foiliage.add(Foiliage(offset, size, FoiliageType.TRIBUNE, spriteManager,
            -element.angle + pi));
      }
      if (element.type == SprintType.FINISH ||
          element.type == SprintType.START ||
          Random().nextBool()) {
        Offset offset = element.offset -
            Offset(sin(element.angle) * 3, cos(element.angle) * 3);
        foiliage.add(Foiliage(
            offset, size, FoiliageType.TRIBUNE, spriteManager, -element.angle));
      }
      if (element.type == SprintType.FINISH) {
        Offset offset = element.offset +
            Offset(sin(element.angle) * (element.width + 2),
                cos(element.angle) * (element.width + 2));
        Offset offset2 = element.offset -
            Offset(sin(element.angle) * 3, cos(element.angle) * 3);

        for (int i = 0; i < 4; i++) {
          offset += Offset(cos(element.angle) * 6, -sin(element.angle) * 6);
          foiliage.add(Foiliage(offset, size, FoiliageType.TRIBUNE,
              spriteManager, -element.angle + pi));
          offset2 += Offset(cos(element.angle) * 6, -sin(element.angle) * 6);
          foiliage.add(Foiliage(offset2, size, FoiliageType.TRIBUNE,
              spriteManager, -element.angle));
        }
      }
    });
  }

  bool isFree(Offset offset) {
    for (var element in this.positions) {
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
    positions
        .forEach((element) => element.render(c, tileSize, center, screenRange));
    sprints.forEach((element) => element.render(c, tileSize));
    positions.forEach((element) => element.renderText(
        c, tileSize, center, screenRange)); // Later so it is above the rest
    foiliage.forEach((element) =>
        element.render(c, tileSize, center, screenRange, DrawHeight.BOTTOM));
    foiliage.forEach((element) =>
        element.render(c, tileSize, center, screenRange, DrawHeight.MIDDLE));
    foiliage.forEach((element) =>
        element.render(c, tileSize, center, screenRange, DrawHeight.TOP));
  }

  void update(double t) {
    positions.forEach((element) => element.update(t));
  }

  void clickedEvent(Offset clickedEvent) {
    positions.forEach((element) => element.clickedEvent(clickedEvent));
  }

  void setState(state) {
    positions.forEach((element) {
      element.setState(state);
    });
  }

  static GameMap fromJson(
      Map<String, dynamic> json,
      List<Position> existingPositions,
      List<Sprint> existingSprints,
      List<Cyclist> existingCyclists,
      List<Team> existingTeams,
      SpriteManager spriteManager,
      PositionListener listener) {
    var positions = json['positions']?.map((v) => Position.fromJson(
        v,
        existingPositions,
        existingSprints,
        existingCyclists,
        existingTeams,
        spriteManager,
        listener));
    var sprints =
        json['sprints']?.map((v) => Sprint.fromJson(v, existingSprints));
    return GameMap(positions, sprints, spriteManager, createFoiliage: false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['positions'] = [];
    if (this.positions != null) {
      this.positions.forEach((v) => data['positions'].add(v.toJson(false)));
    }
    data['sprints'] = this.sprints?.map((v) => v.toJson(true));
    data['foiliage'] = this.foiliage?.map((v) => v.toJson());
    return data;
  }
}
