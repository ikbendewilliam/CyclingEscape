import 'package:cycling_escape/navigator/main_navigation.dart';
import 'package:cycling_escape/screen/debug/debug_platform_selector_screen.dart';
import 'package:cycling_escape/screen/debug/debug_screen.dart';
import 'package:cycling_escape/screen/license/license_screen.dart';
import 'package:cycling_escape/screen/menu/main_menu_screen.dart';
import 'package:cycling_escape/screen/single_race_menu/single_race_menu_screen.dart';
import 'package:cycling_escape/screen/splash/splash_screen.dart';
import 'package:cycling_escape/screen/theme_mode/theme_mode_selector.dart';
import 'package:cycling_escape/screen/tour_menu/tour_menu_screen.dart';
import 'package:cycling_escape/util/env/flavor_config.dart';
import 'package:cycling_escape/widget/general/flavor_banner.dart';
import 'package:cycling_escape/widget/general/text_scale_factor.dart';
import 'package:drift/drift.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class MainNavigatorWidget extends StatefulWidget {
  final Widget? child;

  const MainNavigatorWidget({
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  MainNavigatorWidgetState createState() => MainNavigatorWidgetState();

  static MainNavigationMixin of(BuildContext context, {bool rootNavigator = false}) {
    final navigator = rootNavigator ? context.findRootAncestorStateOfType<MainNavigationMixin>() : context.findAncestorStateOfType<MainNavigationMixin>();
    assert(() {
      if (navigator == null) {
        throw FlutterError('MainNavigation operation requested with a context that does not include a MainNavigation.\n'
            'The context used to push or pop routes from the MainNavigation must be that of a '
            'widget that is a descendant of a MainNavigatorWidget widget.');
      }
      return true;
    }());
    return navigator!;
  }
}

class MainNavigatorWidgetState extends State<MainNavigatorWidget> with MainNavigationMixin {
  static final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  static final List<NavigatorObserver> _navigatorObservers = [];

  static String get initialRoute => FlavorConfig.isInTest() ? 'test_route' : SplashScreen.routeName;

  static GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  static List<NavigatorObserver> get navigatorObservers => _navigatorObservers;

  NavigatorState get _navigator => _navigationKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return TextScaleFactor(
      child: widget.child ?? const SizedBox.shrink(),
    );
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    final strippedPath = settings.name?.replaceFirst('/', '');
    switch (strippedPath) {
      case '':
      case SplashScreen.routeName:
        return MaterialPageRoute<void>(builder: (context) => const FlavorBanner(child: SplashScreen()), settings: settings);
      case MainMenuScreen.routeName:
        return FadeInRoute<void>(child: const FlavorBanner(child: MainMenuScreen()), settings: settings);
      case DebugPlatformSelectorScreen.routeName:
        return MaterialPageRoute<void>(builder: (context) => const FlavorBanner(child: DebugPlatformSelectorScreen()), settings: settings);
      case ThemeModeSelectorScreen.routeName:
        return MaterialPageRoute<void>(builder: (context) => const FlavorBanner(child: ThemeModeSelectorScreen()), settings: settings);
      case DebugScreen.routeName:
        return MaterialPageRoute<void>(builder: (context) => const FlavorBanner(child: DebugScreen()), settings: settings);
      case LicenseScreen.routeName:
        return MaterialPageRoute<void>(builder: (context) => const FlavorBanner(child: LicenseScreen()), settings: settings);
      case 'test_route':
        if (!FlavorConfig.isInTest()) return null;
        return MaterialPageRoute<void>(builder: (context) => FlavorBanner(child: Container(color: Colors.grey)), settings: settings);
      case SingleRaceMenuScreen.routeName:
        return PageRouteBuilder<void>(pageBuilder: (context, animation, secondaryAnimation) => const FlavorBanner(child: SingleRaceMenuScreen()), settings: settings);
      case TourMenuScreen.routeName:
        return PageRouteBuilder<void>(pageBuilder: (context, animation, secondaryAnimation) => const FlavorBanner(child: TourMenuScreen()), settings: settings);
      default:
        return null;
    }
  }

  @override
  void goToSplash() => _navigator.pushReplacementNamed(SplashScreen.routeName);

  @override
  void goToHome() => _navigator.pushReplacementNamed(MainMenuScreen.routeName);

  @override
  void goToDebugPlatformSelector() => _navigator.pushNamed(DebugPlatformSelectorScreen.routeName);

  @override
  void goToThemeModeSelector() => _navigator.pushNamed(ThemeModeSelectorScreen.routeName);

  @override
  void goToDebug() => _navigator.pushNamed(DebugScreen.routeName);

  @override
  void goToLicense() => _navigator.pushNamed(LicenseScreen.routeName);

  @override
  void closeDialog() => _navigator.pop();

  @override
  void goToDatabase(GeneratedDatabase db) => _navigator.push<MaterialPageRoute>(MaterialPageRoute(builder: (context) => DriftDbViewer(db)));

  @override
  void goBack<T>({T? result}) => _navigator.pop(result);

  @override
  void goToSingleRaceMenu() => _navigator.pushNamed(SingleRaceMenuScreen.routeName);

  @override
  void goToTourMenu() => _navigator.pushNamed(TourMenuScreen.routeName);

  @override
  void showCustomDialog<T>({required WidgetBuilder builder}) => showDialog<T>(context: _navigationKey.currentContext!, builder: builder, useRootNavigator: true);
}