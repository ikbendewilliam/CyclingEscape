import 'dart:async';

import 'package:cycling_escape/architecture.dart';
import 'package:cycling_escape/util/web/app_configurator.dart' if (dart.library.html) 'package:cycling_escape/util/web/app_configurator_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

Future<void> _setupCrashLogging() async {
  if (kIsWeb) return;
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
    configureWebApp();
    await _setupCrashLogging();
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
