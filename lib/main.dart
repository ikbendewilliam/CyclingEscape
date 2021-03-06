import 'package:CyclingEscape/views/gameManager.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flame/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  GameManager gameManager = new GameManager();
  runApp(app(gameManager.widget));
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setLandscape();
  gameManager.load();
}

Widget app(Widget gameWidget) => DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => gameWidget, // Wrap your app
    );
