import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:flutter/material.dart';

class ResultData {
  int rank = 0;
  int time = 0;
  int number = 0;
  Team team;
  int points = 0;
  int mountain = 0;
  double value;
  String id = UniqueKey().toString();

  ResultData(
      [this.rank,
      this.time,
      this.points,
      this.mountain,
      this.number,
      this.team,
      this.value]) {
    if (rank == null) {
      rank = 0;
    }
    if (time == null) {
      time = 0;
    }
    if (number == null) {
      number = 0;
    }
    if (points == null) {
      points = 0;
    }
    if (mountain == null) {
      mountain = 0;
    }
  }

  ResultData copy() {
    return ResultData(this.rank, this.time, this.points, this.mountain,
        this.number, this.team);
  }

  static ResultData fromJson(
      Map<String, dynamic> json,
      List<Cyclist> existingCyclists,
      List<Team> existingTeams,
      SpriteManager spriteManager) {
    ResultData results = ResultData(
      json['rank'],
      json['time'],
      json['points'],
      json['mountain'],
      json['number'],
      json['team'] != null
          ? Team.fromJson(
              json['team'], existingCyclists, existingTeams, spriteManager)
          : null,
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
    data['team'] = this.team != null ? this.team.toJson(true) : null;
    data['value'] = this.value;
    return data;
  }
}
