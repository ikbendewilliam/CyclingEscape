import 'dart:math';
import 'dart:ui';

import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/utils/saveUtil.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';

class Foiliage {
  final double size;
  final double angle;
  final Offset offset;
  final FoiliageType type;
  final SpriteManager spriteManager;

  Sprite sprite;
  double aspectRatio = 1;
  DrawHeight drawHeight;

  Foiliage(this.offset, this.size, this.type, this.spriteManager, this.angle) {
    switch (this.type) {
      case FoiliageType.ROCK_1:
        sprite = this.spriteManager.getSprite('environment/rock1.png');
        drawHeight = DrawHeight.BOTTOM;
        break;
      case FoiliageType.ROCK_2:
        sprite = this.spriteManager.getSprite('environment/rock2.png');
        drawHeight = DrawHeight.BOTTOM;
        break;
      case FoiliageType.ROCK_3:
        sprite = this.spriteManager.getSprite('environment/rock3.png');
        drawHeight = DrawHeight.BOTTOM;
        break;
      case FoiliageType.TENT_BLUE_1:
        sprite = this.spriteManager.getSprite('environment/tent_blue.png');
        drawHeight = DrawHeight.MIDDLE;
        break;
      case FoiliageType.TENT_BLUE_2:
        sprite =
            this.spriteManager.getSprite('environment/tent_blue_large.png');
        drawHeight = DrawHeight.MIDDLE;
        break;
      case FoiliageType.TENT_RED_1:
        sprite = this.spriteManager.getSprite('environment/tent_red.png');
        drawHeight = DrawHeight.MIDDLE;
        break;
      case FoiliageType.TENT_RED_2:
        sprite = this.spriteManager.getSprite('environment/tent_red_large.png');
        drawHeight = DrawHeight.MIDDLE;
        break;
      case FoiliageType.TREE_1:
        sprite = this.spriteManager.getSprite('environment/tree_large.png');
        drawHeight = DrawHeight.TOP;
        break;
      case FoiliageType.TREE_2:
        sprite = this.spriteManager.getSprite('environment/tree_small.png');
        drawHeight = DrawHeight.TOP;
        break;
      case FoiliageType.TRIBUNE:
        sprite = this.spriteManager.getSprite('environment/tribune_full.png');
        drawHeight = DrawHeight.BOTTOM;
        aspectRatio = 2;
        break;
    }
  }

  render(Canvas canvas, double tileSize, Offset center, double screenRange,
      DrawHeight drawHeight) {
    if (drawHeight != this.drawHeight) {
      return;
    }
    if (pow(center.dx - offset.dx, 2) + pow(center.dy - offset.dy, 2) >
        screenRange) {
      return;
    }
    if (sprite == null || !sprite.loaded()) {
      return;
    }

    canvas.save();
    canvas.translate(offset.dx * tileSize, offset.dy * tileSize);
    canvas.rotate(angle);
    sprite.renderCentered(canvas, Position(0, 0),
        size: Position(aspectRatio, 1) * size * tileSize);
    canvas.restore();
  }

  static Foiliage fromJson(
      Map<String, dynamic> json, SpriteManager spriteManager) {
    return Foiliage(SaveUtil.offsetFromJson(json['offset']), json['size'],
        getFoiliageTypeFromString(json['type']), spriteManager, json['angle']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = SaveUtil.offsetToJson(this.offset);
    data['size'] = this.size;
    data['type'] = this.type.toString();
    data['angle'] = this.angle;
    return data;
  }
}

FoiliageType getFoiliageTypeFromString(String foiliageTypeAsString) {
  for (FoiliageType element in FoiliageType.values) {
    if (element.toString() == foiliageTypeAsString) {
      return element;
    }
  }
  return null;
}

enum FoiliageType {
  ROCK_1,
  ROCK_2,
  ROCK_3,
  TENT_BLUE_1,
  TENT_BLUE_2,
  TENT_RED_1,
  TENT_RED_2,
  TREE_1,
  TREE_2,
  TRIBUNE
}

enum DrawHeight { BOTTOM, MIDDLE, TOP }
