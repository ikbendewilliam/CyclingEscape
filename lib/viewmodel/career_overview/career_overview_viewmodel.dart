import 'package:collection/collection.dart';
import 'package:cycling_escape/repository/calendar/calendar_repository.dart';
import 'package:cycling_escape/repository/career/career_repository.dart';
import 'package:cycling_escape/repository/name/name_repository.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerOverviewViewModel with ChangeNotifierEx {
  late final CareerOverviewNavigator _navigator;
  late final int _firstTime;
  final CareerRepository _careerRepository;
  final CalendarRepository _calendarRepository;
  final NameRepository _nameRepository;
  final List<ResultData> _currentResults = [];
  var _isFinished = false;
  ResultData? _teamResult;

  List<ResultData> get currentResults => _currentResults.where((cyclist) => cyclist.team?.isPlayer == true).toList();

  ResultData? get teamResult => _teamResult;

  int get firstTime => _firstTime;

  bool get isFinished => _isFinished;

  CareerOverviewViewModel(
    this._careerRepository,
    this._calendarRepository,
    this._nameRepository,
  );

  Future<void> init(CareerOverviewNavigator navigator) async {
    _navigator = navigator;
    _currentResults
      ..addAll(await _careerRepository.currentResults)
      ..sort((a, b) => b.points.compareTo(a.points));
    _firstTime = _currentResults.firstOrNull?.time ?? 0;
    _calculateTeamResult();
    notifyListeners();
    _isFinished = (await _calendarRepository.calendarEvents).length == _calendarRepository.eventsCompleted;
  }

  String numberToName(int? number) => (number == null ? null : _nameRepository.names[number]) ?? '-';

  void _calculateTeamResult() {
    final teamResults = <ResultData>[];
    final teams = _currentResults.map((element) => element.team).toList();
    for (final team in teams) {
      if (teamResults.where((element) => element.team == team).isEmpty) {
        final resultData = ResultData();
        _currentResults.where((element) => element.team == team).forEach((element) => resultData.points += element.points);
        resultData.team = team;
        teamResults.add(resultData);
      }
    }
    teamResults
      ..sort((a, b) => b.points.compareTo(a.points))
      ..asMap().forEach((key, value) => value.rank = key);
    _teamResult = teamResults.firstWhereOrNull((team) => team.team?.isPlayer == true);
  }

  void onFinishPressed() => _navigator.goToCareerFinish();

  void onClosePressed() => _navigator.goToMainMenu();

  void onRankingsPressed() => _navigator.goToRankings();

  void onCalendarPressed() => _navigator.goToCalendar();

  void onNextRacePressed() => _navigator.goToSelectRiders();

  void onResetPressed() => _navigator.goToResetCareer();
}

mixin CareerOverviewNavigator {
  void goToMainMenu();

  void goToRankings();

  void goToCalendar();

  void goToResetCareer();

  void goToCareerFinish();

  void goToSelectRiders();
}
