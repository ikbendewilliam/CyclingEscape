import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/navigator/route_names.dart';
import 'package:cycling_escape/viewmodel/splash/splash_viewmodel.dart';
import 'package:cycling_escape/widget/general/status_bar.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_progress_indicator.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = RouteNames.splashScreen;

  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

@visibleForTesting
class SplashScreenState extends State<SplashScreen> implements SplashNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SplashViewModel>(
      create: () => GetIt.I()..init(this),
      consumerWithThemeAndLocalization: (context, viewModel, child, theme, localization) => StatusBar.light(
        child: Scaffold(
          backgroundColor: theme.colorsTheme.primary,
          body: const Center(
            child: FlutterTemplateProgressIndicator.light(),
          ),
        ),
      ),
    );
  }

  @override
  void goToHome() => MainNavigatorWidget.of(context).goToHome();
}
