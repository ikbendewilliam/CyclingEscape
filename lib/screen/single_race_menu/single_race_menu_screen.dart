import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
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
                if (viewModel.showWarning) ...[
                  Text(
                    'Warning, this will result in a long race!',
                    style: theme.coreTextTheme.bodyUltraSmall,
                  ),
                ],
                CyclingEscapeButton(
                  text: 'Back',
                  onClick: viewModel.onBackClicked,
                  type: CyclingEscapeButtonType.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
