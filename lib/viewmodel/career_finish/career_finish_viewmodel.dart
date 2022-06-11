import 'package:collection/collection.dart';
import 'package:cycling_escape/repository/career/career_repository.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerFinishViewModel with ChangeNotifierEx {
  late final CareerFinishNavigator _navigator;
  final CareerRepository _careerRepository;

  var _hasWonSingle = false;
  var _hasWonTeam = false;
  int _singlePoints = 0;
  int _teamPoints = 0;

  bool get hasWonSingle => _hasWonSingle;

  bool get hasWonTeam => _hasWonTeam;

  int get teamPoints => _teamPoints;

  int get singlePoints => _singlePoints;

  CareerFinishViewModel(this._careerRepository);

  Future<void> init(CareerFinishNavigator navigator) async {
    _navigator = navigator;

    final currentResults = await _careerRepository.currentResults
      ..sort((a, b) => b.points.compareTo(a.points));
    _hasWonSingle = currentResults.firstOrNull?.team?.isPlayer == true;
    _singlePoints = currentResults.firstWhereOrNull((cyclist) => cyclist.team?.isPlayer == true)?.points ?? 0;
    _calculateTeamResult(currentResults);
    notifyListeners();
  }

  void _calculateTeamResult(List<ResultData> currentResults) {
    final teamResults = <ResultData>[];
    final teams = currentResults.map((element) => element.team).toList();
    for (final team in teams) {
      if (teamResults.where((element) => element.team == team).isEmpty) {
        final resultData = ResultData();
        currentResults.where((element) => element.team == team).forEach((element) => resultData.points += element.points);
        resultData.team = team;
        teamResults.add(resultData);
      }
    }
    teamResults
      ..sort((a, b) => b.points.compareTo(a.points))
      ..asMap().forEach((key, value) => value.rank = key);
    _hasWonTeam = teamResults.firstOrNull?.team?.isPlayer == true;
    _teamPoints = teamResults.firstWhereOrNull((cyclist) => cyclist.team?.isPlayer == true)?.points ?? 0;
  }

  Future<void> onFinishPressed() async {
    await _careerRepository.reset();
    _navigator.goToHome();
  }
}

mixin CareerFinishNavigator {
  void goToHome();
}
