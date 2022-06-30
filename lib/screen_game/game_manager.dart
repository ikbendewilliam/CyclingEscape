import 'dart:async';

import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/screen_game/cycling_view.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class GameListener {
  final LocalStorage localStorage;
  final Localization localizations;
  final PlaySettings playSettings;
  final VoidCallback onPause;
  final SpriteManager spriteManager;
  final ValueNotifier<bool> isPaused;
  final SelectFollow onSelectFollow;
  final ValueChanged<TutorialType> openTutorial;
  final ValueChanged<List<Sprint>?> onEndCycling;

  GameListener({
    required this.onPause,
    required this.isPaused,
    required this.localStorage,
    required this.onEndCycling,
    required this.openTutorial,
    required this.playSettings,
    required this.localizations,
    required this.spriteManager,
    required this.onSelectFollow,
  });
}

class GameManager with Game, ScaleDetector, TapDetector {
  var _loading = true;
  double loadingPercentage = 0;
  CyclingView? _view;
  GameListener? _listener;
  final _canStartLoading = Completer<void>();

  bool get loading => _loading || _view == null;

  CyclingView get view => _view!;

  Future<void> addListener(GameListener listener) async {
    _listener = listener;
    _canStartLoading.complete();
  }

  @override
  Future<void> onLoad() async {
    await _load();
    return super.onLoad();
  }

  Future<void> _onPause() async {
    _listener?.onPause();
    SaveUtil.saveCyclingView(view);
  }

  Future<void> _load() async {
    await _canStartLoading.future; // Wait for the listener to be added
    await _listener!.spriteManager.loadSprites();
    if (_listener?.playSettings.loadGame == true) {
      _view = SaveUtil.loadCyclingView(
        spriteManager: _listener!.spriteManager,
        onEndCycling: _onEndCycling,
        localStorage: _listener!.localStorage,
        localizations: _listener!.localizations,
        openTutorial: _listener!.openTutorial,
        onSelectFollow: _listener!.onSelectFollow,
        onPause: _onPause,
      );
    }
    _view ??= CyclingView(
      spriteManager: _listener!.spriteManager,
      onEndCycling: _onEndCycling,
      localStorage: _listener!.localStorage,
      localizations: _listener!.localizations,
      openTutorial: _listener!.openTutorial,
      onSelectFollow: _listener!.onSelectFollow,
      onPause: _onPause,
    );
    view.resize(size.toSize());
    view.onAttach(playSettings: _listener!.playSettings);
    view.resize(size.toSize());
    _loading = false;
  }

  Future<void> _onEndCycling(List<Sprint>? sprints) async {
    _listener?.onEndCycling(sprints);
    await SaveUtil.clearCyclingView();
  }

  @override
  void onGameResize(Vector2 size) {
    _view?.resize(size.toSize());
    super.onGameResize(size);
  }

  @override
  void render(Canvas canvas) {
    if (loading) {
      // print(loadingPercentage);
      final Paint bgPaint = Paint()..color = Colors.green[200]!;
      canvas.drawRect(Rect.fromLTRB(0, 0, size.x, size.y), bgPaint);
      const TextSpan span =
          TextSpan(style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: 'Loading... '); // ${loadingPercentage.toStringAsFixed(2)}%
      final Offset position = Offset(size.x / 2, size.y / 2);
      CanvasUtils.drawText(canvas, position, 0, span);
    } else {
      view.render(canvas);
    }
  }

  void loadingCheck() {
    if (loading && _listener != null) {
      loadingPercentage = _listener!.spriteManager.checkLoadingPercentage();
      if (loadingPercentage.isNaN) {
        loadingPercentage = 0;
      }
      if (loadingPercentage >= 99.999) {
        loadingPercentage = 100;
      }
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && !view.ended && view.map != null) {
      SaveUtil.saveCyclingView(view);
    }
  }

  @override
  void update(double dt) {
    if (_listener?.isPaused.value != false) return;
    if (loading) {
      loadingCheck();
      return;
    } else {
      view.update(dt);
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    if (loading) return;
    view.onTapUp(info);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (loading) return;
    view.onTapDown(info);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    if (loading) return;
    view.onScaleStart(info);
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (loading) return;
    view.onScaleUpdate(info);
  }
}
