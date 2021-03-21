import 'package:CyclingEscape/views/gameManager.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const disableDevicePreview = true;

void main() async {
  final gameManager = new GameManager();
  runApp(app(GameWidget(game: gameManager)));
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  gameManager.load();
}

Widget app(Widget gameWidget) => MaterialApp(
      localizationsDelegates: [
        // TODO: uncomment the line below after codegen
        // AppLocalizations.delegate,
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
      home: disableDevicePreview
          ? gameWidget
          : DevicePreview(
              enabled: !kReleaseMode,
              builder: (context) => gameWidget, // Wrap your app
            ),
    );
