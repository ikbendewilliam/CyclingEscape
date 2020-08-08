import 'dart:ui';

import 'package:flutter/material.dart';

class CanvasUtils {
  static void drawText(
      Canvas canvas, Offset offset, double angle, TextSpan textSpan) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(angle);
    double scale = 4;
    if (textSpan.style.fontFamily == 'SaranaiGame') {
      scale = 2.8;
    }
    canvas.translate(
        -textSpan.text.length * textSpan.style.fontSize / scale, 0);
    TextPainter tp =
        new TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(0.0, 0.0));
    canvas.restore();
  }
}
