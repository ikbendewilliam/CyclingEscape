import 'package:collection/collection.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';

extension SprintCalculator on List<Sprint> {
  List<Results> calculateResults({Results? currentResults}) {
    for (final sprint in this) {
      sprint.cyclistPlaces.sort((a, b) => (b!.value! - a!.value!).round());
    }
    final Results raceResults = Results(ResultsType.race);
    final Sprint? finish = firstWhereOrNull(((element) => element.type == SprintType.finish));
    if (finish != null) {
      finish.cyclistPlaces.asMap().forEach((i, element) {
        final int points = finish.getPoints(i);
        raceResults.data.add(ResultData(i, element!.getTurns(), points, 0, element.cyclist!.number, element.cyclist!.team));
      });
    }
    where((element) => element.type == SprintType.sprint || element.type == SprintType.mountainSprint).toList().forEach((sprint) {
      sprint.cyclistPlaces.asMap().forEach((i, element) {
        final int points = sprint.getPoints(i);
        if (sprint.type == SprintType.sprint && points > 0) {
          final ResultData data = raceResults.data.firstWhere((result) => result!.number == element!.cyclist!.number)!;
          data.points += points;
        } else if (sprint.type == SprintType.mountainSprint && points > 0) {
          final ResultData data = raceResults.data.firstWhere((result) => result!.number == element!.cyclist!.number)!;
          data.mountain += points;
        }
      });
    });
    final results = [raceResults];

    if (currentResults != null) {
      for (final result in raceResults.data) {
        ResultData? currentResult = currentResults.data.firstWhereOrNull(((element) => element!.number == result!.number));
        if (currentResult == null) {
          currentResult = ResultData(result!.rank, 0, 0, 0, result.number, result.team);
          currentResults.data.add(currentResult);
        }
        currentResult.time += result!.time;
        currentResult.points += result.points;
        currentResult.mountain += result.mountain;
      }
      currentResults.data.sort((a, b) => a!.time - b!.time);
    }

    final Results timeResults = Results(ResultsType.time);
    timeResults.data = currentResults?.data ?? raceResults.data;
    results.add(timeResults);

    final Results youngResults = Results(ResultsType.young);
    youngResults.data = timeResults.data.where((element) => element!.number % 10 <= 2).map((e) => e!.copy()).toList();
    youngResults.data.sort((a, b) => a!.time - b!.time);
    if (youngResults.data.isNotEmpty && currentResults != null) {
      currentResults.whiteJersey = youngResults.data.first!.number;
    }
    results.add(youngResults);

    final Results pointsResults = Results(ResultsType.points);
    pointsResults.data = timeResults.data.where((element) => element!.points > 0).map((e) => e!.copy()).toList();
    pointsResults.data.sort((a, b) => b!.points - a!.points);
    if (youngResults.data.isNotEmpty && currentResults != null) {
      currentResults.greenJersey = pointsResults.data.first!.number;
    }
    results.add(pointsResults);

    final Results mountainResults = Results(ResultsType.mountain);
    mountainResults.data = timeResults.data.where((element) => element!.mountain > 0).map((e) => e!.copy()).toList();
    mountainResults.data.sort((a, b) => b!.mountain - a!.mountain);
    if (mountainResults.data.isNotEmpty && currentResults != null) {
      currentResults.bouledJersey = mountainResults.data.first!.number;
    }
    results.add(mountainResults);

    final Results teamResults = Results(ResultsType.team);
    final List<Team?> teams = timeResults.data.map((element) => element!.team).toList();
    for (final team in teams) {
      if (teamResults.data.where((element) => element!.team == team).isEmpty) {
        final ResultData resultData = ResultData();
        timeResults.data.where((element) => element!.team == team).forEach((element) => resultData.time += element!.time);
        resultData.team = team;
        teamResults.data.add(resultData);
      }
    }
    teamResults.data.sort((a, b) => a!.time - b!.time);
    results.add(teamResults);

    for (final result in results) {
      result.data.asMap().forEach((rank, value) => value = ResultData(rank, value!.time, value.points, value.mountain, value.number, value.team));
    }

    // if (activeTour != null) {
    //   SaveUtil.saveTour(;
    // }
    return results;
  }
}
