import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_overview/career_overview_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CareerOverviewScreen extends StatefulWidget {
  static const String routeName = 'career_overview';

  const CareerOverviewScreen({Key? key}) : super(key: key);

  @override
  CareerOverviewScreenState createState() => CareerOverviewScreenState();
}

class CareerOverviewScreenState extends State<CareerOverviewScreen> implements CareerOverviewNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CareerOverviewViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'career',
          onClosePressed: viewModel.onClosePressed,
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CyclingEscapeButton(
                        text: 'Rankings',
                        onClick: viewModel.onRankingsPressed,
                        type: CyclingEscapeButtonType.yellow,
                      ),
                      const SizedBox(width: 8),
                      CyclingEscapeButton(
                        text: 'Calendar',
                        onClick: viewModel.onCalendarPressed,
                        type: CyclingEscapeButtonType.blue,
                      ),
                      const SizedBox(width: 8),
                      CyclingEscapeButton(
                        text: 'Next Race',
                        onClick: viewModel.onNextRacePressed,
                        type: CyclingEscapeButtonType.green,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToMainMenu() => MainNavigatorWidget.of(context).goToHome();

  @override
  void goToCalendar() => MainNavigatorWidget.of(context).goToCareerCalendar();

  @override
  void goToRankings() => MainNavigatorWidget.of(context).goToCareerStandings();

  @override
  void goToSelectRiders() => MainNavigatorWidget.of(context).goToCareerSelectRiders();
}
