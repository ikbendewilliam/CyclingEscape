import 'dart:convert';
import 'dart:ui';

import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/repository/shared_prefs/local/local_storage.dart';
import 'package:cycling_escape/screen_game/cycling_view.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUtil {
  static const _cyclingViewKey = 'be.wive.cyclingescape.cyclingView';

  static void saveCyclingView(CyclingView cyclingView) async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.setString(_cyclingViewKey, jsonEncode(cyclingView.toJson()));
  }

  static CyclingView? loadCyclingView({
    required SpriteManager spriteManager,
    required LocalStorage localStorage,
    required VoidCallback onPause,
    required Localization localizations,
    required ValueChanged<List<Sprint>?> onEndCycling,
    required ValueChanged<TutorialType> openTutorial,
    required SelectFollow onSelectFollow,
  }) {
    final prefs = GetIt.I<SharedPreferences>();
    if (!prefs.containsKey(_cyclingViewKey)) return null;
    return CyclingView.fromJson(
      json: jsonDecode(prefs.getString(_cyclingViewKey) ?? '') as Map<String, dynamic>,
      spriteManager: spriteManager,
      localStorage: localStorage,
      onPause: onPause,
      localizations: localizations,
      onEndCycling: onEndCycling,
      openTutorial: openTutorial,
      onSelectFollow: onSelectFollow,
    );
  }

  static bool get hasCyclingView {
    final prefs = GetIt.I<SharedPreferences>();
    return prefs.containsKey(_cyclingViewKey);
  }

  static Future<void> clearCyclingView() async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.remove(_cyclingViewKey);
  }

  static Offset? offsetFromJson(Map<String, dynamic>? json) => json == null ? null : Offset(json['dx'] as double, json['dy'] as double);

  static Map<String, dynamic>? offsetToJson(Offset? offset) {
    if (offset == null) {
      return null;
    }
    final data = <String, dynamic>{};
    data['dx'] = offset.dx;
    data['dy'] = offset.dy;
    return data;
  }

  static Size? sizeFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Size(json['width'] as double, json['height'] as double);
  }

  static Map<String, dynamic>? sizeToJson(Size? size) {
    if (size == null) {
      return null;
    }
    final data = <String, dynamic>{};
    data['width'] = size.width;
    data['height'] = size.height;
    return data;
  }

  static Color? colorFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Color(json['color'] as int);
  }

  static Map<String, dynamic>? colorToJson(Color? color) {
    if (color == null) {
      return null;
    }
    final data = <String, dynamic>{};
    data['color'] = color.value;
    return data;
  }

  static Vector2? positionFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Vector2(json['x'] as double, json['y'] as double);
  }

  static Map<String, dynamic>? positionToJson(Vector2? position) {
    if (position == null) {
      return null;
    }
    final data = <String, dynamic>{};
    data['x'] = position.x;
    data['y'] = position.y;
    return data;
  }
}
