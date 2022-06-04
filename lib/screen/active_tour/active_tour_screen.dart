import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/active_tour/active_tour_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget/results/result_list_item.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ActiveTourScreen extends StatefulWidget {
  static const String routeName = 'active_tour';

  const ActiveTourScreen({Key? key}) : super(key: key);

  @override
  ActiveTourScreenState createState() => ActiveTourScreenState();
}

class ActiveTourScreenState extends State<ActiveTourScreen> implements ActiveTourNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ActiveTourViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: localization.activeTourTitle,
          onClosePressed: viewModel.onClosePressed,
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Column(
                children: [
                  Text(
                    localization.activeTourStandings(viewModel.racesCompleted, viewModel.playSettings.totalRaces ?? 1),
                    style: theme.coreTextTheme.bodyNormal,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        ...ResultsType.race.columns.map((e) => Expanded(
                              flex: e.flex,
                              child: e.icon == null
                                  ? const SizedBox.shrink()
                                  : Image.asset(
                                      e.icon!,
                                      fit: BoxFit.contain,
                                    ),
                            )),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Expanded(
                    child: viewModel.racesCompleted == 0
                        ? Center(
                            child: Text(
                              localization.activeTourFirstRace,
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          )
                        : CyclingEscapeListView(
                            itemCount: viewModel.teamResults.length + (viewModel.teamResult == null ? 1 : 2),
                            itemBuilder: (context, index) {
                              if (index == viewModel.teamResults.length) return const SizedBox(height: 16);
                              final ResultData resultData;
                              final String time;
                              final String Function(int) numberToName;
                              final List<ResultsColumn> columns = [
                                ResultsColumn.rank,
                                index == viewModel.teamResults.length + 1 ? ResultsColumn.team : ResultsColumn.number,
                                ResultsColumn.name,
                                ResultsColumn.time,
                                ResultsColumn.points,
                                ResultsColumn.mountain,
                              ];
                              if (index == viewModel.teamResults.length + 1) {
                                resultData = viewModel.teamResult!;
                                time = resultData.time.toString();
                                numberToName = (_) => localization.yourTeam;
                              } else {
                                resultData = viewModel.teamResults[index];
                                time = resultData.rank == 0 ? resultData.time.toString() : '+${resultData.time - viewModel.firstTime}';
                                numberToName = viewModel.numberToName;
                              }
                              return ResultListItem(
                                index: resultData.rank,
                                time: time,
                                resultData: resultData,
                                columns: columns,
                                numberToName: numberToName,
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CyclingEscapeButton(
                        text: localization.mainMenuButton,
                        type: CyclingEscapeButtonType.blue,
                        onClick: viewModel.onClosePressed,
                      ),
                      const SizedBox(width: 8),
                      if (viewModel.racesCompleted < (viewModel.playSettings.totalRaces ?? 0)) ...[
                        CyclingEscapeButton(
                          text: localization.nextRaceButton,
                          type: CyclingEscapeButtonType.green,
                          onClick: viewModel.onStartRacePressed,
                        ),
                      ] else ...[
                        CyclingEscapeButton(
                          text: localization.finishButton,
                          type: CyclingEscapeButtonType.green,
                          onClick: viewModel.onFinishPressed,
                        ),
                      ],
                    ],
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
  void goToMainMenu() => MainNavigatorWidget.of(context).goToHome();

  @override
  void goToCareerOverview() => MainNavigatorWidget.of(context).goToCareerOverview();

  @override
  void goToRace(PlaySettings playSettings) => MainNavigatorWidget.of(context).goToGame(playSettings);
}
