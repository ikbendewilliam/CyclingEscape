import 'package:cycling_escape/app.dart';
import 'package:cycling_escape/architecture.dart';
import 'package:cycling_escape/di/environments.dart';
import 'package:cycling_escape/di/injectable.dart';
import 'package:cycling_escape/main_common.dart';
import 'package:cycling_escape/util/env/flavor_config.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await wrapMain(() async {
    await initArchitecture();
    const values = FlavorValues(
      baseUrl: 'https://jsonplaceholder.typicode.com/',
      logNetworkInfo: false,
      showFullErrorMessages: false,
    );
    FlavorConfig(
      flavor: Flavor.prod,
      name: 'PROD',
      color: Colors.transparent,
      values: values,
    );
    await configureDependencies(Environments.prod);
    // runApp(const MyApp());
    gameAppV1();
  });
}
