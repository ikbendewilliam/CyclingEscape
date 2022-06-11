import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/secure_storage/auth/auth_storage.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
abstract class LocalStorage {
  @factoryMethod
  factory LocalStorage(AuthStorage storage, SharedPreferenceStorage preferences) = _LocalStorage;

  int get autofollowThreshold;

  int get toursFinished;

  int get completedRaces;

  bool get autofollowThresholdBelowAsk;

  bool get isCurrentGameTour;

  bool get autofollowThresholdAboveAsk;

  CyclistMovementType get cyclistMovement;

  CameraMovementType get cameraMovement;

  DifficultyType get difficulty;

  Results? get tourResults;

  PlaySettings? get playSettings;

  Set<TutorialType> get typesViewed;

  Map<int, String> get cyclistNames;

  set autofollowThreshold(int value);

  set autofollowThresholdBelowAsk(bool value);

  set isCurrentGameTour(bool value);

  set autofollowThresholdAboveAsk(bool value);

  set cyclistMovement(CyclistMovementType value);

  set cameraMovement(CameraMovementType value);

  set difficulty(DifficultyType value);

  set typesViewed(Set<TutorialType> value);

  set toursFinished(int value);

  set completedRaces(int value);

  Future<bool> checkForNewInstallation();

  ThemeMode getThemeMode();

  Future<void> updateThemeMode(ThemeMode themeMode);

  void setCyclistNames(Map<int, String> names);

  void setTourResults(Results results);

  void clearTour();

  void setPlaySettings(PlaySettings? playSettings);

  int get eventsCompleted;

  set eventsCompleted(int value);
}

class _LocalStorage implements LocalStorage {
  static const _uninstallCheckKey = 'uninstallCheck';
  static const _appearanceThemeKey = 'appearanceTheme';
  static const _autofollowThresholdKey = 'autofollowThreshold';
  static const _autofollowThresholdBelowAskKey = 'autofollowThresholdBelowAsk';
  static const _autofollowThresholdAboveAskKey = 'autofollowThresholdAboveAsk';
  static const _cyclistNamesKey = 'cyclistNames';
  static const _cyclistMovementKey = 'cyclistMovement';
  static const _cameraMovementKey = 'cameraMovement';
  static const _difficultyKey = 'difficulty';
  static const _toursFinishedKey = 'toursFinished';
  static const _typesViewedKey = 'typesViewed';
  static const _tourResultsKey = 'tourResults';
  static const _playSettingsKey = 'playSettings';
  static const _eventsCompletedKey = 'eventsCompleted';
  static const _completedRacesKey = 'completedRaces';
  static const _isCurrentGameTourKey = 'isCurrentGameTour';

  final AuthStorage _authStorage;
  final SharedPreferenceStorage _sharedPreferences;

  @override
  int get autofollowThreshold => _sharedPreferences.getInt(_autofollowThresholdKey) ?? 7;

  @override
  int get completedRaces => _sharedPreferences.getInt(_completedRacesKey) ?? 0;

  @override
  bool get autofollowThresholdBelowAsk => _sharedPreferences.getBoolean(_autofollowThresholdBelowAskKey) ?? true;

  @override
  bool get isCurrentGameTour => _sharedPreferences.getBoolean(_isCurrentGameTourKey) ?? true;

  @override
  bool get autofollowThresholdAboveAsk => _sharedPreferences.getBoolean(_autofollowThresholdAboveAskKey) ?? true;

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

  @override
  Results? get tourResults {
    final value = _sharedPreferences.getString(_tourResultsKey);
    if (value == null) return null;
    final jerseys = value.split(',');
    return Results(ResultsType.combined, null, int.tryParse(jerseys[0]), int.tryParse(jerseys[1]), int.tryParse(jerseys[2]));
  }

  @override
  Map<int, String> get cyclistNames =>
      _sharedPreferences.getString(_cyclistNamesKey)?.split(',').asMap().map((key, value) {
        final element = value.split('.');
        return MapEntry(int.parse(element[0]), utf8.decode(base64Decode(element[1])));
      }) ??
      {};

  @override
  PlaySettings? get playSettings {
    final settings = _sharedPreferences.getString(_playSettingsKey);
    if (settings == null) return null;
    return PlaySettings.fromJson(settings);
  }

  _LocalStorage(this._authStorage, this._sharedPreferences);

  @override
  Future<bool> checkForNewInstallation() async {
    final result = _sharedPreferences.getBoolean(_uninstallCheckKey);
    if (result != null) return false;
    await _sharedPreferences.saveBoolean(key: _uninstallCheckKey, value: true);
    await _authStorage.clear();
    return true;
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
  set completedRaces(int value) => _sharedPreferences.saveInt(key: _completedRacesKey, value: value);

  @override
  set autofollowThresholdBelowAsk(bool value) => _sharedPreferences.saveBoolean(key: _autofollowThresholdBelowAskKey, value: value);

  @override
  set isCurrentGameTour(bool value) => _sharedPreferences.saveBoolean(key: _isCurrentGameTourKey, value: value);

  @override
  set autofollowThresholdAboveAsk(bool value) => _sharedPreferences.saveBoolean(key: _autofollowThresholdAboveAskKey, value: value);

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

  @override
  void setCyclistNames(Map<int, String> names) {
    final encodedNames = names.entries.map((e) => '${e.key}.${base64Encode(utf8.encode(e.value))}').join(',');
    _sharedPreferences.saveString(key: _cyclistNamesKey, value: encodedNames);
  }

  @override
  void setTourResults(Results results) {
    _sharedPreferences.saveString(key: _tourResultsKey, value: '${results.whiteJersey},${results.greenJersey},${results.bouledJersey}');
  }

  @override
  void clearTour() {
    _sharedPreferences.removeValue(key: _tourResultsKey);
    _sharedPreferences.removeValue(key: _playSettingsKey);
    _sharedPreferences.removeValue(key: _completedRacesKey);
  }

  @override
  void setPlaySettings(PlaySettings? settings) {
    if (settings == null) {
      _sharedPreferences.deleteKey(_playSettingsKey);
      return;
    }
    _sharedPreferences.saveString(key: _playSettingsKey, value: settings.toJson());
  }

  @override
  int get eventsCompleted => _sharedPreferences.getInt(_eventsCompletedKey) ?? 0;

  @override
  set eventsCompleted(int value) => _sharedPreferences.saveInt(key: _eventsCompletedKey, value: value);
}
