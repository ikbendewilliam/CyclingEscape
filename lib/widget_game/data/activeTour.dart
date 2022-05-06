import 'package:cycling_escape/screen_game/menus/careerMenu.dart';
import 'package:cycling_escape/screen_game/menus/tourSelect.dart';
import 'package:cycling_escape/screen_game/resultsView.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:cycling_escape/widget_game/data/spriteManager.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/moveable/cyclist.dart';
import 'package:flutter/material.dart';

class ActiveTour {
  final Tour? tour;
  String? id = UniqueKey().toString();
  RaceType? raceType;
  int racesDone = 0;
  Results? currentResults = Results(ResultsType.tour);
  List<Team?>? teams;
  List<Cyclist?> cyclists = [];

  ActiveTour(this.tour, this.raceType);

  static ActiveTour fromJson(Map<String, dynamic> json, SpriteManager spriteManager) {
    final ActiveTour activeTour = ActiveTour(json['tour'] != null ? Tour.fromJson(json['tour'] as Map<String, dynamic>) : null,
        json['raceType'] != null ? RaceType.fromJson(json['raceType'] as Map<String, dynamic>?) : null);
    activeTour.id = json['id'] as String;
    activeTour.racesDone = json['racesDone'] as int;
    final List<Team?> existingTeams = [];
    final List<Cyclist?> existingCyclists = [];
    if (json['currentResults'] != null) {
      activeTour.currentResults = Results.fromJson(json['currentResults'] as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager);
    }
    if (json['teams'] != null) {
      activeTour.teams = [];
      for (final j in (json['teams'] as List)) {
        activeTour.teams!.add(Team.fromJson(j as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager));
      }
    }
    if (json['cyclists'] != null) {
      activeTour.cyclists = [];
      for (final j in (json['cyclists'] as List)) {
        activeTour.cyclists.add(Cyclist.fromJson(j as Map<String, dynamic>?, existingCyclists, existingTeams, spriteManager));
      }
    }

    for (final element in activeTour.currentResults!.data) {
      if (element!.team!.isPlaceHolder) {
        element.team = existingTeams.firstWhere((existing) => existing!.id == element.team!.id, orElse: () => element.team);
      }
    }
    for (final element in existingCyclists) {
      if (element!.team!.isPlaceHolder) {
        element.team = existingTeams.firstWhere((existing) => existing!.id == element.team!.id, orElse: () => element.team);
      }
    }
    for (final team in existingTeams) {
      for (int i = 0; i < team!.cyclists.length; i++) {
        if (team.cyclists[i]!.isPlaceHolder) {
          team.cyclists[i] = existingCyclists.firstWhere((existing) => existing!.id == team.cyclists[i]!.id, orElse: () => team.cyclists[i]);
        }
      }
    }

    return activeTour;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['tour'] = tour!.toJson();
    data['racesDone'] = racesDone;
    data['currentResults'] = currentResults!.toJson();
    data['teams'] = teams?.map((i) => i!.toJson(false)).toList();
    data['cyclists'] = cyclists.map((i) => i!.toJson(false)).toList();
    data['raceType'] = raceType?.toJson();
    return data;
  }
}
