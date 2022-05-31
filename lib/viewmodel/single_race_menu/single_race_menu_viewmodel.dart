import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class SingleRaceMenuViewModel with ChangeNotifierEx {
  late final SingleRaceMenuNavigator _navigator;
  var _teams = 4;
  var _cyclists = 4;
  var _raceType = 0;
  var _raceLength = 0;

  int get teams => _teams;

  int get cyclists => _cyclists;

  int get raceTypeIndex => _raceType;

  MapType get raceType => MapType.values[_raceType];

  int get raceLengthIndex => _raceLength;

  MapLength get raceLength => MapLength.values[_raceLength];

  bool get showWarning => _teams * _cyclists * (_raceType / 2 + 0.5) * (_raceLength + 0) >= 20;

  SingleRaceMenuViewModel();

  Future<void> init(SingleRaceMenuNavigator navigator) async {
    _navigator = navigator;
  }

  void setTeams(int teams) {
    _teams = teams;
    notifyListeners();
  }

  void setCyclists(int cyclists) {
    _cyclists = cyclists;
    notifyListeners();
  }

  void setRaceType(int raceType) {
    _raceType = raceType;
    notifyListeners();
  }

  void setRaceLength(int raceLength) {
    _raceLength = raceLength;
    notifyListeners();
  }

  void onBackClicked() => _navigator.goBack<void>();

  void onStartClicked() => _navigator.goToGame(PlaySettings(
        _teams,
        _cyclists,
        MapType.values[_raceType],
        MapLength.values[_raceLength],
        null,
      ));
}

mixin SingleRaceMenuNavigator implements BackNavigator {
  void goToGame(PlaySettings playSettings);
}
