import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class V2dialogViewModel with ChangeNotifierEx {
  late final V2dialogNavigator _navigator;

  V2dialogViewModel();

  Future<void> init(V2dialogNavigator navigator) async {
    _navigator = navigator;
  }

  void onBackPressed() => _navigator.goToHome();
}

mixin V2dialogNavigator {
  void goToHome();
}
