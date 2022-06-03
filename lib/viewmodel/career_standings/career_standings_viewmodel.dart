import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerStandingsViewModel with ChangeNotifierEx {
  late final CareerStandingsNavigator _navigator;

  CareerStandingsViewModel();

  Future<void> init(CareerStandingsNavigator navigator) async {
    _navigator = navigator;
  }

  void onClosePressed() => _navigator.goBack<void>();
}

mixin CareerStandingsNavigator implements BackNavigator {}
