import 'dart:math';

import 'package:cycling_escape/model/data/moving_object.dart';
import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:cycling_escape/widget/menu_background/menu_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

class MenuBackgroundDataContainer with ChangeNotifier {
  final List<MovingObject> _objects = [];
  final List<MovingObject> _clouds = [];
  final List<MenuBackgroundWidgetState> _tickers = [];
  AnimationController? _animationController;
  late Animation<double> _animation;
  late double _maxWidth;

  static final _instance = MenuBackgroundDataContainer._();

  static MenuBackgroundDataContainer get instance => _instance;

  List<MovingObject> get objects {
    if (_objects.isEmpty) _generateObjects();
    return _objects;
  }

  List<MovingObject> get clouds {
    if (_clouds.isEmpty) _generateObjects();
    return _clouds;
  }

  AnimationController? get animationController => _animationController;

  Animation<double> get animation => _animation;

  MenuBackgroundDataContainer._();

  void addTicker(MenuBackgroundWidgetState ticker, double maxWidth) {
    _maxWidth = maxWidth;
    _tickers.add(ticker);
    if (_animationController == null) {
      _animationController = AnimationController(
        vsync: ticker,
        duration: ThemeDurations.menuBackground,
      )..repeat();
      _animation = animationController!.drive(Tween(begin: 0, end: _maxWidth));
    } else {
      _animationController!.resync(ticker);
    }
  }

  void removeTicker() {
    final value = _animationController?.value;
    _tickers.removeWhere((element) => !element.mounted);
    _animationController?.dispose();
    _animationController = null;
    if (_tickers.isEmpty) return;
    _animationController = AnimationController(
      vsync: _tickers.last,
      duration: ThemeDurations.menuBackground,
      value: value,
    )..repeat();
    _animation = animationController!.drive(Tween(begin: 0, end: _maxWidth));
    notifyListeners();
  }

  String get _randomCloud {
    switch (Random().nextInt(5)) {
      case 1:
        return ThemeAssets.menuCloud2;
      case 2:
        return ThemeAssets.menuCloud3;
      case 3:
        return ThemeAssets.menuCloud4;
      case 4:
        return ThemeAssets.menuCloud5;
      default:
        return ThemeAssets.menuCloud1;
    }
  }

  void _generateObjects() {
    for (var i = 0; i < 50; i++) {
      _generateObject();
    }
  }

  void _generateObject() {
    const dy = 1 / 7;
    final random = Random();
    final randomNumber = random.nextDouble();
    if (randomNumber < 0.85) {
      final cloud = _randomCloud;
      _clouds.add(MovingObject(
        asset: cloud,
        speed: random.nextInt(2) + 4,
        horizontalOffset: 10 * random.nextDouble(),
        topOffsetPercentage: dy * (random.nextDouble() + 0.5),
        scale: cloud == ThemeAssets.menuCloud2 ? 1 : (random.nextDouble() + 0.2),
      ));
    } else {
      _objects.add(MovingObject(
        asset: ThemeAssets.menuCyclistSilhouette,
        speed: random.nextInt(5) + 20,
        horizontalOffset: 10 * random.nextDouble(),
        topOffsetPercentage: dy * 5.5,
      ));
    }
    if (!_objects.any((element) => element.asset == ThemeAssets.menuTardis)) {
      _objects.add(MovingObject(
        asset: ThemeAssets.menuTardis,
        speed: 100,
        horizontalOffset: 10 * random.nextDouble(),
        topOffsetPercentage: dy * 4,
        scale: 0.5,
      ));
    }
  }
}

@injectable
class MenuBackgroundViewModel with ChangeNotifierEx {
  late BoxConstraints _screenConstraints;

  final List<String> _backgroundAssets = [
    ThemeAssets.menuBackground1,
    ThemeAssets.menuBackground2,
    ThemeAssets.menuBackground3,
    ThemeAssets.menuBackground4,
  ];

  MenuBackgroundDataContainer get _data => MenuBackgroundDataContainer.instance;

  Map<String, double> get backgroundOffsets => _backgroundAssets.asMap().map((key, value) => MapEntry(value, animation.value * pow(2, key)));

  Map<MovingObject, double> get objectsOffsets =>
      _data.objects.asMap().map((key, value) => MapEntry(value, animation.value * value.speed - value.horizontalOffset * _screenConstraints.maxWidth))
        ..addAll(_data.clouds.asMap().map((key, value) => MapEntry(value, -animation.value * value.speed + value.horizontalOffset * _screenConstraints.maxWidth)));

  Animation<double> get animation => _data.animation;

  Future<void> init(MenuBackgroundWidgetState vSync, BoxConstraints constraints) async {
    _screenConstraints = constraints;
    _data.addTicker(vSync, constraints.maxWidth);
    _data.addListener(_notifyListeners);
  }

  Future<void> _notifyListeners() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (disposed) return;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _data.removeListener(_notifyListeners);
    _data.removeTicker();
    super.dispose();
  }
}
