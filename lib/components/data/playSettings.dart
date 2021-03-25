import 'package:cycling_escape/utils/mapUtils.dart';
import 'package:cycling_escape/views/menus/tourSelect.dart';

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
