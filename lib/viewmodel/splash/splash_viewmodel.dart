import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class SplashViewModel with ChangeNotifierEx {
  final LocalStorage _localStorage;

  SplashViewModel(this._localStorage);

  Future<void> init(SplashNavigator navigator) async {
    final isNew = await _localStorage.checkForNewInstallation();
    if (isNew) return navigator.goToDialogV2();
    navigator.goToHome();
  }
}

abstract class SplashNavigator {
  void goToHome();

  void goToDialogV2();
}
