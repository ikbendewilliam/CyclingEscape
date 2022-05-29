import 'package:collection/collection.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/util/locale/localization_delegate.dart';
import 'package:cycling_escape/viewmodel/global/global_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsViewModel with ChangeNotifierEx {
  late final SettingsNavigator _navigator;
  final LocalStorage _localStorage;
  final _globalViewModel = GetIt.I<GlobalViewModel>();
  final locales = [
    'System',
    ...LocalizationDelegate.supportedLanguages,
  ];

  int get autofollowThreshold => _localStorage.autofollowThreshold;

  CyclistMovementType get cyclistMoveSpeed => _localStorage.cyclistMovement;

  int get cyclistMoveSpeedIndex => CyclistMovementType.values.indexOf(cyclistMoveSpeed);

  CameraMovementType get cameraAutoMove => _localStorage.cameraMovement;

  int get cameraAutoMoveIndex => CameraMovementType.values.indexOf(cameraAutoMove);

  int get languageIndex {
    final language = _globalViewModel.locale?.toLanguageTag();
    if (language == null) return 0;
    return locales.indexOf(language);
  }

  DifficultyType get difficulty => _localStorage.difficulty;

  int get difficultyIndex => DifficultyType.values.indexOf(difficulty);

  bool get autofollowThresholdBelowAsk => _localStorage.autofollowThresholdBelowAsk;

  bool get autofollowThresholdAboveAsk => _localStorage.autofollowThresholdAboveAsk;

  SettingsViewModel(this._localStorage);

  Future<void> init(SettingsNavigator navigator) async {
    _navigator = navigator;
  }

  Future<void> languageChanged(int languageIndex) async {
    final locale = LocalizationDelegate.supportedLocales.firstWhereOrNull((element) => element.toLanguageTag() == locales[languageIndex]);
    return _globalViewModel.onUpdateLocaleClicked(locale);
  }

  void autofollowThresholdChanged(int value) {
    _localStorage.autofollowThreshold = value;
    notifyListeners();
  }

  void cyclistMoveSpeedChanged(int value) {
    _localStorage.cyclistMovement = CyclistMovementType.values[value];
    notifyListeners();
  }

  void cameraAutoMoveChanged(int value) {
    _localStorage.cameraMovement = CameraMovementType.values[value];
    notifyListeners();
  }

  void difficultyChanged(int value) {
    _localStorage.difficulty = DifficultyType.values[value];
    notifyListeners();
  }

  void autofollowThresholdBelowAskChanged(bool value) {
    _localStorage.autofollowThresholdBelowAsk = value;
    notifyListeners();
  }

  void autofollowThresholdAboveAskChanged(bool value) {
    _localStorage.autofollowThresholdAboveAsk = value;
    notifyListeners();
  }

  void onChangeCyclistNamesPressed() => _navigator.goToChangeCyclistNames();

  void onBackPressed() => _navigator.goBack<void>();
}

mixin SettingsNavigator implements BackNavigator {
  void goToChangeCyclistNames();
}
