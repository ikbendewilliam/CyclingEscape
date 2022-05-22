import 'package:cycling_escape/app.dart';
import 'package:cycling_escape/di/environments.dart';
import 'package:cycling_escape/di/injectable.dart';
import 'package:cycling_escape/main_common.dart';
import 'package:cycling_escape/util/env/flavor_config.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await wrapMain(() async {
    const values = FlavorValues(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      logNetworkInfo: false,
      showFullErrorMessages: true,
    );
    FlavorConfig(
      flavor: Flavor.dummy,
      name: 'DUMMY',
      color: Colors.purple,
      values: values,
    );
    // ignore: avoid_print
    print('Starting app from main_dummy.dart');
    await configureDependencies(Environments.dummy);
    startApp();
  });
}
