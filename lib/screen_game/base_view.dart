import 'dart:ui';

import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';

abstract class BaseView {
  Size? screenSize;
  final SpriteManager spriteManager;

  BaseView(this.spriteManager);

  void onAttach();
  void render(Canvas canvas);
  void update(double t);
  void onTapUp(TapUpInfo details);
  void onTapDown(TapDownInfo details);
  void onScaleStart(ScaleStartInfo details);
  void onScaleUpdate(ScaleUpdateInfo details);

  void resize(Size? size) {
    screenSize = size;
  }
}
