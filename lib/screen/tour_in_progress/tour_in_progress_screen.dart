import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/tour_in_progress/tour_in_progress_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TourInProgressScreen extends StatefulWidget {
  static const String routeName = 'tour_in_progress';

  const TourInProgressScreen({Key? key}) : super(key: key);

  @override
  TourInProgressScreenState createState() => TourInProgressScreenState();
}

class TourInProgressScreenState extends State<TourInProgressScreen> with BackNavigatorMixin implements TourInProgressNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TourInProgressViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'Tour in progress',
          onClosePressed: viewModel.onClosePressed,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(8),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'There is already a tour in progress, do you want to continue or start a new one?',
                    style: theme.coreTextTheme.bodyNormal,
                  ),
                  const Spacer(),
                  CyclingEscapeButton(
                    text: 'Continue',
                    type: CyclingEscapeButtonType.green,
                    onClick: viewModel.onContinuePressed,
                  ),
                  CyclingEscapeButton(
                    text: 'Start new tour',
                    onClick: viewModel.onNewTourPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToActiveTour() => MainNavigatorWidget.of(context).goToActiveTour();

  @override
  void goToSelectTour() => MainNavigatorWidget.of(context).goToTourSelect();
}
