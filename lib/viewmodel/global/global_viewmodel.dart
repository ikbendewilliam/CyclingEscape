import 'package:auto_orientation/auto_orientation.dart';
import 'package:cycling_escape/repository/debug/debug_repository.dart';
import 'package:cycling_escape/repository/locale/locale_repository.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/util/env/flavor_config.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/locale/localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@singleton
class GlobalViewModel with ChangeNotifierEx {
  final LocaleRepository _localeRepo;
  final DebugRepository _debugRepo;
  final LocalStorage _localStorage;
  var _localeDelegate = LocalizationDelegate();
  var _showsTranslationKeys = false;

  TargetPlatform? _targetPlatform;

  GlobalViewModel(
    this._localeRepo,
    this._debugRepo,
    this._localStorage,
  );

  ThemeMode get themeMode => FlavorConfig.instance.themeMode;

  Locale? get locale => _localeDelegate.newLocale;

  TargetPlatform? get targetPlatform => _targetPlatform;

  LocalizationDelegate get localeDelegate => _localeDelegate;

  bool get showsTranslationKeys => _showsTranslationKeys;

  Future<void> init() async {
    _initLocale();
    _initTargetPlatform();
    _getThemeMode();
    AutoOrientation.landscapeAutoMode();
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _initTargetPlatform() {
    _targetPlatform = _debugRepo.getTargetPlatform();
    notifyListeners();
  }

  void _initLocale() {
    final locale = _localeRepo.getCustomLocale();
    if (locale != null) {
      _localeDelegate = LocalizationDelegate(newLocale: locale);
      notifyListeners();
    }
  }

  void _getThemeMode() {
    FlavorConfig.instance.themeMode = _localStorage.getThemeMode();
    notifyListeners();
  }

  Future<void> onUpdateLocaleClicked(Locale? locale) async {
    await _localeRepo.setCustomLocale(locale);
    _localeDelegate = LocalizationDelegate(newLocale: locale);
    notifyListeners();
  }

  Future<void> setSelectedPlatformToAndroid() async {
    await _debugRepo.saveSelectedPlatform('android');
    _initTargetPlatform();
  }

  Future<void> setSelectedPlatformToIOS() async {
    await _debugRepo.saveSelectedPlatform('ios');
    _initTargetPlatform();
  }

  Future<void> setSelectedPlatformToDefault() async {
    await _debugRepo.saveSelectedPlatform(null);
    _initTargetPlatform();
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    FlavorConfig.instance.themeMode = themeMode;
    notifyListeners();
    await _localStorage.updateThemeMode(themeMode);
  }

  String getCurrentPlatform() {
    if (targetPlatform == TargetPlatform.android) {
      return 'Android';
    } else if (targetPlatform == TargetPlatform.iOS) {
      return 'Ios';
    }
    return 'System Default';
  }

  String getAppearanceValue(Localization localization) {
    switch (FlavorConfig.instance.themeMode) {
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.light:
        return 'Light';
      default:
        return 'System';
    }
  }

  String getCurrentLanguage() {
    switch (localeDelegate.activeLocale?.languageCode) {
      case 'nl':
        return 'Nederlands';
      case 'en':
        return 'English';
    }
    return 'English';
  }

  bool isLanguageSelected(String? languageCode) {
    if (localeDelegate.activeLocale == null && languageCode == null) return true;
    return localeDelegate.activeLocale?.languageCode == languageCode;
  }

  void toggleTranslationKeys() {
    _showsTranslationKeys = !showsTranslationKeys;
    _localeDelegate = LocalizationDelegate(newLocale: localeDelegate.activeLocale, showLocalizationKeys: showsTranslationKeys);
    notifyListeners();
  }
}
