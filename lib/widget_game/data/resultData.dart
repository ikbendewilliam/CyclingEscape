import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/moveable/cyclist.dart';
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

  ResultData copy() => ResultData(rank, time, points, mountain, number, team);

  static ResultData fromJson(Map<String, dynamic> json, List<Cyclist?> existingCyclists, List<Team?> existingTeams, SpriteManager spriteManager) {
    final results = ResultData(
      json['rank'] as int,
      json['time'] as int,
      json['points'] as int,
      json['mountain'] as int,
      json['number'] as int,
      json['team'] != null ? Team.fromJson(json['team'] as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager) : null,
      json['value'] as double?,
    );
    results.id = json['id'] as String;
    return results;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['rank'] = rank;
    data['time'] = time;
    data['points'] = points;
    data['mountain'] = mountain;
    data['number'] = number;
    data['team'] = team?.toJson(true);
    data['value'] = value;
    return data;
  }
}
