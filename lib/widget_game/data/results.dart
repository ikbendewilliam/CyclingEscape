import 'package:cycling_escape/screen_game/resultsView.dart';
import 'package:cycling_escape/widget_game/data/resultData.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/moveable/cyclist.dart';
import 'package:flutter/material.dart';

class Results {
  final ResultsType? type;
  List<ResultData?> data = [];
  int? whiteJersey;
  int? greenJersey;
  int? bouledJersey;
  String? id = UniqueKey().toString();

  Results(this.type, [List<ResultData?>? data, this.whiteJersey, this.greenJersey, this.bouledJersey]) {
    if (data != null) this.data = data;
  }

  Results copy() {
    return Results(type, data.toList(), whiteJersey, greenJersey, bouledJersey);
  }

  static Results? fromJson(Map<String, dynamic>? json, List<Cyclist?> existingCyclists, List<Team?> existingTeams, SpriteManager spriteManager) {
    if (json == null) {
      return null;
    }
    final Results results = Results(
      getResultsTypeFromString(json['type'] as String?),
      <ResultData>[],
      json['whiteJersey'] as int?,
      json['greenJersey'] as int?,
      json['bouledJersey'] as int?,
    );
    results.id = json['id'] as String;
    if (json['data'] != null) {
      for (final j in (json['data'] as List)) {
        results.data.add(ResultData.fromJson(j as Map<String, dynamic>, existingCyclists, existingTeams, spriteManager));
      }
    }
    return results;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['teams'] = type.toString();
    data['data'] = this.data.map((i) => i!.toJson()).toList();
    data['whiteJersey'] = whiteJersey;
    data['greenJersey'] = greenJersey;
    data['bouledJersey'] = bouledJersey;
    return data;
  }
}
