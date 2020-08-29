import 'package:CyclingEscape/components/data/results.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:CyclingEscape/views/menus/careerMenu.dart';
import 'package:CyclingEscape/views/menus/tourSelect.dart';
import 'package:CyclingEscape/views/resultsView.dart';
import 'package:flutter/material.dart';

class ActiveTour {
  final Tour tour;
  String id = UniqueKey().toString();
  RaceType raceType;
  int racesDone = 0;
  Results currentResults = Results(ResultsType.TOUR);
  List<Team> teams;
  List<Cyclist> cyclists = [];

  ActiveTour(this.tour, this.raceType);

  static ActiveTour fromJson(
      Map<String, dynamic> json, SpriteManager spriteManager) {
    ActiveTour activeTour = ActiveTour(
        json['tour'] != null ? Tour.fromJson(json['tour']) : null,
        json['raceType'] != null ? RaceType.fromJson(json['raceType']) : null);
    activeTour.id = json['id'];
    activeTour.racesDone = json['racesDone'];
    List<Team> existingTeams = [];
    List<Cyclist> existingCyclists = [];
    if (json['currentResults'] != null) {
      activeTour.currentResults = Results.fromJson(json['currentResults'],
          existingCyclists, existingTeams, spriteManager);
    }
    if (json['teams'] != null) {
      activeTour.teams = [];
      json['teams'].forEach((j) {
        activeTour.teams.add(
            Team.fromJson(j, existingCyclists, existingTeams, spriteManager));
      });
    }
    if (json['cyclists'] != null) {
      activeTour.cyclists = [];
      json['cyclists'].forEach((j) {
        activeTour.cyclists.add(Cyclist.fromJson(
            j, existingCyclists, existingTeams, spriteManager));
      });
    }

    activeTour.currentResults.data.forEach((element) {
      if (element.team.isPlaceHolder) {
        element.team = existingTeams.firstWhere(
            (existing) => existing.id == element.team.id,
            orElse: () => element.team);
      }
    });
    existingCyclists.forEach((element) {
      if (element.team.isPlaceHolder) {
        element.team = existingTeams.firstWhere(
            (existing) => existing.id == element.team.id,
            orElse: () => element.team);
      }
    });
    existingTeams.forEach((team) {
      for (int i = 0; i < team.cyclists.length; i++) {
        if (team.cyclists[i].isPlaceHolder) {
          team.cyclists[i] = existingCyclists.firstWhere(
              (existing) => existing.id == team.cyclists[i].id,
              orElse: () => team.cyclists[i]);
        }
      }
    });

    return activeTour;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tour'] = this.tour.toJson();
    data['racesDone'] = this.racesDone;
    data['currentResults'] = this.currentResults.toJson();
    data['teams'] = this.teams?.map((i) => i.toJson(false))?.toList();
    data['cyclists'] = this.cyclists?.map((i) => i.toJson(false))?.toList();
    data['raceType'] = this.raceType?.toJson();
    return data;
  }
}
