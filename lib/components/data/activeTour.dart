import 'package:CyclingEscape/components/data/resultData.dart';
import 'package:CyclingEscape/components/data/results.dart';
import 'package:CyclingEscape/components/data/team.dart';
import 'package:CyclingEscape/components/moveable/cyclist.dart';
import 'package:CyclingEscape/views/menus/tourSelect.dart';
import 'package:CyclingEscape/views/resultsView.dart';

class ActiveTour {
  final Tour tour;
  int racesDone = 0;
  Results currentResults = Results(ResultsType.TOUR);
  List<Team> teams;
  List<Cyclist> cyclists = [];

  ActiveTour(this.tour);
}
