import 'dart:math';
import 'dart:ui';

import 'package:cycling_escape/components/data/cyclistPlace.dart';
import 'package:cycling_escape/utils/saveUtil.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Sprint {
  final SprintType type;
  final double angle;
  final int segment;
  final int width;
  final List<CyclistPlace?> cyclistPlaces = [];
  bool isPlaceHolder;
  String id = UniqueKey().toString();

  Offset offset;

  Sprint(
    this.type,
    this.offset,
    this.width,
    this.angle,
    this.segment, {
    this.isPlaceHolder: false,
  });

  void render(Canvas canvas, tileSize) {
    Paint paint = Paint()
      ..color = getColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize / 3;
    canvas.drawLine(Offset((offset.dx - sin(angle) / 2 + cos(angle) / 6) * tileSize, (offset.dy - cos(angle) / 2 - sin(angle) / 6) * tileSize),
        Offset((offset.dx + sin(angle) * (width - 1 / 2) + cos(angle) / 6) * tileSize, (offset.dy + cos(angle) * (width - 1 / 2) - sin(angle) / 6) * tileSize), paint);
  }

  addCyclistPlace(CyclistPlace cyclistPlace) {
    cyclistPlaces.add(cyclistPlace);
    // print('$type (${cyclistPlaces.length})');
  }

  Color getColor() {
    switch (type) {
      case SprintType.SPRINT:
        return Colors.green;
      case SprintType.MOUNTAIN_SPRINT:
        return Colors.red;
      case SprintType.START:
      case SprintType.FINISH:
      default:
        return Colors.white;
    }
  }

  int getPoints(int rank) {
    if (type == SprintType.FINISH) {
      if (rank == 0) {
        return 10;
      } else if (rank == 1) {
        return 7;
      } else if (rank < 7) {
        return 7 - rank;
      }
      return 0;
    } else if (type == SprintType.SPRINT || type == SprintType.MOUNTAIN_SPRINT) {
      if (rank == 0) {
        return 5;
      } else if (rank < 4) {
        return 4 - rank;
      }
      return 0;
    }
    return 0;
  }

  getPointsName() {
    switch (type) {
      case SprintType.SPRINT:
        return 'p';
      case SprintType.MOUNTAIN_SPRINT:
        return 'mp';
      default:
        return '';
    }
  }

  static Sprint? fromJson(Map<String, dynamic>? json, List<Sprint?> existingSprints) {
    if (json == null) {
      return null;
    }
    if (existingSprints.length > 0) {
      Sprint? c = existingSprints.firstWhereOrNull(((element) => element!.id == json['id']));
      if (c != null) {
        return c;
      }
    }
    if (json['id'] != null && json['segment'] == null) {
      Sprint placeholder = Sprint(SprintType.START, Offset(0, 0), 1, 0, 0, isPlaceHolder: true);
      placeholder.id = json['id'];
      return placeholder;
    }
    Sprint sprint = Sprint(
      getSprintTypeFromString(json['type']),
      SaveUtil.offsetFromJson(json['offset'])!,
      json['width'],
      json['angle'],
      json['segment'],
    );
    sprint.id = json['id'];
    existingSprints.add(sprint);
    sprint.offset = SaveUtil.offsetFromJson(json['offset'])!;
    json['cyclistPlaces'].forEach((p) => sprint.cyclistPlaces.add(CyclistPlace.fromJson(p)));
    return sprint;
  }

  Map<String, dynamic> toJson(bool idOnly) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (!idOnly) {
      data['type'] = this.type.toString();
      data['offset'] = SaveUtil.offsetToJson(this.offset);
      data['width'] = this.width;
      data['angle'] = this.angle;
      data['segment'] = this.segment;
      data['offset'] = SaveUtil.offsetToJson(this.offset);
      data['cyclistPlaces'] = [];
      this.cyclistPlaces.forEach((v) => data['cyclistPlaces'].add(v!.toJson()));
    }
    return data;
  }
}

SprintType getSprintTypeFromString(String? sprintTypeAsString) {
  for (SprintType element in SprintType.values) {
    if (element.toString() == sprintTypeAsString) {
      return element;
    }
  }
  throw Exception("invalid Sprinttype $sprintTypeAsString");
}

enum SprintType { START, SPRINT, MOUNTAIN_SPRINT, FINISH }
