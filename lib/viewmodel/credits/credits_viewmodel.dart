import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreditsViewModel with ChangeNotifierEx {
  late final CreditsNavigator _navigator;

  CreditsViewModel();

  Future<void> init(CreditsNavigator navigator) async {
    _navigator = navigator;
  }

  void onBackPressed() => _navigator.goBack<void>();
}

mixin CreditsNavigator implements BackNavigator {}
