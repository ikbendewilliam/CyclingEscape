import 'package:CyclingEscape/components/data/resultData.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:CyclingEscape/views/resultsView.dart';
import 'package:flutter/material.dart';

class Results {
  final ResultsType type;
  List<ResultData> data = [];
  int whiteJersey;
  int greenJersey;
  int bouledJersey;
  String id = UniqueKey().toString();

  Results(this.type,
      [data, this.whiteJersey, this.greenJersey, this.bouledJersey]) {
    if (data != null) {
      this.data = data;
    }
  }

  Results copy() {
    return Results(type, data.toList(), whiteJersey, greenJersey, bouledJersey);
  }

  static Results fromJson(
      Map<String, dynamic> json,
      List<Cyclist> existingCyclists,
      List<Team> existingTeams,
      SpriteManager spriteManager) {
    if (json == null) {
      return null;
    }
    Results results = Results(
      getResultsTypeFromString(json['type']),
      List<ResultData>(),
      json['whiteJersey'],
      json['greenJersey'],
      json['bouledJersey'],
    );
    results.id = json['id'];
    if (json['data'] != null) {
      json['data'].forEach((j) {
        results.data.add(ResultData.fromJson(
            j, existingCyclists, existingTeams, spriteManager));
      });
    }
    return results;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teams'] = this.type.toString();
    data['data'] =
        this.data != null ? this.data.map((i) => i.toJson()).toList() : null;
    data['whiteJersey'] = this.whiteJersey;
    data['greenJersey'] = this.greenJersey;
    data['bouledJersey'] = this.bouledJersey;
    return data;
  }
}
