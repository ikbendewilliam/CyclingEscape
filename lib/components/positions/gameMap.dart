import 'dart:ui';

import 'position.dart';
import 'sprint.dart';

class GameMap {
  final List<Position> positions;
  final List<Sprint> sprints;
  Size mapSize;
  Size minMapSize;

  GameMap(this.positions, this.sprints) {
    mapSize = Size(0, 0);
    positions.forEach((position) {
      if (mapSize.width < position.p1.dx) {
        mapSize = Size(position.p1.dx + 20, mapSize.height);
      }
      if (mapSize.height < position.p1.dy) {
        mapSize = Size(mapSize.width, position.p1.dy + 20);
      }
    });
    minMapSize = Size(mapSize.width, mapSize.height);
    positions.forEach((position) {
      if (minMapSize.width > position.p1.dx) {
        minMapSize = Size(position.p1.dx - 20, minMapSize.height);
      }
      if (minMapSize.height > position.p1.dy) {
        minMapSize = Size(minMapSize.width, position.p1.dy - 20);
      }
    });
    positions.forEach((position) {
      position.p1 -= Offset(minMapSize.width, minMapSize.height);
      position.p2 -= Offset(minMapSize.width, minMapSize.height);
    });
    sprints.forEach((sprint) {
      sprint.offset -= Offset(minMapSize.width, minMapSize.height);
    });
    mapSize = Size(
        mapSize.width - minMapSize.width, mapSize.height - minMapSize.height);
  }

  void render(Canvas c, double tileSize, Offset center, double screenRange) {
    positions
        .forEach((element) => element.render(c, tileSize, center, screenRange));
    sprints.forEach((element) => element.render(c, tileSize));
    positions.forEach((element) => element.renderText(
        c, tileSize, center, screenRange)); // Later so it is above the rest
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

  // static GameMap fromJson(Map<String, dynamic> json) {
  //   var positions = new List<Position>();
  //   if (json['positions'] != null) {
  //     json['positions'].forEach((v) {
  //       positions.add(new Position.fromJson(v));
  //     });
  //   }
  //   var sprints = new List<Sprint>();
  //   if (json['sprints'] != null) {
  //     json['sprints'].forEach((v) {
  //       sprints.add(new Sprint.fromJson(v));
  //     });
  //   }
  //   return GameMap(positions, sprints);
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.positions != null) {
  //     data['positions'] = this.positions.map((v) => v.toJson()).toList();
  //   }
  //   if (this.sprints != null) {
  //     data['sprints'] = this.sprints.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}
