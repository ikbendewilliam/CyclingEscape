import 'dart:math';

import 'package:cycling_escape/model/data/moving_object.dart';
import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@singleton
class MenuBackgroundViewModel with ChangeNotifierEx {
  late Animation<double> _animation;
  late BoxConstraints _screenConstraints;
  AnimationController? _animationController;

  final List<MovingObject> _objects = [];
  final List<MovingObject> _clouds = [];
  final List<String> _backgroundAssets = [
    ThemeAssets.menuBackground1,
    ThemeAssets.menuBackground2,
    ThemeAssets.menuBackground3,
    ThemeAssets.menuBackground4,
  ];

  Map<String, double> get backgroundOffsets => _backgroundAssets.asMap().map((key, value) => MapEntry(value, _animation.value * pow(2, key)));

  Map<MovingObject, double> get objectsOffsets =>
      _objects.asMap().map((key, value) => MapEntry(value, _animation.value * value.speed - value.horizontalOffset * _screenConstraints.maxWidth))
        ..addAll(_clouds.asMap().map((key, value) => MapEntry(value, -_animation.value * value.speed + value.horizontalOffset * _screenConstraints.maxWidth)));

  Animation get animation => _animation;

  MenuBackgroundViewModel();

  Future<void> init(TickerProvider vsync, BoxConstraints constraints) async {
    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: vsync,
      duration: ThemeDurations.menuBackground,
    )..repeat();
    _animation = _animationController!.drive(Tween(begin: 0, end: constraints.maxWidth));
    _generateObjects();
    _screenConstraints = constraints;
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
    for (var i = 0; i < 100; i++) {
      _generateObject();
    }
  }

  void _generateObject() {
    const double offset = 1 / 7;
    final randomNumber = Random().nextDouble();
    if (randomNumber < 0.85) {
      final cloud = _randomCloud;
      _clouds.add(MovingObject(
        asset: cloud,
        speed: Random().nextInt(2) + 4,
        horizontalOffset: Random().nextDouble(),
        topOffsetPercentage: offset * (Random().nextDouble() + 0.5),
        scale: cloud == ThemeAssets.menuCloud2 ? 1 : (Random().nextDouble() * 3 + 1),
      ));
    } else {
      _objects.add(MovingObject(
        asset: ThemeAssets.menuCyclistSilhouette,
        speed: Random().nextInt(5) + 20,
        horizontalOffset: Random().nextDouble(),
        topOffsetPercentage: offset * 5.5,
      ));
    }
    if (!_objects.any((element) => element.asset == ThemeAssets.menuTardis)) {
      _objects.add(MovingObject(
        asset: ThemeAssets.menuTardis,
        speed: 100,
        horizontalOffset: Random().nextDouble(),
        topOffsetPercentage: offset * 4,
        scale: 2,
      ));
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
