import 'package:collection/collection.dart';
import 'package:cycling_escape/screen_game/cycling_view.dart';
import 'package:cycling_escape/util/canvas/canvas_utils.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/results.dart';
import 'package:cycling_escape/widget_game/moveable/cyclist.dart';
import 'package:cycling_escape/widget_game/moveable/dice.dart';
import 'package:cycling_escape/widget_game/ui/button.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Notification;

class CyclingViewUI {
  static ResultData? result;
  static ResultData? minTime;
  static String? time;
  static int? rank;
  static int? points;
  static int? mp;
  static Offset? lastPositionP1;

  static void render({
    required Canvas canvas,
    required double? tileSize,
    required Size? screenSize,
    required Dice? dice,
    required Dice? dice2,
    required List<Button> buttons,
    required List<Notification> notifications,
    required Sprite? backgroundNotification,
    required Sprite? backgroundText,
    required Sprite? iconTime,
    required Sprite? iconRank,
    required Sprite? iconPoints,
    required Sprite? iconMountain,
    required Cyclist? cyclist,
    required Results? tempResults,
    required double diceValueCooldown,
    required int? diceValue,
  }) {
    dice?.render(canvas, Offset(screenSize!.width / 2 - tileSize! * 2, screenSize.height / 2 - tileSize / 2), tileSize);
    dice2?.render(canvas, Offset(screenSize!.width / 2 + tileSize! * 2, screenSize.height / 2 - tileSize / 2), tileSize);
    for (final button in buttons) {
      button.render(canvas);
    }
    notifications.asMap().forEach((i, notification) {
      backgroundNotification!
          .render(canvas, position: Vector2(screenSize!.width - tileSize! * 3.7, tileSize * (i / 2 + 0.1)), size: Vector2(screenSize.width - tileSize * 3.8, tileSize * 0.5));
      final TextSpan span = TextSpan(style: TextStyle(color: notification.color, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: notification.text);
      final Offset position = Offset(screenSize.width - tileSize * 1.7, tileSize * (i / 2 + 0.1));
      CanvasUtils.drawText(canvas, position, 0, span);
    });
    if (tempResults != null) {
      if (cyclist?.lastPosition?.p1 != lastPositionP1) {
        lastPositionP1 = cyclist?.lastPosition?.p1;
        result = tempResults.data.firstWhereOrNull(((element) => element.number == cyclist?.number));
        minTime = tempResults.data.reduce(((a, b) => a.time < b.time ? a : b));
        time = result?.rank == 1 ? result?.time.toString() : '+${(result?.time ?? 0) - minTime!.time}';
        rank = result?.rank;
        points = result?.points;
        mp = result?.mountain;
      }
      backgroundText?.render(
        canvas,
        position: Vector2(screenSize!.width / 2 - tileSize! * 3.1, screenSize.height - tileSize * 0.75),
        size: Vector2(tileSize * 6.2, tileSize * 0.75),
      );

      var position = Offset(screenSize!.width / 2 - tileSize! * 1.75, screenSize.height - tileSize * 0.58);
      var span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: '$rank');
      CanvasUtils.drawText(canvas, position, 0, span);
      iconRank?.render(canvas, position: Vector2FromOffset.fromOffset(position - Offset(tileSize, tileSize / 6)), size: Vector2(1, 1) * tileSize * 0.66);

      span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: '$time');
      position = position + Offset(tileSize * 1.5, 0);
      CanvasUtils.drawText(canvas, position, 0, span);
      iconTime?.render(canvas, position: Vector2FromOffset.fromOffset(position - Offset(tileSize, tileSize / 6)), size: Vector2(1, 1) * tileSize * 0.66);

      span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: '$points');
      position = position + Offset(tileSize * 1.5, 0);
      CanvasUtils.drawText(canvas, position, 0, span);
      iconPoints?.render(canvas, position: Vector2FromOffset.fromOffset(position - Offset(tileSize, tileSize / 6)), size: Vector2(1, 1) * tileSize * 0.66);

      span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: '$mp');
      position = position + Offset(tileSize * 1.5, 0);
      CanvasUtils.drawText(canvas, position, 0, span);
      iconMountain?.render(canvas, position: Vector2FromOffset.fromOffset(position - Offset(tileSize, tileSize / 6)), size: Vector2(1, 1) * tileSize * 0.66);
    }
    if (diceValueCooldown > 0) {
      final TextSpan span = TextSpan(style: const TextStyle(color: Colors.white, fontSize: 100.0, fontFamily: 'SaranaiGame'), text: '$diceValue');
      CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, screenSize.height / 2), 0, span);
    }
  }
}
