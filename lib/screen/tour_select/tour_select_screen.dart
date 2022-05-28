import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/model/gamedata/tour.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/styles/theme_colors.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:cycling_escape/viewmodel/tour_select/tour_select_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_value_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TourSelectScreen extends StatefulWidget {
  static const String routeName = 'tour_select';

  const TourSelectScreen({Key? key}) : super(key: key);

  @override
  TourSelectScreenState createState() => TourSelectScreenState();
}

class TourSelectScreenState extends State<TourSelectScreen> with BackNavigatorMixin implements TourSelectNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TourSelectViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'Configure tour',
          onClosePressed: viewModel.onBackClicked,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Padding(
                padding: const EdgeInsets.only(left: 48, top: 16, bottom: 8),
                child: CyclingEscapeListView.children(
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
                    CyclingEscapeValueButton(
                      text: 'races: ${viewModel.races}',
                      onChange: viewModel.setRaces,
                      value: viewModel.races,
                      minValue: 2,
                      maxValue: 8,
                    ),
                    AnimatedOpacity(
                      opacity: viewModel.showWarning ? 1 : 0,
                      duration: ThemeDurations.shortAnimationDuration,
                      child: Text(
                        'Warning, this will result in long races!',
                        style: theme.coreTextTheme.bodyUltraSmall.copyWith(color: ThemeColors.error),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: CyclingEscapeButton(
                        text: 'Start',
                        onClick: viewModel.onStartClicked,
                        type: CyclingEscapeButtonType.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToTourOverview(Tour playSettings) {
    // TODO: implement goToTourOverview
  }
}
