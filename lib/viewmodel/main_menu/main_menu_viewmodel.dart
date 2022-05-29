import 'package:cycling_escape/repository/tour/tour_repository.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainMenuViewModel with ChangeNotifierEx {
  late final MainMenuNavigator _navigator;
  final TourRepository _tourRepository;

  MainMenuViewModel(
    this._tourRepository,
  );

  Future<void> init(MainMenuNavigator navigator) async {
    _navigator = navigator;
  }

  void onSingleRaceClicked() => _navigator.goToSingleRaceMenu();

  Future<void> onTourClicked() async {
    if (_tourRepository.playSettings == null) {
      _navigator.goToTourSelect();
    } else {
      _navigator.goToTourInProgress();
    }
  }

  void onSettingsPressed() => _navigator.goToSettings();

  void onCreditsPressed() => _navigator.goToCredits();
}

mixin MainMenuNavigator {
  void goToTourSelect();

  void goToTourInProgress();

  void goToSingleRaceMenu();

  void goToSettings();

  void goToCredits();
}
