import 'package:cycling_escape/database/cycling_escape_database.dart';
import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/navigator/route_names.dart';
import 'package:cycling_escape/util/keys.dart';
import 'package:cycling_escape/viewmodel/debug/debug_viewmodel.dart';
import 'package:cycling_escape/viewmodel/global/global_viewmodel.dart';
import 'package:cycling_escape/widget/debug/debug_row_item.dart';
import 'package:cycling_escape/widget/debug/debug_row_title.dart';
import 'package:cycling_escape/widget/debug/debug_switch_row_item.dart';
import 'package:cycling_escape/widget/debug/select_language_dialog.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:provider/provider.dart';

class DebugScreen extends StatefulWidget {
  static const String routeName = RouteNames.debugScreen;

  const DebugScreen({
    Key? key,
  }) : super(key: key);

  @override
  DebugScreenState createState() => DebugScreenState();
}

@visibleForTesting
class DebugScreenState extends State<DebugScreen> implements DebugNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<DebugViewModel>(
      consumerWithThemeAndLocalization: (context, viewModel, child, _, localization) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text(localization.settingsTitle),
        ),
        body: ResponsiveWidget(
          builder: (context, info) => ListView(
            children: [
              const DebugRowTitle(title: 'debugAnimationsTitle'),
              DebugRowSwitchItem(
                key: Keys.debugSlowAnimations,
                title: 'debugSlowAnimations',
                value: viewModel.slowAnimationsEnabled,
                onChanged: viewModel.onSlowAnimationsChanged,
              ),
              const DebugRowTitle(title: 'debugThemeTitle'),
              DebugRowItem(
                key: Keys.debugTargetPlatform,
                title: 'debugTargetPlatformTitle',
                subTitle: 'debugTargetPlatformSubtitle: ${Provider.of<GlobalViewModel>(context).getCurrentPlatform()}',
                onClick: viewModel.onTargetPlatformClicked,
              ),
              DebugRowItem(
                key: Keys.debugThemeMode,
                title: 'debugThemeModeTitle',
                subTitle: 'debugThemeModeSubtitle',
                onClick: viewModel.onThemeModeClicked,
              ),
              const DebugRowTitle(title: 'debugLocaleTitle'),
              DebugRowItem(
                key: Keys.debugSelectLanguage,
                title: 'debugLocaleSelector',
                subTitle: 'debugLocaleCurrentLanguage${Provider.of<GlobalViewModel>(context).getCurrentLanguage()}',
                onClick: viewModel.onSelectLanguageClicked,
              ),
              DebugRowSwitchItem(
                key: Keys.debugShowTranslations,
                title: 'debugShowTranslations',
                value: Provider.of<GlobalViewModel>(context, listen: false).showsTranslationKeys,
                onChanged: (_) => Provider.of<GlobalViewModel>(context, listen: false).toggleTranslationKeys(),
              ),
              const DebugRowTitle(title: 'debugLicensesTitle'),
              DebugRowItem(
                key: Keys.debugLicense,
                title: 'debugLicensesGoTo',
                onClick: viewModel.onLicensesClicked,
              ),
              const DebugRowTitle(title: 'debugDatabase'),
              DebugRowItem(
                key: Keys.debugDatabase,
                title: 'debugViewDatabase',
                onClick: goToDatabase,
              ),
            ],
          ),
        ),
      ),
      create: () => GetIt.I()..init(this),
    );
  }

  @override
  void goToTargetPlatformSelector() => MainNavigatorWidget.of(context).goToDebugPlatformSelector();

  @override
  void goToThemeModeSelector() => MainNavigatorWidget.of(context).goToThemeModeSelector();

  @override
  void goToLicenses() => MainNavigatorWidget.of(context).goToLicense();

  @override
  void goToSelectLanguage() => MainNavigatorWidget.of(context).showCustomDialog<void>(
        builder: (context) => SelectLanguageDialog(
          goBack: () => MainNavigatorWidget.of(context).closeDialog(),
        ),
      );

  void goToDatabase() {
    final db = GetIt.I<FlutterTemplateDatabase>();
    MainNavigatorWidget.of(context).goToDatabase(db);
  }
}
