import 'dart:async';

import 'package:app_review/app_review.dart';
import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/repository/tutorial/tutorial_repository.dart';
import 'package:cycling_escape/screen_game/game_manager.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class GameViewModel with ChangeNotifierEx {
  late final bool _isTour;
  late final bool _isCareer;
  late final GameNavigator _navigator;
  final TutorialRepository _tutorialRepository;
  final LocalStorage _localStorage;
  final SpriteManager _spriteManager;
  final _isPaused = ValueNotifier(false);
  TutorialType? _tutorialType;
  Completer<FollowType>? _completer;
  int _followAmount = 0;

  bool get isPaused => _isPaused.value;

  TutorialType? get tutorialType => _tutorialType;

  bool get ignorePointer => isPaused || _tutorialType != null;

  bool get showFollowDialog => _completer != null;

  String get followAmount => _followAmount.toString();

  GameViewModel(
    this._tutorialRepository,
    this._localStorage,
    this._spriteManager,
  );

  Future<void> init(
    GameNavigator navigator,
    Localization localizations,
    PlaySettings playSettings,
    GameManager gameManager,
  ) async {
    _navigator = navigator;
    if (playSettings.loadGame) {
      _isTour = _localStorage.isCurrentGameTour;
      playSettings.isCareer = _localStorage.isCurrentGameCareer;
    } else {
      _isTour = playSettings.totalRaces != null && playSettings.totalRaces! > 1;
      _localStorage.isCurrentGameTour = _isTour;
      _localStorage.isCurrentGameCareer = playSettings.isCareer;
    }
    _isCareer = playSettings.isCareer;
    await gameManager.addListener(GameListener(
      localizations: localizations,
      spriteManager: _spriteManager,
      openTutorial: _openTutorial,
      localStorage: _localStorage,
      onEndCycling: _onEndCycling,
      onPause: _onPause,
      isPaused: _isPaused,
      onSelectFollow: _onSelectFollow,
      playSettings: playSettings,
    ));
  }

  void onBackPressed() {
    if (!isPaused) {
      _isPaused.value = true;
      notifyListeners();
      return;
    }
    _navigator.goToMainMenu();
  }

  Future<void> _onEndCycling(List<Sprint>? sprints) async {
    if (sprints == null) return _navigator.goToMainMenu();
    await _navigator.goToResults(sprints, _isTour, _isCareer);
  }

  Future<void> _onPause() async {
    _isPaused.value = true;
    notifyListeners();
  }

  Future<void> onFollow(FollowType followType) async {
    _completer?.complete(followType);
    _completer = null;
    _isPaused.value = false;
    notifyListeners();
  }

  Future<FollowType> _onSelectFollow(int followAmount) async {
    _followAmount = followAmount;
    _completer = Completer();
    _isPaused.value = true;
    notifyListeners();
    return _completer!.future;
  }

  Future<void> _openTutorial(TutorialType type) async {
    if (type == TutorialType.tourFirstFinished) {
      _tutorialRepository.toursFinished = _tutorialRepository.toursFinished + 1;
      _tutorialRepository.save();
      if (_tutorialRepository.toursFinished == 5) {
        await AppReview.requestReview;
      }
    }
    if (!_tutorialRepository.hasViewed(type)) {
      _isPaused.value = true;
      _tutorialType = type;
      notifyListeners();
      _tutorialRepository.addViewed(type);
    }
  }

  Future<void> onTutorialDismiss() async {
    _tutorialType = null;
    _isPaused.value = false;
    notifyListeners();
  }

  Future<void> onContinue() async {
    _isPaused.value = false;
    notifyListeners();
  }

  Future<void> onSave() async {
    await onContinue();
  }

  Future<void> onStop() => _navigator.goToMainMenu();
}

mixin GameNavigator {
  Future<void> goToMainMenu();

  Future<void> goToResults(List<Sprint> sprints, bool isTour, bool isCareer);
}
