import 'package:CyclingEscape/utils/mapUtils.dart';
import 'package:CyclingEscape/views/menus/tourSelect.dart';

class PlaySettings {
  final int teams;
  final int ridersPerTeam;
  final MapType mapType;
  final MapLength mapLength;

  PlaySettings(this.teams, this.ridersPerTeam, this.mapType, this.mapLength);

  static PlaySettings fromTour(Tour tour) {
    return PlaySettings(tour.teams, tour.ridersPerTeam, tour.mapType, tour.mapLength);
  }
}
