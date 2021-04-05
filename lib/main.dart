import 'package:cycling_escape/views/gameManager.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late final GameManager gameManager;

void main() async {
  gameManager = GameManager();
  runApp(app());
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
}

Widget app() => MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('nl'),
        const Locale('fr'),
        const Locale('es'),
      ],
      home: Builder(
        builder: (context) {
          gameManager.load(AppLocalizations.of(context)!);
          return GameWidget(game: gameManager);
        },
      ),
    );
