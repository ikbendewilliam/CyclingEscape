import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class TourMenuViewModel with ChangeNotifierEx {
  late final TourMenuNavigator _navigator;

  TourMenuViewModel();

  Future<void> init(TourMenuNavigator navigator) async {
    _navigator = navigator;
  }

  void onBackClicked() => _navigator.goBack<void>();
}

mixin TourMenuNavigator implements BackNavigator {}
