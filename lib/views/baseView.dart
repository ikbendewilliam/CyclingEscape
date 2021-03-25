import 'dart:ui';

import 'package:cycling_escape/components/data/spriteManager.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseView {
  Size? screenSize;
  final SpriteManager spriteManager;

  BaseView(this.spriteManager);

  void onAttach();
  void render(Canvas canvas);
  void update(double t);
  void onTapUp(TapUpDetails details);
  void onTapDown(TapDownDetails details);
  void onScaleStart(ScaleStartDetails details);
  void onScaleUpdate(ScaleUpdateDetails details);

  void resize(Size? size) {
    screenSize = size;
  }
}
