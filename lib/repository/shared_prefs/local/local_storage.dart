import 'package:collection/collection.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/secure_storage/auth/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
abstract class LocalStorage {
  @factoryMethod
  factory LocalStorage(AuthStorage storage, SharedPreferenceStorage preferences) = _LocalStorage;

  int get autofollowThreshold;

  int get toursFinished;

  bool get autofollowAsk;

  CyclistMovementType get cyclistMovement;

  CameraMovementType get cameraMovement;

  DifficultyType get difficulty;

  Set<TutorialType> get typesViewed;

  set autofollowThreshold(int value);

  set autofollowAsk(bool value);

  set cyclistMovement(CyclistMovementType value);

  set cameraMovement(CameraMovementType value);

  set difficulty(DifficultyType value);

  set typesViewed(Set<TutorialType> value);

  set toursFinished(int value);

  Future<void> checkForNewInstallation();

  ThemeMode getThemeMode();

  Future<void> updateThemeMode(ThemeMode themeMode);
}

class _LocalStorage implements LocalStorage {
  static const _uninstallCheckKey = 'uninstallCheck';
  static const _appearanceThemeKey = 'appearanceTheme';
  static const _autofollowThresholdKey = 'autofollowThreshold';
  static const _autofollowAskKey = 'autofollowAsk';
  static const _cyclistMovementKey = 'cyclistMovement';
  static const _cameraMovementKey = 'cameraMovement';
  static const _difficultyKey = 'difficulty';
  static const _toursFinishedKey = 'toursFinished';
  static const _typesViewedKey = 'typesViewed';

  final AuthStorage _authStorage;
  final SharedPreferenceStorage _sharedPreferences;

  @override
  int get autofollowThreshold => _sharedPreferences.getInt(_autofollowThresholdKey) ?? 7;

  @override
  bool get autofollowAsk => _sharedPreferences.getBoolean(_autofollowAskKey) ?? false;

  @override
  CyclistMovementType get cyclistMovement {
    final value = _sharedPreferences.getString(_cyclistMovementKey) ?? '';
    return CyclistMovementType.values.firstWhereOrNull((element) => element.toString() == value) ?? CyclistMovementType.normal;
  }

  @override
  CameraMovementType get cameraMovement {
    final value = _sharedPreferences.getString(_cameraMovementKey) ?? '';
    return CameraMovementType.values.firstWhereOrNull((element) => element.toString() == value) ?? CameraMovementType.auto;
  }

  @override
  DifficultyType get difficulty {
    final value = _sharedPreferences.getString(_difficultyKey) ?? '';
    return DifficultyType.values.firstWhereOrNull((element) => element.toString() == value) ?? DifficultyType.normal;
  }

  _LocalStorage(this._authStorage, this._sharedPreferences);

  @override
  Future<void> checkForNewInstallation() async {
    final result = _sharedPreferences.getBoolean(_uninstallCheckKey);
    if (result == null) {
      await _sharedPreferences.saveBoolean(key: _uninstallCheckKey, value: true);
      await _authStorage.clear();
    }
  }

  @override
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _sharedPreferences.saveString(key: _appearanceThemeKey, value: themeMode.toString());
  }

  @override
  ThemeMode getThemeMode() {
    final themeString = _sharedPreferences.getString(_appearanceThemeKey);
    final theme = ThemeMode.values.find((element) => element.toString() == themeString);
    return theme ?? ThemeMode.system;
  }

  @override
  set autofollowThreshold(int value) => _sharedPreferences.saveInt(key: _autofollowThresholdKey, value: value);

  @override
  set autofollowAsk(bool value) => _sharedPreferences.saveBoolean(key: _autofollowAskKey, value: value);

  @override
  set cyclistMovement(CyclistMovementType value) => _sharedPreferences.saveString(key: _cyclistMovementKey, value: value.toString());

  @override
  set cameraMovement(CameraMovementType value) => _sharedPreferences.saveString(key: _cameraMovementKey, value: value.toString());

  @override
  set difficulty(DifficultyType value) => _sharedPreferences.saveString(key: _difficultyKey, value: value.toString());

  @override
  int get toursFinished => _sharedPreferences.getInt(_toursFinishedKey) ?? 0;

  @override
  Set<TutorialType> get typesViewed =>
      _sharedPreferences.getString(_typesViewedKey)?.split(',').map((e) => TutorialType.values.firstWhere((element) => element.toString() == e)).toSet() ?? <TutorialType>{};

  @override
  set toursFinished(int value) => _sharedPreferences.saveInt(key: _toursFinishedKey, value: value);

  @override
  set typesViewed(Set<TutorialType> value) => _sharedPreferences.saveString(key: _typesViewedKey, value: value.map((e) => e.toString()).join(','));
}
