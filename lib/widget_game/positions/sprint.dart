import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/cyclistPlace.dart';
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
    this.isPlaceHolder = false,
  });

  void render(Canvas canvas, double tileSize) {
    final Paint paint = Paint()
      ..color = getColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = tileSize / 3;
    canvas.drawLine(Offset((offset.dx - sin(angle) / 2 + cos(angle) / 6) * tileSize, (offset.dy - cos(angle) / 2 - sin(angle) / 6) * tileSize),
        Offset((offset.dx + sin(angle) * (width - 1 / 2) + cos(angle) / 6) * tileSize, (offset.dy + cos(angle) * (width - 1 / 2) - sin(angle) / 6) * tileSize), paint);
  }

  void addCyclistPlace(CyclistPlace cyclistPlace) {
    cyclistPlaces.add(cyclistPlace);
    // print('$type (${cyclistPlaces.length})');
  }

  Color getColor() {
    switch (type) {
      case SprintType.sprint:
        return Colors.green;
      case SprintType.mountainSprint:
        return Colors.red;
      case SprintType.start:
      case SprintType.finish:
      default:
        return Colors.white;
    }
  }

  int getPoints(int rank) {
    if (type == SprintType.finish) {
      if (rank == 0) {
        return 10;
      } else if (rank == 1) {
        return 7;
      } else if (rank < 7) {
        return 7 - rank;
      }
      return 0;
    } else if (type == SprintType.sprint || type == SprintType.mountainSprint) {
      if (rank == 0) {
        return 5;
      } else if (rank < 4) {
        return 4 - rank;
      }
      return 0;
    }
    return 0;
  }

  String getPointsName() {
    switch (type) {
      case SprintType.sprint:
        return 'p';
      case SprintType.mountainSprint:
        return 'mp';
      default:
        return '';
    }
  }

  static Sprint? fromJson(Map<String, dynamic>? json, List<Sprint?> existingSprints) {
    if (json == null) {
      return null;
    }
    if (existingSprints.isNotEmpty) {
      final Sprint? c = existingSprints.firstWhereOrNull(((element) => element!.id == json['id']));
      if (c != null) {
        return c;
      }
    }
    if (json['id'] != null && json['segment'] == null) {
      final Sprint placeholder = Sprint(SprintType.start, Offset.zero, 1, 0, 0, isPlaceHolder: true);
      placeholder.id = json['id'] as String;
      return placeholder;
    }
    final Sprint sprint = Sprint(
      getSprintTypeFromString(json['type'] as String?),
      SaveUtil.offsetFromJson(json['offset'] as Map<String, dynamic>?)!,
      json['width'] as int,
      json['angle'] as double,
      json['segment'] as int,
    );
    sprint.id = json['id'] as String;
    existingSprints.add(sprint);
    sprint.offset = SaveUtil.offsetFromJson(json['offset'] as Map<String, dynamic>?)!;
    for (final p in (json['cyclistPlaces'] as List)) {
      sprint.cyclistPlaces.add(CyclistPlace.fromJson(p as Map<String, dynamic>));
    }
    return sprint;
  }

  Map<String, dynamic> toJson(bool idOnly) {
    final data = <String, dynamic>{};
    data['id'] = id;
    if (!idOnly) {
      data['type'] = type.toString();
      data['offset'] = SaveUtil.offsetToJson(offset);
      data['width'] = width;
      data['angle'] = angle;
      data['segment'] = segment;
      data['offset'] = SaveUtil.offsetToJson(offset);
      data['cyclistPlaces'] = cyclistPlaces.map((p) => p?.toJson()).toList();
    }
    return data;
  }
}

SprintType getSprintTypeFromString(String? sprintTypeAsString) {
  for (final SprintType element in SprintType.values) {
    if (element.toString() == sprintTypeAsString) {
      return element;
    }
  }
  throw Exception("invalid Sprinttype $sprintTypeAsString");
}

enum SprintType { start, sprint, mountainSprint, finish }
