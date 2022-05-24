import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/viewmodel/results/results_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget/results/results_bottom_navigation.dart';
import 'package:cycling_escape/widget_game/positions/sprint.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ResultsScreen extends StatefulWidget {
  static const String routeName = 'results';
  final List<Sprint> sprints;

  const ResultsScreen({
    required this.sprints,
    super.key,
  });

  @override
  ResultsScreenState createState() => ResultsScreenState();
}

class ResultsScreenState extends State<ResultsScreen> implements ResultsNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ResultsViewModel>(
      create: () => GetIt.I()..init(this, widget.sprints),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'Results',
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: viewModel.controller,
                      itemCount: viewModel.results.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, resultIndex) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 32,
                              child: Row(
                                children: [
                                  ...[
                                    ThemeAssets.iconRank,
                                    ThemeAssets.iconNumber,
                                    ThemeAssets.iconTime,
                                    ThemeAssets.iconPoints,
                                    ThemeAssets.iconMountain,
                                  ].map((e) => Expanded(
                                        child: Image.asset(
                                          e,
                                          fit: BoxFit.contain,
                                        ),
                                      )),
                                  const SizedBox(width: 32),
                                ],
                              ),
                            ),
                            Expanded(
                              child: CyclingEscapeListView(
                                itemCount: viewModel.results[resultIndex].data.length,
                                itemBuilder: (context, index) {
                                  final resultData = viewModel.results[resultIndex].data[index];
                                  if (resultData == null) return Container();
                                  String? time;
                                  if (index == 0) {
                                    time = resultData.time.toString();
                                  } else if (resultData.time != viewModel.results[resultIndex].data[index - 1]?.time) {
                                    final firstTurns = viewModel.results[resultIndex].data.first!.time;
                                    time = '+${resultData.time - firstTurns}';
                                  }
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: resultData.team?.getColor(),
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: Row(
                                      children: [
                                        (index + 1).toString(),
                                        resultData.number.toString(),
                                        time,
                                        resultData.points == 0 ? '' : resultData.points.toString(),
                                        resultData.mountain == 0 ? '' : resultData.mountain.toString(),
                                      ]
                                          .map((e) => Expanded(
                                                child: Text(
                                                  e ?? '',
                                                  style: theme.coreTextTheme.bodyNormal, // .copyWith(color: resultData.team?.getColor()),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ResultsBottomNavigation(controller: viewModel.controller),
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
}
