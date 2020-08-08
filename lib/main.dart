import 'package:CyclingEscape/views/gameManager.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  GameManager gameManager = new GameManager();
  runApp(gameManager.widget);
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.landscapeLeft);
}
