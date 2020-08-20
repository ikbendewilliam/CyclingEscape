import 'package:CyclingEscape/views/gameManager.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';

void main() async {
  GameManager gameManager = new GameManager();
  runApp(gameManager.widget);
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setLandscape();
  gameManager.load();
}
