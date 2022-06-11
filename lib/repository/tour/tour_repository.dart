import 'package:cycling_escape/database/tour_results/tour_results_dao_storage.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
abstract class TourRepository {
  @factoryMethod
  factory TourRepository(
    TourResultsDaoStorage tourResultsDaoStorage,
    LocalStorage localStorage,
  ) = _TourRepository;

  Future<Results> get currentResults;

  PlaySettings? get playSettings;

  int get completedRaces;

  set completedRaces(int value);

  Future<void> saveResults(Results results);

  void savePlaySettings(PlaySettings playSettings);

  Future<void> startNewTour(PlaySettings playSettings);

  Future<void> tourFinished();
}

class _TourRepository implements TourRepository {
  final TourResultsDaoStorage _tourResultsDaoStorage;
  final LocalStorage _localStorage;

  @override
  Future<Results> get currentResults async {
    final results = _localStorage.tourResults ?? Results(ResultsType.combined);
    results.data = await _tourResultsDaoStorage.getAllResults();
    return results;
  }

  @override
  PlaySettings? get playSettings => _localStorage.playSettings;

  @override
  int get completedRaces => _localStorage.completedRaces;

  @override
  set completedRaces(int value) => _localStorage.completedRaces = value;

  _TourRepository(
    this._tourResultsDaoStorage,
    this._localStorage,
  );

  @override
  Future<void> saveResults(Results tourResults) async {
    await _tourResultsDaoStorage.saveResults(tourResults.data);
    _localStorage.setTourResults(tourResults);
  }

  @override
  void savePlaySettings(PlaySettings playSettings) => _localStorage.setPlaySettings(playSettings);

  @override
  Future<void> startNewTour(PlaySettings playSettings) async {
    final results = Results(ResultsType.combined);
    await saveResults(results);
    savePlaySettings(playSettings);
    completedRaces = 0;
  }

  @override
  Future<void> tourFinished() async {
    await _tourResultsDaoStorage.saveResults([]);
    _localStorage.toursFinished++;
    _localStorage.clearTour();
  }
}
