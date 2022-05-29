import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class TourInProgressViewModel with ChangeNotifierEx {
  late final TourInProgressNavigator _navigator;

  TourInProgressViewModel();

  Future<void> init(TourInProgressNavigator navigator) async {
    _navigator = navigator;
  }

  void onClosePressed() => _navigator.goBack<void>();

  void onContinuePressed() => _navigator.goToActiveTour();

  void onNewTourPressed() => _navigator.goToSelectTour();
}

mixin TourInProgressNavigator implements BackNavigator {
  void goToActiveTour();

  void goToSelectTour();
}
