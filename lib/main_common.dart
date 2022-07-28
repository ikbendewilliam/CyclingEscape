import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ffi';

import 'package:cycling_escape/architecture.dart';
import 'package:cycling_escape/util/web/app_configurator.dart' if (dart.library.html) 'package:cycling_escape/util/web/app_configurator_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';

Future<void> _setupCrashLogging() async {
  await Firebase.initializeApp();
  if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) unawaited(FirebaseCrashlytics.instance.sendUnsentReports());
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (errorDetails) async {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
    originalOnError?.call(errorDetails);
  };
}

FutureOr<R>? wrapMain<R>(FutureOr<R> Function() appCode) {
  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isWindows) {
      open.overrideFor(OperatingSystem.windows, _loadSqlLibrary);

      final db = sqlite3.openInMemory();
      db.dispose();
    } else {
      configureWebApp();
      await _setupCrashLogging();
    }
    await initArchitecture();

    return await appCode();
  }, (object, trace) {
    try {
      WidgetsFlutterBinding.ensureInitialized();
    } catch (_) {}

    try {
      staticLogger.e('Zone error', error: object, trace: trace);
    } catch (_) {
      // ignore: avoid_print
      print(object);
      // ignore: avoid_print
      print(trace);
    }

    try {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.recordError(object, trace);
      }
    } catch (_) {}
  });
}

DynamicLibrary _loadSqlLibrary() {
  final script = File(Platform.script.toFilePath(windows: true));
  // log(script.path, name: 'SCRIPT PATH');
  // log(script.parent.path, name: 'SCRIPT PARENT');
  final libraryNextToScript = File('${script.parent.path}\\assets\\dll\\sqlite3.dll');
  log(libraryNextToScript.path, name: 'SQLITE3 LIBRARY PATH');
  return DynamicLibrary.open(libraryNextToScript.path);
}
