import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/repository/career/career_repository.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerResetViewModel with ChangeNotifierEx {
  late final CareerResetNavigator _navigator;
  final CareerRepository _careerRepository;

  CareerResetViewModel(this._careerRepository);

  Future<void> init(CareerResetNavigator navigator) async {
    _navigator = navigator;
  }

  void onCancelPressed() => _navigator.goBack<void>();

  Future<void> onResetPressed() async {
    await _careerRepository.reset();
    _navigator.goToCareerOverview();
  }
}

mixin CareerResetNavigator implements BackNavigator {
  void goToCareerOverview();
}
