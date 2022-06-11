import 'dart:math';
import 'dart:ui';

import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/util/save/save_util.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:flame/components.dart';

class Foiliage {
  final double size;
  final double angle;
  final Offset offset;
  final FoiliageType type;
  final SpriteManager spriteManager;

  Sprite? sprite;
  double aspectRatio = 1;
  DrawHeight? drawHeight;

  Foiliage(this.offset, this.size, this.type, this.spriteManager, this.angle) {
    switch (type) {
      case FoiliageType.rock1:
        sprite = spriteManager.getSprite('environment/rock1.png');
        drawHeight = DrawHeight.bottom;
        break;
      case FoiliageType.rock2:
        sprite = spriteManager.getSprite('environment/rock2.png');
        drawHeight = DrawHeight.bottom;
        break;
      case FoiliageType.rock3:
        sprite = spriteManager.getSprite('environment/rock3.png');
        drawHeight = DrawHeight.bottom;
        break;
      case FoiliageType.tentBlue1:
        sprite = spriteManager.getSprite('environment/tent_blue.png');
        drawHeight = DrawHeight.middle;
        break;
      case FoiliageType.tentBlue2:
        sprite = spriteManager.getSprite('environment/tent_blue_large.png');
        drawHeight = DrawHeight.middle;
        break;
      case FoiliageType.tentRed1:
        sprite = spriteManager.getSprite('environment/tent_red.png');
        drawHeight = DrawHeight.middle;
        break;
      case FoiliageType.tentRed2:
        sprite = spriteManager.getSprite('environment/tent_red_large.png');
        drawHeight = DrawHeight.middle;
        break;
      case FoiliageType.tree1:
        sprite = spriteManager.getSprite('environment/tree_large.png');
        drawHeight = DrawHeight.top;
        break;
      case FoiliageType.tree2:
        sprite = spriteManager.getSprite('environment/tree_small.png');
        drawHeight = DrawHeight.top;
        break;
      case FoiliageType.tribune:
        sprite = spriteManager.getSprite('environment/tribune_full.png');
        drawHeight = DrawHeight.bottom;
        aspectRatio = 2;
        break;
    }
  }

  void render(Canvas canvas, double? tileSize, Offset center, double screenRange, DrawHeight drawHeight) {
    if (drawHeight != this.drawHeight) {
      return;
    }
    if (pow(center.dx - offset.dx, 2) + pow(center.dy - offset.dy, 2) > screenRange) {
      return;
    }
    if (sprite == null) {
      return;
    }

    canvas.save();
    canvas.translate(offset.dx * tileSize!, offset.dy * tileSize);
    canvas.rotate(angle);
    sprite!.renderCentered(canvas, position: Vector2.zero(), size: Vector2(aspectRatio, 1) * size * tileSize);
    canvas.restore();
  }

  static Foiliage fromJson(Map<String, dynamic> json, SpriteManager spriteManager) {
    return Foiliage(SaveUtil.offsetFromJson(json['offset'] as Map<String, dynamic>)!, json['size'] as double, getFoiliageTypeFromString(json['type'] as String), spriteManager,
        json['angle'] as double);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['offset'] = SaveUtil.offsetToJson(offset);
    data['size'] = size;
    data['type'] = type.toString();
    data['angle'] = angle;
    return data;
  }
}

FoiliageType getFoiliageTypeFromString(String foiliageTypeAsString) {
  for (final element in FoiliageType.values) {
    if (element.toString() == foiliageTypeAsString) {
      return element;
    }
  }
  return FoiliageType.rock1;
}

enum FoiliageType { rock1, rock2, rock3, tentBlue1, tentBlue2, tentRed1, tentRed2, tree1, tree2, tribune }

enum DrawHeight { bottom, middle, top }
