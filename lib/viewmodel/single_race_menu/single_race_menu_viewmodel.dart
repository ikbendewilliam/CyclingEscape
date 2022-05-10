import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class SingleRaceMenuViewModel with ChangeNotifierEx {
  late final SingleRaceMenuNavigator _navigator;

  SingleRaceMenuViewModel();

  Future<void> init(SingleRaceMenuNavigator navigator) async {
    _navigator = navigator;
  }

  void onBackClicked() => _navigator.goBack<void>();
}

mixin SingleRaceMenuNavigator implements BackNavigator {}
