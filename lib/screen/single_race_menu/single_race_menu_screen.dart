import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/styles/theme_colors.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:cycling_escape/viewmodel/single_race_menu/single_race_menu_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_value_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SingleRaceMenuScreen extends StatefulWidget {
  static const String routeName = 'single_race_menu';

  const SingleRaceMenuScreen({Key? key}) : super(key: key);

  @override
  SingleRaceMenuScreenState createState() => SingleRaceMenuScreenState();
}

class SingleRaceMenuScreenState extends State<SingleRaceMenuScreen> with BackNavigatorMixin implements SingleRaceMenuNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SingleRaceMenuViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'Configure race',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CyclingEscapeValueButton(
                  text: 'Teams: ${viewModel.teams}',
                  onChange: viewModel.setTeams,
                  value: viewModel.teams,
                  minValue: 2,
                  maxValue: 8,
                ),
                CyclingEscapeValueButton(
                  text: 'Cyclists: ${viewModel.teams * viewModel.cyclists}',
                  onChange: viewModel.setCyclists,
                  value: viewModel.cyclists,
                  minValue: 1,
                  maxValue: 5,
                ),
                CyclingEscapeValueButton(
                  text: viewModel.raceType,
                  onChange: viewModel.setRaceType,
                  value: viewModel.raceTypeIndex,
                  minValue: 0,
                  maxValue: MapType.values.length - 1,
                ),
                CyclingEscapeValueButton(
                  text: viewModel.raceLength,
                  onChange: viewModel.setRaceLength,
                  value: viewModel.raceLengthIndex,
                  minValue: 0,
                  maxValue: MapLength.values.length - 1,
                ),
                AnimatedOpacity(
                  opacity: viewModel.showWarning ? 1 : 0,
                  duration: ThemeDurations.shortAnimationDuration,
                  child: Text(
                    'Warning, this will result in a long race!',
                    style: theme.coreTextTheme.bodyUltraSmall.copyWith(color: ThemeColors.error),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CyclingEscapeButton(
                      text: 'Back',
                      onClick: viewModel.onBackClicked,
                      type: CyclingEscapeButtonType.red,
                    ),
                    const SizedBox(width: 8),
                    CyclingEscapeButton(
                      text: 'Start',
                      onClick: viewModel.onStartClicked,
                      type: CyclingEscapeButtonType.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToGame() => MainNavigatorWidget.of(context).goToGame();
}
