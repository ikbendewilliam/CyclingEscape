import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CanvasUtils {
  static void drawText(Canvas canvas, Offset offset, double angle, TextSpan textSpan) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(angle);
    double scale = 4;
    if (textSpan.style!.fontFamily == 'SaranaiGame') {
      scale = 2.8;
    }
    canvas.translate(-textSpan.text!.length * textSpan.style!.fontSize! / scale, 0);
    final TextPainter tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }
}

extension Vector2FromOffset on Vector2 {
  static Vector2 fromOffset(Offset offset) => Vector2(offset.dx, offset.dy);
}

extension RenderCentered on Sprite {
  void renderCentered(Canvas canvas, {required Vector2 position, required Vector2 size}) => render(canvas, position: position - size / 2.0, size: size);
}
