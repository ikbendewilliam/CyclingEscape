import 'dart:ui';

import 'package:flutter/cupertino.dart';

abstract class BaseView {
  Size screenSize;

  void onAttach();
  void render(Canvas canvas);
  void update(double t);
  void onTapUp(TapUpDetails details);
  void onTapDown(TapDownDetails details);
  void onScaleStart(ScaleStartDetails details);
  void onScaleUpdate(ScaleUpdateDetails details);

  void resize(Size size) {
    screenSize = size;
  }
}
