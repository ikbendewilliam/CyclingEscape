import 'package:cycling_escape/repository/login/login_repository.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class SplashViewModel with ChangeNotifierEx {
  final LoginRepository _loginRepo;
  final LocalStorage _localStorage;

  SplashViewModel(this._loginRepo, this._localStorage);

  Future<void> init(SplashNavigator navigator) async {
    await _localStorage.checkForNewInstallation();
    final result = await _loginRepo.isLoggedIn();
    if (result) {
      navigator.goToHome();
    } else {
      navigator.goToLogin();
    }
  }
}

abstract class SplashNavigator {
  void goToHome();

  void goToLogin();
}
