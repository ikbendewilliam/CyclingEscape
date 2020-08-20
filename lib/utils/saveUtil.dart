import 'dart:convert';
import 'dart:ui';

import 'package:CyclingEscape/components/data/activeTour.dart';
import 'package:CyclingEscape/components/data/spriteManager.dart';
import 'package:CyclingEscape/views/cyclingView.dart';
import 'package:flame/position.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUtil {
  static void saveTour(ActiveTour activeTour) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('activeTour', jsonEncode(activeTour.toJson()));
  }

  static Future<ActiveTour> loadTour(SpriteManager spriteManager) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return ActiveTour.fromJson(
        jsonDecode(prefs.getString('activeTour')), spriteManager);
  }

  static Future<void> clearTour() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('activeTour');
  }

  static void saveCyclingView(CyclingView cyclingView) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('activeGame', jsonEncode(cyclingView.toJson()));
  }

  static Future<CyclingView> loadGame(SpriteManager spriteManager,
      Function cyclingEnded, Function navigate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return CyclingView.fromJson(jsonDecode(prefs.getString('activeGame')),
        spriteManager, cyclingEnded, navigate);
  }

  static Future<void> clearGame() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('activeGame');
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
