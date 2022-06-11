import 'dart:convert';

import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/widget_game/data/results.dart';

class PlaySettings {
  final int teams;
  final int ridersPerTeam;
  final MapType mapType;
  final MapLength mapLength;
  final int? totalRaces;
  Results? tourResults;
  final bool loadGame;
  bool isCareer = false;

  PlaySettings(
    this.teams,
    this.ridersPerTeam,
    this.mapType,
    this.mapLength,
    this.tourResults, [
    this.totalRaces = 1,
    this.isCareer = false,
  ]) : loadGame = false;

  PlaySettings.load()
      : loadGame = true,
        teams = 1,
        ridersPerTeam = 1,
        mapType = MapType.flat,
        mapLength = MapLength.short,
        tourResults = null,
        totalRaces = null;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'teams': teams,
        'ridersPerTeam': ridersPerTeam,
        'mapType': mapType.toString(),
        'mapLength': mapLength.toString(),
        'totalRaces': totalRaces,
        'isCareer': isCareer,
      };

  factory PlaySettings.fromMap(Map<String, dynamic> map) {
    return PlaySettings(
      map['teams'] as int,
      map['ridersPerTeam'] as int,
      MapType.fromMap(map['mapType'] as String),
      MapLength.fromMap(map['mapLength'] as String),
      null,
      map['totalRaces'] as int,
      map['isCareer'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaySettings.fromJson(String source) => PlaySettings.fromMap(json.decode(source) as Map<String, dynamic>);
}
