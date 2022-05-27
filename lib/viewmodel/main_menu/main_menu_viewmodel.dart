import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainMenuViewModel with ChangeNotifierEx {
  late final MainMenuNavigator _navigator;

  MainMenuViewModel();

  Future<void> init(MainMenuNavigator navigator) async {
    _navigator = navigator;
  }

  void onSingleRaceClicked() => _navigator.goToSingleRaceMenu();

  void onTourClicked() => _navigator.goToTourMenu();

  void onSettingsPressed() => _navigator.goToSettings();

  void onCreditsPressed() => _navigator.goToCredits();
}

mixin MainMenuNavigator {
  void goToTourMenu();

  void goToSingleRaceMenu();

  void goToSettings();

  void goToCredits();
}
