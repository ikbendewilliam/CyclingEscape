import 'package:cycling_escape/app.dart';
import 'package:cycling_escape/di/environments.dart';
import 'package:cycling_escape/di/injectable.dart';
import 'package:cycling_escape/main_common.dart';
import 'package:cycling_escape/util/env/flavor_config.dart';
import 'package:cycling_escape/util/inspector/niddler.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await wrapMain(() async {
    await initNiddler();
    const values = FlavorValues(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      logNetworkInfo: true,
      showFullErrorMessages: true,
    );
    FlavorConfig(
      flavor: Flavor.dev,
      name: 'DEV',
      color: Colors.red,
      values: values,
    );
    // ignore: avoid_print
    print('Starting app from main.dart');
    await configureDependencies(Environments.dev);

    startApp();
  });
}
