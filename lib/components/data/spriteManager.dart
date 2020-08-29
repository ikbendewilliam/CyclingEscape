import 'package:flame/sprite.dart';

class SpriteManager {
  final List<String> spriteNames = [];
  final List<SpriteName> sprites = [];
  final List<Sprite> diceSprites = [];
  bool loaded = false;
  bool loading = true;

  SpriteManager() {
    spriteNames.add('back_text_04.png');
    spriteNames.add('environment/grass.png');
    spriteNames.add('environment/grass2.png');
    spriteNames.add('green_button_01.png');
    spriteNames.add('green_button_02.png');
    spriteNames.add('yellow_button_01.png');
    spriteNames.add('yellow_button_02.png');
    spriteNames.add('black_button_01.png');
    spriteNames.add('black_button_02.png');
    spriteNames.add('blue_button_01.png');
    spriteNames.add('blue_button_02.png');
    spriteNames.add('red_button_01.png');
    spriteNames.add('red_button_02.png');
    spriteNames.add('left_arrow_01.png');
    spriteNames.add('left_arrow_02.png');
    spriteNames.add('right_arrow_01.png');
    spriteNames.add('right_arrow_02.png');
    spriteNames.add('left_arrow_02.png');
    spriteNames.add('right_arrow_02.png');
    spriteNames.add('icon_pause.png');
    spriteNames.add('icon_results.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_play.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_plus.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_plus_disabled.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_minus.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_minus_disabled.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_settings.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_yes.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_no.png');
    spriteNames.add('icon_pressed.png');
    spriteNames.add('icon_reload.png');
    spriteNames.add('icon_trash.png');
    spriteNames.add('switch_button_off.png');
    spriteNames.add('switch_button_on.png');
    spriteNames.add('back_results.png');
    spriteNames.add('back_text_01.png');
    spriteNames.add('back_slider.png');
    spriteNames.add('slider_front.png');
    spriteNames.add('icon_mountain.png');
    spriteNames.add('icon_team.png');
    spriteNames.add('icon_time.png');
    spriteNames.add('icon_points.png');
    spriteNames.add('icon_rank.png');
    spriteNames.add('icon_number.png');
    spriteNames.add('icon_young.png');
    spriteNames.add('options_back_01.png');
    spriteNames.add('back_text_02.png');
    spriteNames.add('back_text_05.png');
    spriteNames.add('back_tour.png');
    spriteNames.add('icon_credits.png');
    spriteNames.add('icon_help.png');
    spriteNames.add('cyclistSillouhette.png');
    spriteNames.add('cloud1.png');
    spriteNames.add('cloud2.png');
    spriteNames.add('cloud3.png');
    spriteNames.add('cloud4.png');
    spriteNames.add('cloud5.png');
    spriteNames.add('tardis.png');
    spriteNames.add('bg_1.png');
    spriteNames.add('bg_2.png');
    spriteNames.add('bg_3.png');
    spriteNames.add('bg_4.png');
    spriteNames.add('bar_green.png');
    spriteNames.add('bar_blue.png');
    spriteNames.add('bar_empty.png');
    spriteNames.add('bar_red.png');
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

  Future loadSprites() {
    return Future(() {
      if (!loaded) {
        loaded = true;
        spriteNames.forEach((spriteName) {
          sprites.add(SpriteName(spriteName, Sprite(spriteName)));
        });

        for (int j = 0; j < 9; j++) {
          for (int i = 0; i < ((j == 0 || j == 8) ? 1 : 16); i++) {
            diceSprites.add(Sprite('dice.png',
                x: 37.5 * i * 1,
                y: 37.5 * j * 1,
                height: 37 * 1.0,
                width: 37 * 1.0));
          }
        }
      }
    });
  }

  double checkLoadingPercentage() {
    if (!loading) {
      return 100;
    }
    loading = false;
    int spritesLoaded = 0;
    sprites.forEach((element) {
      if (element.sprite.loaded()) {
        spritesLoaded++;
      } else {
        loading = true;
      }
    });
    if (!loading) {
      return 100;
    }
    return 1 / (sprites.length + diceSprites.length) * spritesLoaded;
  }

  List<Sprite> getDiceSprites() {
    return this.diceSprites;
  }

  Sprite getSprite(spriteName) {
    SpriteName name = sprites.firstWhere(
        (element) => element.name == spriteName,
        orElse: () => null);
    if (name == null) {
      return null;
    }
    return name.sprite;
  }
}

class SpriteName {
  final String name;
  final Sprite sprite;

  SpriteName(this.name, this.sprite);
}
