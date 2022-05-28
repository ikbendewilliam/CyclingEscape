import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/results/results_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget/results/results_bottom_navigation.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
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
  String _getValue(ResultsColumn column, int index, ResultData resultData, String? time, String Function(int) numberToName) {
    switch (column) {
      case ResultsColumn.rank:
        return (index + 1).toString();
      case ResultsColumn.number:
        return resultData.number.toString();
      case ResultsColumn.name:
        return numberToName(resultData.number);
      case ResultsColumn.team:
        return resultData.team?.cyclists.first?.number.toString().replaceFirst('1', '0') ?? '';
      case ResultsColumn.time:
        return time ?? '';
      case ResultsColumn.points:
        return resultData.points == 0 ? '' : resultData.points.toString();
      case ResultsColumn.mountain:
        return resultData.mountain == 0 ? '' : resultData.mountain.toString();
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ResultsViewModel>(
      create: () => GetIt.I()..init(this, widget.sprints),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => WillPopScope(
        onWillPop: () async {
          viewModel.onClosePressed();
          return false;
        },
        child: SimpleMenuScreen(
          child: MenuBox(
            title: 'Results',
            onClosePressed: viewModel.onClosePressed,
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
                        itemBuilder: (context, resultIndex) {
                          final results = viewModel.results[resultIndex];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 32,
                                  child: Row(
                                    children: [
                                      ...?results.type?.columns.map((e) => Expanded(
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
                                    itemCount: results.data.length,
                                    itemBuilder: (context, index) {
                                      final resultData = results.data[index];
                                      if (resultData == null) return Container();
                                      String? time;
                                      if (index == 0) {
                                        time = resultData.time.toString();
                                      } else if (resultData.time != results.data[index - 1]?.time) {
                                        final firstTurns = results.data.first!.time;
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
                                          children: results.type?.columns.map((e) {
                                                Widget text = Text(
                                                  _getValue(e, index, resultData, time, viewModel.numberToName),
                                                  style: theme.coreTextTheme.bodyNormal.copyWith(color: resultData.team?.getTextColor()),
                                                  textAlign: e.textAlign,
                                                );
                                                if (e.useFittedBox) {
                                                  text = FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment: e.textAlign == TextAlign.start ? Alignment.centerLeft : Alignment.center,
                                                    child: text,
                                                  );
                                                }
                                                return Expanded(
                                                  flex: e.flex,
                                                  child: text,
                                                );
                                              }).toList() ??
                                              [],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    ResultsBottomNavigation(
                      controller: viewModel.controller,
                      pages: viewModel.results.map((e) => e.type).whereType<ResultsType>().toList(),
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
  void goToMainMenu() => MainNavigatorWidget.of(context).goToHome();
}
