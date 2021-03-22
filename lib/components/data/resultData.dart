import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:flutter/material.dart';

class ResultData {
  int rank = 0;
  int time = 0;
  int number = 0;
  Team? team;
  int points = 0;
  int mountain = 0;
  double? value;
  String? id = UniqueKey().toString();

  ResultData([this.rank = 0, this.time = 0, this.points = 0, this.mountain = 0, this.number = 0, this.team, this.value]);

  ResultData copy() => ResultData(this.rank, this.time, this.points, this.mountain, this.number, this.team);

  static ResultData fromJson(Map<String, dynamic> json, List<Cyclist?> existingCyclists, List<Team?> existingTeams, SpriteManager spriteManager) {
    ResultData results = ResultData(
      json['rank'],
      json['time'],
      json['points'],
      json['mountain'],
      json['number'],
      json['team'] != null ? Team.fromJson(json['team'], existingCyclists, existingTeams, spriteManager) : null,
      json['value'],
    );
    results.id = json['id'];
    return results;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rank'] = this.rank;
    data['time'] = this.time;
    data['points'] = this.points;
    data['mountain'] = this.mountain;
    data['number'] = this.number;
    data['team'] = this.team?.toJson(true);
    data['value'] = this.value;
    return data;
  }
}
