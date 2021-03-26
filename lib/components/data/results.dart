import 'package:cycling_escape/components/data/resultData.dart';
import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:cycling_escape/components/data/team.dart';
import 'package:cycling_escape/components/moveable/cyclist.dart';
import 'package:cycling_escape/views/resultsView.dart';
import 'package:flutter/material.dart';

class Results {
  final ResultsType? type;
  List<ResultData?> data = [];
  int? whiteJersey;
  int? greenJersey;
  int? bouledJersey;
  String? id = UniqueKey().toString();

  Results(this.type, [data, this.whiteJersey, this.greenJersey, this.bouledJersey]) {
    if (data != null) {
      this.data = data;
    }
  }

  Results copy() {
    return Results(type, data.toList(), whiteJersey, greenJersey, bouledJersey);
  }

  static Results? fromJson(Map<String, dynamic>? json, List<Cyclist?> existingCyclists, List<Team?> existingTeams, SpriteManager spriteManager) {
    if (json == null) {
      return null;
    }
    Results results = Results(
      getResultsTypeFromString(json['type']),
      <ResultData>[],
      json['whiteJersey'],
      json['greenJersey'],
      json['bouledJersey'],
    );
    results.id = json['id'];
    if (json['data'] != null) {
      json['data'].forEach((j) {
        results.data.add(ResultData.fromJson(j, existingCyclists, existingTeams, spriteManager));
      });
    }
    return results;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['teams'] = this.type.toString();
    data['data'] = this.data.map((i) => i!.toJson()).toList();
    data['whiteJersey'] = this.whiteJersey;
    data['greenJersey'] = this.greenJersey;
    data['bouledJersey'] = this.bouledJersey;
    return data;
  }
}
