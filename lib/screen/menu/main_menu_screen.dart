import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/main_menu/main_menu_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MainMenuScreen extends StatefulWidget {
  static const routeName = 'main_menu';

  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> implements MainMenuNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<MainMenuViewModel>(
      create: () => GetIt.I<MainMenuViewModel>()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'Cycling Escape',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CyclingEscapeButton(
                  text: 'Continue',
                  onClick: null,
                  isEnabled: false,
                  type: CyclingEscapeButtonType.green,
                ),
                const CyclingEscapeButton(
                  text: 'Career',
                  onClick: null,
                  type: CyclingEscapeButtonType.yellow,
                ),
                CyclingEscapeButton(
                  text: 'Single race',
                  onClick: viewModel.onSingleRaceClicked,
                  type: CyclingEscapeButtonType.blue,
                ),
                CyclingEscapeButton(
                  text: 'Tour',
                  onClick: viewModel.onTourClicked,
                  type: CyclingEscapeButtonType.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToTourMenu() => MainNavigatorWidget.of(context).goToTourMenu();

  @override
  void goToSingleRaceMenu() => MainNavigatorWidget.of(context).goToSingleRaceMenu();
}