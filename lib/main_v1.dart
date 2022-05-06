import 'package:cycling_escape/screen_game/gameManager.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

late final GameManager gameManager;

void main() async {
  gameManager = GameManager();
  runApp(app());
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
}

Widget app() => MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('nl'),
        Locale('fr'),
        Locale('es'),
      ],
      home: Builder(
        builder: (context) {
          gameManager.load(Localization.of(context));
          return GameWidget(game: gameManager);
        },
      ),
    );
