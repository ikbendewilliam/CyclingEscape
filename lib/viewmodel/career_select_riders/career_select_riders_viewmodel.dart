import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerSelectRidersViewModel with ChangeNotifierEx {
  late final CareerSelectRidersNavigator _navigator;

  CareerSelectRidersViewModel();

  Future<void> init(CareerSelectRidersNavigator navigator) async {
    _navigator = navigator;
  }

  void onClosePressed() => _navigator.goBack<void>();
}

mixin CareerSelectRidersNavigator implements BackNavigator {}
