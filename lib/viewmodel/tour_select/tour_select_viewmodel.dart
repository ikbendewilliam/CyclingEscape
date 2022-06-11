import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/tour/tour_repository.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class TourSelectViewModel with ChangeNotifierEx {
  late final TourSelectNavigator _navigator;
  final TourRepository _tourRepository;
  var _teams = 4;
  var _races = 3;
  var _cyclists = 4;
  var _raceType = 0;
  var _raceLength = 0;

  int get teams => _teams;

  int get races => _races;

  int get cyclists => _cyclists;

  int get raceTypeIndex => _raceType;

  String get raceTypeKey => MapType.values[_raceType].localizationKey;

  int get raceLengthIndex => _raceLength;

  String get raceLengthKey => MapLength.values[_raceLength].localizationKey;

  bool get showWarning => _teams * _cyclists * (_raceType / 2 + 0.5) * (_raceLength + 0) >= 20;

  TourSelectViewModel(this._tourRepository);

  Future<void> init(TourSelectNavigator navigator) async {
    _navigator = navigator;
  }

  void setTeams(int teams) {
    _teams = teams;
    notifyListeners();
  }

  void setRaces(int races) {
    _races = races;
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

  void onBackClicked() => _navigator.goToMainMenu();

  Future<void> onStartClicked() async {
    await _tourRepository.startNewTour(PlaySettings(
      _teams,
      _cyclists,
      MapType.values[_raceType],
      MapLength.values[_raceLength],
      null,
      _races,
    ));
    _navigator.goToTourOverview();
  }
}

mixin TourSelectNavigator {
  void goToMainMenu();

  void goToTourOverview();
}
