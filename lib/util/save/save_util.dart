import 'dart:convert';
import 'dart:ui';

import 'package:cycling_escape/screen_game/cycling_view.dart';
import 'package:cycling_escape/screen_game/game_manager.dart';
import 'package:cycling_escape/screen_game/menus/career_menu.dart';
import 'package:cycling_escape/screen_game/menus/settings_menu.dart';
import 'package:cycling_escape/screen_game/menus/tutorial_view.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:cycling_escape/widget_game/data/active_tour.dart';
import 'package:cycling_escape/widget_game/data/sprite_manager.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUtil {
  static void saveTour(ActiveTour activeTour) async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.setString('be.wive.cyclingescape.activeTour', jsonEncode(activeTour.toJson()));
  }

  static Future<ActiveTour?> loadTour(SpriteManager spriteManager) async {
    final prefs = GetIt.I<SharedPreferences>();
    if (!prefs.containsKey('be.wive.cyclingescape.activeTour')) {
      return null;
    }
    return ActiveTour.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.activeTour') ?? '') as Map<String, dynamic>, spriteManager);
  }

  static Future<void> clearTour() async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.remove('be.wive.cyclingescape.activeTour');
  }

  static void saveSettings(Settings settings) async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.setString('be.wive.cyclingescape.settings', jsonEncode(settings.toJson()));
  }

  static Future<Settings?> loadSettings() async {
    final prefs = GetIt.I<SharedPreferences>();
    if (!prefs.containsKey('be.wive.cyclingescape.settings')) {
      return null;
    }
    return Settings.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.settings') ?? '') as Map<String, dynamic>);
  }

  static void saveTutorialsViewed(TutorialsViewed tutorialsViewed) async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.setString('be.wive.cyclingescape.tutorialsviewed', jsonEncode(tutorialsViewed.toJson()));
  }

  static Future<TutorialsViewed?> loadTutorialsViewed() async {
    final prefs = GetIt.I<SharedPreferences>();
    if (!prefs.containsKey('be.wive.cyclingescape.tutorialsviewed')) {
      return null;
    }
    return TutorialsViewed.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.tutorialsviewed') ?? '') as Map<String, dynamic>);
  }

  static void saveCareer(Career career) async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.setString('be.wive.cyclingescape.career', jsonEncode(career.toJson()));
  }

  static Future<Career?> loadCareer() async {
    final prefs = GetIt.I<SharedPreferences>();
    if (!prefs.containsKey('be.wive.cyclingescape.career')) {
      return null;
    }
    return Career.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.career') ?? '') as Map<String, dynamic>);
  }

  static void saveCyclingView(CyclingView cyclingView) async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.setString('be.wive.cyclingescape.activeGame', jsonEncode(cyclingView.toJson()));
  }

  static Future<CyclingView?> loadCyclingView(
    SpriteManager spriteManager,
    Function cyclingEnded,
    NavigateType navigate,
    Settings settings,
    Localization localizations,
    Function openTutorial,
  ) async {
    final prefs = GetIt.I<SharedPreferences>();
    if (!prefs.containsKey('be.wive.cyclingescape.activeGame')) {
      return null;
    }
    return CyclingView.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.activeGame') ?? '') as Map<String, dynamic>, spriteManager, cyclingEnded, navigate, settings,
        localizations, openTutorial);
  }

  static Future<bool> hasCyclingView() async {
    final prefs = GetIt.I<SharedPreferences>();
    return prefs.containsKey('be.wive.cyclingescape.activeGame');
  }

  static Future<void> clearCyclingView() async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.remove('be.wive.cyclingescape.activeGame');
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
