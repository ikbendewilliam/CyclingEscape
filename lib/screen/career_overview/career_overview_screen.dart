import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_overview/career_overview_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget/results/result_list_item.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
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
          title: localization.careerOverviewTitle,
          onClosePressed: viewModel.onClosePressed,
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Column(
                children: [
                  SizedBox(
                    height: 32,
                    child: Row(
                      children: [
                        ...[
                          ResultsColumn.rank,
                          ResultsColumn.number,
                          ResultsColumn.name,
                          ResultsColumn.points,
                        ].map((e) => Expanded(
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
                    child: viewModel.currentResults.isEmpty
                        ? Center(
                            child: Text(
                              localization.careerOverviewNoResults,
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          )
                        : CyclingEscapeListView(
                            itemCount: viewModel.currentResults.length + (viewModel.teamResult == null ? 1 : 2),
                            itemBuilder: (context, index) {
                              if (index == viewModel.currentResults.length) return const SizedBox(height: 16);
                              final ResultData resultData;
                              final String time;
                              final String Function(int) numberToName;
                              final columns = [
                                ResultsColumn.rank,
                                index == viewModel.currentResults.length + 1 ? ResultsColumn.team : ResultsColumn.number,
                                ResultsColumn.name,
                                ResultsColumn.points,
                              ];
                              if (index == viewModel.currentResults.length + 1) {
                                resultData = viewModel.teamResult!;
                                time = resultData.time.toString();
                                numberToName = (_) => localization.yourTeam;
                              } else {
                                resultData = viewModel.currentResults[index];
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CyclingEscapeButton(
                        text: localization.careerOverviewRankings,
                        onClick: viewModel.onRankingsPressed,
                        type: CyclingEscapeButtonType.yellow,
                      ),
                      const SizedBox(width: 8),
                      CyclingEscapeButton(
                        text: localization.careerOverviewCalendar,
                        onClick: viewModel.onCalendarPressed,
                        type: CyclingEscapeButtonType.blue,
                      ),
                      const SizedBox(width: 8),
                      if (viewModel.isFinished) ...[
                        CyclingEscapeButton(
                          text: localization.careerOverviewFinish,
                          onClick: viewModel.onFinishPressed,
                          type: CyclingEscapeButtonType.green,
                        ),
                      ] else ...[
                        CyclingEscapeButton(
                          text: localization.careerOverviewReset,
                          onClick: viewModel.onResetPressed,
                          type: CyclingEscapeButtonType.red,
                        ),
                        const SizedBox(width: 8),
                        CyclingEscapeButton(
                          text: localization.careerOverviewStartNext,
                          onClick: viewModel.onNextRacePressed,
                          type: CyclingEscapeButtonType.green,
                        ),
                      ],
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
  void goToResetCareer() => MainNavigatorWidget.of(context).goToCareerReset();

  @override
  void goToCareerFinish() => MainNavigatorWidget.of(context).goToCareerFinish();

  @override
  void goToSelectRiders() => MainNavigatorWidget.of(context).goToCareerSelectRiders();
}
