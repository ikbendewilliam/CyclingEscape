import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_standings/career_standings_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget/results/result_list_item.dart';
import 'package:cycling_escape/widget/results/results_bottom_navigation.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CareerStandingsScreen extends StatefulWidget {
  static const String routeName = 'career_standings';

  const CareerStandingsScreen({Key? key}) : super(key: key);

  @override
  CareerStandingsScreenState createState() => CareerStandingsScreenState();
}

class CareerStandingsScreenState extends State<CareerStandingsScreen> with BackNavigatorMixin implements CareerStandingsNavigator {
  final pages = const [ResultsType.time, ResultsType.team];

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CareerStandingsViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: localization.careerStandingsTitle,
          onClosePressed: viewModel.onClosePressed,
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: viewModel.racesCompleted == 0
                  ? Center(
                      child: Text(
                        localization.careerStandingsNoRacesCompleted,
                        style: theme.coreTextTheme.bodyNormal,
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          localization.careerStandingsRacesCompleted(viewModel.racesCompleted),
                          style: theme.coreTextTheme.bodyNormal,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: PageView.builder(
                            controller: viewModel.controller,
                            itemCount: pages.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, resultIndex) {
                              final List<ResultData> results;
                              final List<ResultsColumn> columns;
                              if (resultIndex == 0) {
                                results = viewModel.currentResults;
                                columns = ResultsType.points.columns;
                              } else {
                                results = viewModel.teamResults;
                                columns = [ResultsColumn.rank, ResultsColumn.team, ResultsColumn.points];
                              }
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 32,
                                    child: Row(
                                      children: [
                                        ...columns.map((e) => Expanded(
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
                                    child: CyclingEscapeListView(
                                      itemCount: results.length,
                                      itemBuilder: (context, index) {
                                        final resultData = results[index];
                                        return ResultListItem(
                                          index: resultData.rank,
                                          resultData: resultData,
                                          columns: columns,
                                          numberToName: viewModel.numberToName,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        ResultsBottomNavigation(
                          controller: viewModel.controller,
                          pages: pages,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
