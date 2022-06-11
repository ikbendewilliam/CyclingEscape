import 'dart:math';

import 'package:collection/collection.dart';
import 'package:cycling_escape/database/career/calendar_results_dao_storage.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/calendar/calendar_repository.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
abstract class CareerRepository {
  @factoryMethod
  factory CareerRepository(
    CareerResultsDaoStorage careerResultsDaoStorage,
    CalendarRepository calendarRepository,
  ) = _CareerRepository;

  Future<void> updateResults(List<Results> results);

  Future<List<ResultData>> get currentResults;

  Future<void> reset();
}

class _CareerRepository implements CareerRepository {
  final CareerResultsDaoStorage _careerResultsDaoStorage;
  final CalendarRepository _calendarRepository;

  _CareerRepository(
    this._careerResultsDaoStorage,
    this._calendarRepository,
  );

  double _getMultiplier(ResultsType? type, bool hasCombined) {
    switch (type) {
      case ResultsType.combined:
      case ResultsType.race:
      case ResultsType.team:
      case null:
        return 0;
      case ResultsType.time:
        return 1;
      case ResultsType.young:
        return 0.1;
      case ResultsType.points:
        return 0.3;
      case ResultsType.mountain:
        return 0.2;
    }
  }

  @override
  Future<void> updateResults(List<Results> results) async {
    final currentResults = await _careerResultsDaoStorage.getAllResults();
    final hasCombined = results.any((element) => element.type == ResultsType.combined);
    final events = await _calendarRepository.calendarEvents;
    final currentEvent = events[_calendarRepository.eventsCompleted];
    final eventPoints = currentEvent.points;
    for (final result in results) {
      final multiplier = _getMultiplier(result.type, hasCombined);
      if (multiplier == 0) continue;
      for (final resultEntry in result.data.asMap().entries) {
        final points = pow(0.8, resultEntry.key) * multiplier * eventPoints;
        var resultData = currentResults.firstWhereOrNull((entry) => entry.number == resultEntry.value.number);
        if (resultData == null) {
          resultData = ResultData(0, 0, 0, 0, resultEntry.value.number, resultEntry.value.team);
          currentResults.add(resultData);
        }
        resultData.points += points.floor();
      }
    }
    currentResults
      ..sort((a, b) => b.points.compareTo(a.points))
      ..asMap().forEach((key, value) => value.rank = key);
    await _careerResultsDaoStorage.saveResults(currentResults);
    currentEvent.winner = results.firstWhere((element) => element.type == ResultsType.time).data.first.number;
    await _calendarRepository.saveResults(events);
    _calendarRepository.eventsCompleted++;
  }

  @override
  Future<List<ResultData>> get currentResults => _careerResultsDaoStorage.getAllResults();

  @override
  Future<void> reset() => Future.wait([
        _careerResultsDaoStorage.saveResults([]),
        _calendarRepository.reset(),
      ]);
}
