import 'package:collection/collection.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:injectable/injectable.dart';

@singleton
class SpriteManager {
  final List<String> spriteNames = [];
  final sprites = <SpriteName>{};
  SpriteSheet? dices;
  bool loaded = false;
  bool loading = true;

  SpriteManager() {
    spriteNames.add('back_text_04.png');
    spriteNames.add('environment/grass.png');
    spriteNames.add('environment/grass2.png');
    spriteNames.add('left_arrow_01.png');
    spriteNames.add('left_arrow_02.png');
    spriteNames.add('right_arrow_01.png');
    spriteNames.add('right_arrow_02.png');
    spriteNames.add('left_arrow_02.png');
    spriteNames.add('right_arrow_02.png');
    spriteNames.add('icon_pause.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('back_slider.png');
    spriteNames.add('icon_mountain.png');
    spriteNames.add('icon_team.png');
    spriteNames.add('icon_time.png');
    spriteNames.add('icon_points.png');
    spriteNames.add('icon_rank.png');
    spriteNames.add('icon_number.png');
    spriteNames.add('icon_young.png');
    spriteNames.add('options_back_01.png');
    spriteNames.add('back_text_05.png');
    spriteNames.add('environment/rock1.png');
    spriteNames.add('environment/rock2.png');
    spriteNames.add('environment/rock3.png');
    spriteNames.add('environment/tent_blue.png');
    spriteNames.add('environment/tent_blue_large.png');
    spriteNames.add('environment/tent_red.png');
    spriteNames.add('environment/tent_red_large.png');
    spriteNames.add('environment/tree_large.png');
    spriteNames.add('environment/tree_small.png');
    spriteNames.add('environment/tribune_full.png');
    spriteNames.add('cyclists/rood.png');
    spriteNames.add('cyclists/rood2.png');
    spriteNames.add('cyclists/blauw.png');
    spriteNames.add('cyclists/blauw2.png');
    spriteNames.add('cyclists/zwart.png');
    spriteNames.add('cyclists/zwart2.png');
    spriteNames.add('cyclists/groen.png');
    spriteNames.add('cyclists/groen2.png');
    spriteNames.add('cyclists/bruin.png');
    spriteNames.add('cyclists/bruin2.png');
    spriteNames.add('cyclists/paars.png');
    spriteNames.add('cyclists/paars2.png');
    spriteNames.add('cyclists/grijs.png');
    spriteNames.add('cyclists/grijs2.png');
    spriteNames.add('cyclists/limoen.png');
    spriteNames.add('cyclists/limoen2.png');
    spriteNames.add('cyclists/geel.png');
    spriteNames.add('cyclists/geel2.png');
    spriteNames.add('cyclists/wit.png');
    spriteNames.add('cyclists/wit2.png');
    spriteNames.add('cyclists/lichtgroen.png');
    spriteNames.add('cyclists/lichtgroen2.png');
    spriteNames.add('cyclists/bollekes.png');
    spriteNames.add('cyclists/bollekes2.png');
  }

  Future<void> loadSprites() async {
    if (!loaded) {
      loaded = true;
      loading = true;
      dices ??= SpriteSheet.fromColumnsAndRows(image: await Flame.images.load('dice3.png'), columns: 16, rows: 9);
      await Future.wait(spriteNames.map((spriteName) async => sprites.add(SpriteName(spriteName, await Sprite.load(spriteName)))));
      spriteNames.clear();
      loading = false;
    }
  }

  double checkLoadingPercentage() => loading ? ((sprites.length + (dices == null ? 0 : 1)) / (spriteNames.length + 1)) : 100;

  SpriteSheet getDiceSpriteSheet() => dices!;

  Sprite? getSprite(String spriteName) => sprites.firstWhereOrNull((element) => element.name == spriteName)?.sprite;
}

class SpriteName {
  final String name;
  final Sprite sprite;

  SpriteName(this.name, this.sprite);
}
