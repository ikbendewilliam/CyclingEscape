import 'dart:convert';
import 'dart:ui';

import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/views/cyclingView.dart';
import 'package:CyclingEscape/views/menus/careerMenu.dart';
import 'package:CyclingEscape/views/menus/settingsMenu.dart';
import 'package:CyclingEscape/views/menus/tutorialView.dart';
import 'package:flame/position.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUtil {
  static void saveTour(ActiveTour activeTour) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('be.wive.cyclingescape.activeTour', jsonEncode(activeTour.toJson()));
  }

  static Future<ActiveTour> loadTour(SpriteManager spriteManager) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('be.wive.cyclingescape.activeTour')) {
      return null;
    }
    return ActiveTour.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.activeTour')), spriteManager);
  }

  static Future<void> clearTour() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('be.wive.cyclingescape.activeTour');
  }

  static void saveSettings(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('be.wive.cyclingescape.settings', jsonEncode(settings.toJson()));
  }

  static Future<Settings> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('be.wive.cyclingescape.settings')) {
      return null;
    }
    return Settings.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.settings')));
  }

  static void saveTutorialsViewed(TutorialsViewed tutorialsViewed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('be.wive.cyclingescape.tutorialsviewed', jsonEncode(tutorialsViewed.toJson()));
  }

  static Future<TutorialsViewed> loadTutorialsViewed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('be.wive.cyclingescape.tutorialsviewed')) {
      return null;
    }
    return TutorialsViewed.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.tutorialsviewed')));
  }

  static void saveCareer(Career career) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('be.wive.cyclingescape.career', jsonEncode(career.toJson()));
  }

  static Future<Career> loadCareer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('be.wive.cyclingescape.career')) {
      return null;
    }
    return Career.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.career')));
  }

  static void saveCyclingView(CyclingView cyclingView) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('be.wive.cyclingescape.activeGame', jsonEncode(cyclingView.toJson()));
  }

  static Future<CyclingView> loadCyclingView(SpriteManager spriteManager, Function cyclingEnded, Function navigate, Settings settings, Function openTutorial) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('be.wive.cyclingescape.activeGame')) {
      return null;
    }
    return CyclingView.fromJson(jsonDecode(prefs.getString('be.wive.cyclingescape.activeGame')), spriteManager, cyclingEnded, navigate, settings, openTutorial);
  }

  static Future<bool> hasCyclingView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('be.wive.cyclingescape.activeGame');
  }

  static Future<void> clearCyclingView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('be.wive.cyclingescape.activeGame');
  }

  static Offset offsetFromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Offset(json['dx'], json['dy']);
  }

  static Map<String, dynamic> offsetToJson(Offset offset) {
    if (offset == null) {
      return null;
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dx'] = offset.dx;
    data['dy'] = offset.dy;
    return data;
  }

  static Size sizeFromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Size(json['width'], json['height']);
  }

  static Map<String, dynamic> sizeToJson(Size size) {
    if (size == null) {
      return null;
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = size.width;
    data['height'] = size.height;
    return data;
  }

  static Color colorFromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Color(json['color']);
  }

  static Map<String, dynamic> colorToJson(Color color) {
    if (color == null) {
      return null;
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = color.value;
    return data;
  }

  static Position positionFromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Position(json['x'], json['y']);
  }

  static Map<String, dynamic> positionToJson(Position position) {
    if (position == null) {
      return null;
    }
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = position.x;
    data['y'] = position.y;
    return data;
  }
}
