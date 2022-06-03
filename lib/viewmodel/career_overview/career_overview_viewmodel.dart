import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerOverviewViewModel with ChangeNotifierEx {
  late final CareerOverviewNavigator _navigator;

  CareerOverviewViewModel();

  Future<void> init(CareerOverviewNavigator navigator) async {
    _navigator = navigator;
  }

  void onClosePressed() => _navigator.goToMainMenu();

  void onRankingsPressed() => _navigator.goToRankings();

  void onCalendarPressed() => _navigator.goToCalendar();

  void onNextRacePressed() => _navigator.goToSelectRiders();
}

mixin CareerOverviewNavigator {
  void goToMainMenu();

  void goToRankings();

  void goToCalendar();

  void goToSelectRiders();
}
