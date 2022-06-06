import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_finish/career_finish_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CareerFinishScreen extends StatefulWidget {
  static const String routeName = 'career_finish';

  const CareerFinishScreen({Key? key}) : super(key: key);

  @override
  CareerFinishScreenState createState() => CareerFinishScreenState();
}

class CareerFinishScreenState extends State<CareerFinishScreen> implements CareerFinishNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CareerFinishViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'End of your career',
          wide: true,
          child: AspectRatio(
            aspectRatio: 2.1,
            child: Column(
              children: [
                Text(
                  viewModel.hasWonSingle ? 'You have the best rider in the world! Congratulations!' : 'The best rider in the world belongs to another team...',
                  style: theme.coreTextTheme.bodyNormal,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your best rider has ${viewModel.singlePoints} points',
                  style: theme.coreTextTheme.bodyNormal,
                ),
                const SizedBox(height: 8),
                Text(
                  viewModel.hasWonTeam ? 'You have the best team in the world! Congratulations!' : 'Another team is better...',
                  style: theme.coreTextTheme.bodyNormal,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your team has ${viewModel.teamPoints} points',
                  style: theme.coreTextTheme.bodyNormal,
                ),
                const SizedBox(height: 8),
                Text(
                  viewModel.hasWonSingle && viewModel.hasWonTeam
                      ? 'You have won the career mode! Congratulations! Feel free to share your score and try to defeat other players\' best score'
                      : 'You didn\'t win them all... Continue to reset the career mode and try again!',
                  style: theme.coreTextTheme.bodyNormal,
                ),
                const SizedBox(height: 8),
                CyclingEscapeButton(
                  text: 'Continue',
                  onClick: viewModel.onFinishPressed,
                  type: CyclingEscapeButtonType.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToHome() => MainNavigatorWidget.of(context).goToHome();
}
