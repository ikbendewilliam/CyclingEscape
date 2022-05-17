import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/styles/theme_data.dart';
import 'package:cycling_escape/util/env/flavor_config.dart';
import 'package:cycling_escape/util/locale/localization_delegate.dart';
import 'package:cycling_escape/util/locale/localization_fallback_cupertino_delegate.dart';
import 'package:cycling_escape/viewmodel/global/global_viewmodel.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

void gameAppV1() async {
  runApp(const MyApp());
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const InternalApp();
  }
}

class InternalApp extends StatelessWidget {
  final Widget? home;

  const InternalApp({Key? key})
      : home = null,
        super(key: key);

  @visibleForTesting
  const InternalApp.test({required this.home, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<GlobalViewModel>(
      lazy: FlavorConfig.isInTest(),
      create: () => GetIt.I()..init(),
      consumer: (context, viewModel, consumerChild) => MaterialApp(
        debugShowCheckedModeBanner: !FlavorConfig.isInTest(),
        localizationsDelegates: [
          viewModel.localeDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FallbackCupertinoLocalisationsDelegate.delegate,
        ],
        locale: viewModel.locale,
        supportedLocales: LocalizationDelegate.supportedLocales,
        themeMode: viewModel.themeMode,
        theme: CyclingEscapeThemeData.lightTheme(viewModel.targetPlatform),
        darkTheme: CyclingEscapeThemeData.darkTheme(viewModel.targetPlatform),
        navigatorKey: MainNavigatorWidgetState.navigationKey,
        initialRoute: home == null ? MainNavigatorWidgetState.initialRoute : null,
        onGenerateRoute: MainNavigatorWidgetState.onGenerateRoute,
        navigatorObservers: MainNavigatorWidgetState.navigatorObservers,
        builder: home == null ? (context, child) => MainNavigatorWidget(child: child) : null,
        home: home,
      ),
    );
  }
}
