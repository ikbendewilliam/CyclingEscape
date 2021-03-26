import 'dart:ui';

import 'package:cycling_escape/components/data/resultData.dart';
import 'package:cycling_escape/components/data/results.dart';
import 'package:cycling_escape/components/moveable/cyclist.dart';
import 'package:cycling_escape/components/moveable/dice.dart';
import 'package:cycling_escape/components/ui/button.dart';
import 'package:cycling_escape/utils/canvasUtils.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class CyclingViewUI {
  static render(
      Canvas canvas,
      double? tileSize,
      Size? screenSize,
      Dice? dice,
      Dice? dice2,
      List<Button> buttons,
      List notifications,
      Sprite? backgroundNotification,
      Sprite? backgroundText,
      Sprite? iconTime,
      Sprite? iconRank,
      Sprite? iconPoints,
      Sprite? iconMountain,
      Cyclist? cyclist,
      Results? tempResults,
      double diceValueCooldown,
      int? diceValue) {
    if (dice != null) {
      dice.render(canvas, Offset(screenSize!.width / 2 - tileSize! * 2, screenSize.height / 2 - tileSize / 2), tileSize);
    }
    if (dice2 != null) {
      dice2.render(canvas, Offset(screenSize!.width / 2 + tileSize! * 2, screenSize.height / 2 - tileSize / 2), tileSize);
    }
    buttons.forEach((button) {
      button.render(canvas);
    });
    notifications.asMap().forEach((i, notification) {
      backgroundNotification!
          .render(canvas, position: Vector2(screenSize!.width - tileSize! * 3.7, tileSize * (i / 2 + 0.1)), size: Vector2(screenSize.width - tileSize * 3.8, tileSize * 0.5));
      TextSpan span = TextSpan(style: TextStyle(color: notification.color, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: notification.text);
      Offset position = Offset(screenSize.width - tileSize * 1.7, tileSize * (i / 2 + 0.1));
      CanvasUtils.drawText(canvas, position, 0, span);
    });
    if (tempResults != null && backgroundText != null) {
      ResultData? result = tempResults.data.firstWhereOrNull(((element) => element!.number == cyclist!.number));
      int? time = result?.time;
      int? rank = result?.rank;
      int? points = result?.points;
      int? mp = result?.mountain;
      backgroundText.render(canvas,
          position: Vector2(screenSize!.width / 2 - tileSize! * 3.1, screenSize.height - tileSize * 0.75), size: Vector2(tileSize * 6.2, tileSize * 0.75));

      Offset position = Offset(screenSize.width / 2 - tileSize * 1.75, screenSize.height - tileSize * 0.58);

      TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: '$rank');
      CanvasUtils.drawText(canvas, position, 0, span);
      iconRank!.render(canvas, position: Vector2FromOffset.fromOffset(position - Offset(tileSize, tileSize / 6)), size: Vector2(1, 1) * tileSize * 0.66);

      span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: '$time');
      position = position + Offset(tileSize * 1.5, 0);
      CanvasUtils.drawText(canvas, position, 0, span);
      iconTime!.render(canvas, position: Vector2FromOffset.fromOffset(position - Offset(tileSize, tileSize / 6)), size: Vector2(1, 1) * tileSize * 0.66);

      span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: '$points');
      position = position + Offset(tileSize * 1.5, 0);
      CanvasUtils.drawText(canvas, position, 0, span);
      iconPoints!.render(canvas, position: Vector2FromOffset.fromOffset(position - Offset(tileSize, tileSize / 6)), size: Vector2(1, 1) * tileSize * 0.66);

      span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 14.0, fontFamily: 'SaranaiGame'), text: '$mp');
      position = position + Offset(tileSize * 1.5, 0);
      CanvasUtils.drawText(canvas, position, 0, span);
      iconMountain!.render(canvas, position: Vector2FromOffset.fromOffset(position - Offset(tileSize, tileSize / 6)), size: Vector2(1, 1) * tileSize * 0.66);
    }
    if (diceValueCooldown > 0) {
      TextSpan span = TextSpan(style: TextStyle(color: Colors.white, fontSize: 100.0, fontFamily: 'SaranaiGame'), text: '$diceValue');
      CanvasUtils.drawText(canvas, Offset(screenSize!.width / 2, screenSize.height / 2), 0, span);
    }
  }
}
