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
      flavor: Flavor.beta,
      name: 'BETA',
      color: Colors.blue,
      values: values,
    );
    await configureDependencies(Environments.prod);
    // runApp(const MyApp());
    gameAppV1();
  });
}