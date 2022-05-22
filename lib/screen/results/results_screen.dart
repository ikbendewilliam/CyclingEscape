import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/viewmodel/results/results_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        Image.asset(
                          ThemeAssets.iconNumber,
                          fit: BoxFit.contain,
                        ),
                        Image.asset(
                          ThemeAssets.iconMountain,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CyclingEscapeListView(
                      // itemCount: viewModel.sprints.last.cyclistPlaces.length,
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        // final place = viewModel.sprints.last.cyclistPlaces[index];
                        // return Row(children: [
                        //   Text(place?.cyclist?.number.toString() ?? ''),
                        //   Text(place?.value?.toString() ?? ''),
                        // ]);
                        final place = viewModel.sprints.last.cyclistPlaces[0];
                        return Row(children: [
                          Text(place?.cyclist?.number.toString() ?? ''),
                          Text(place?.value?.toString() ?? ''),
                        ]);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ThemeAssets.iconTime,
                          fit: BoxFit.contain,
                          color: theme.colorsTheme.primary,
                        ),
                        Image.asset(
                          ThemeAssets.iconMountain,
                          fit: BoxFit.contain,
                        ),
                        CyclingEscapeButton(
                          type: CyclingEscapeButtonType.iconNext,
                          onClick: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
