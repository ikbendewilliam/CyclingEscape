import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerCalendarViewModel with ChangeNotifierEx {
  late final CareerCalendarNavigator _navigator;

  CareerCalendarViewModel();

  Future<void> init(CareerCalendarNavigator navigator) async {
    _navigator = navigator;
  }

  void onClosePressed() => _navigator.goBack<void>();
}

mixin CareerCalendarNavigator implements BackNavigator {}
