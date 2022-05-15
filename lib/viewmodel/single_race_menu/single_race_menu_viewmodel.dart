import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class SingleRaceMenuViewModel with ChangeNotifierEx {
  late final SingleRaceMenuNavigator _navigator;
  var _teams = 4;
  var _cyclists = 4;

  int get teams => _teams;

  int get cyclists => _cyclists;

  bool get showWarning => _teams * _cyclists > 16;

  SingleRaceMenuViewModel();

  Future<void> init(SingleRaceMenuNavigator navigator) async {
    _navigator = navigator;
  }

  void setTeams(int teams) {
    _teams = teams;
    notifyListeners();
  }

  void setCyclists(int cyclists) {
    _cyclists = cyclists;
    notifyListeners();
  }

  void onBackClicked() => _navigator.goBack<void>();
}

mixin SingleRaceMenuNavigator implements BackNavigator {}
