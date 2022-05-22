import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class ResultsViewModel with ChangeNotifierEx {
  late final ResultsNavigator _navigator;
  late final List<Sprint> _sprints;

  List<Sprint> get sprints => _sprints;

  ResultsViewModel();

  Future<void> init(ResultsNavigator navigator, List<Sprint> sprints) async {
    _navigator = navigator;
    _sprints = sprints;
  }

  void onContinuePressed() => _navigator.goToMainMenu();
}

mixin ResultsNavigator {
  void goToMainMenu();
}
