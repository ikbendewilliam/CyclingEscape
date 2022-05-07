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
  AnimationController? _animationController;

  final List<MovingObject> objects = [];
  final List<String> _backgroundAssets = [
    ThemeAssets.menuBackground1,
    ThemeAssets.menuBackground2,
    ThemeAssets.menuBackground3,
    ThemeAssets.menuBackground4,
  ];

  Map<String, double> get backgroundOffsets => _backgroundAssets.asMap().map((key, value) => MapEntry(value, _animation.value * pow(2, key)));

  Animation get animation => _animation;

  MenuBackgroundViewModel();

  Future<void> init(TickerProvider vsync, double maxWidth) async {
    _animationController?.dispose();
    _animationController = AnimationController(vsync: vsync, duration: ThemeDurations.menuBackground)..repeat();
    _animation = _animationController!.drive(Tween(begin: 0, end: maxWidth));
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }
}
