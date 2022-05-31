import 'package:collection/collection.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/name/name_repository.dart';
import 'package:cycling_escape/repository/tour/tour_repository.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class ActiveTourViewModel with ChangeNotifierEx {
  final TourRepository _tourRepository;
  final NameRepository _nameRepository;
  late final ActiveTourNavigator _navigator;
  late final int _racesCompleted;
  late final PlaySettings _playSettings;
  Results? _currentResults;
  ResultData? _teamResult;

  int get racesCompleted => _racesCompleted;

  PlaySettings get playSettings => _playSettings;

  List<ResultData> get teamResults => (_currentResults?.data.where((element) => element.team?.isPlayer == true).toList() ?? [])..sort((a, b) => a.rank.compareTo(b.rank));

  ResultData? get teamResult => _teamResult;

  int get firstTime => _currentResults?.data.reduce((value, element) => value.time > element.time ? element : value).time ?? 0;

  String numberToName(int number) => _nameRepository.names[number] ?? '';

  ActiveTourViewModel(
    this._tourRepository,
    this._nameRepository,
  );

  Future<void> init(ActiveTourNavigator navigator) async {
    _navigator = navigator;
    final playSettings = _tourRepository.playSettings;
    if (playSettings == null) return _navigator.goToMainMenu();
    _playSettings = playSettings;
    _racesCompleted = _tourRepository.completedRaces;
    _currentResults = await _tourRepository.currentResults;
    _currentResults?.data.sort((a, b) => a.rank.compareTo(b.rank));
    if (_currentResults?.data.isNotEmpty == true) playSettings.tourResults = _currentResults;
    _calculateTeamResult();
    notifyListeners();
  }

  void _calculateTeamResult() {
    final Results teamResults = Results(ResultsType.team);
    final List<Team?> teams = _currentResults!.data.map((element) => element.team).toList();
    for (final team in teams) {
      if (teamResults.data.where((element) => element.team == team).isEmpty) {
        final ResultData resultData = ResultData();
        _currentResults!.data.where((element) => element.team == team).forEach((element) => resultData.time += element.time);
        resultData.team = team;
        teamResults.data.add(resultData);
      }
    }
    teamResults.data.sort((a, b) => a.time - b.time);
    teamResults.data.asMap().forEach((key, value) => value.rank = key);
    _teamResult = teamResults.data.firstWhereOrNull((element) => element.team?.isPlayer == true);
  }

  void onClosePressed() => _navigator.goToMainMenu();

  void onStartRacePressed() => _navigator.goToRace(playSettings);

  Future<void> onFinishPressed() async {
    await _tourRepository.tourFinished();
    _navigator.goToMainMenu();
  }
}

mixin ActiveTourNavigator {
  void goToMainMenu();

  void goToRace(PlaySettings playSettings);
}
