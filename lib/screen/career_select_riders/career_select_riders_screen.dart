import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_select_riders/career_select_riders_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CareerSelectRidersScreen extends StatefulWidget {
  static const String routeName = 'career_select_riders';

  const CareerSelectRidersScreen({Key? key}) : super(key: key);

  @override
  CareerSelectRidersScreenState createState() => CareerSelectRidersScreenState();
}

class CareerSelectRidersScreenState extends State<CareerSelectRidersScreen> with BackNavigatorMixin implements CareerSelectRidersNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CareerSelectRidersViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) {
        final event = viewModel.calendarEvent;
        return SimpleMenuScreen(
          child: MenuBox(
            title: 'Start next event',
            onClosePressed: viewModel.onClosePressed,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: AspectRatio(
                aspectRatio: 1.25,
                child: Column(
                  children: [
                    if (event != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'no.',
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(
                              event.id.toString(),
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Name',
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                localization.getTranslation(event.localizationKey),
                                style: theme.coreTextTheme.bodyNormal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Races',
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(
                              event.playSettings.totalRaces.toString(),
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Points',
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(
                              event.points.toString(),
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Length',
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(
                              localization.getTranslation(event.playSettings.mapLength.localizationKey),
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Type',
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(
                              localization.getTranslation(event.playSettings.mapType.localizationKey),
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Teams',
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(
                              event.playSettings.teams.toString(),
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Riders',
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: Text(
                              (event.playSettings.teams * event.playSettings.ridersPerTeam).toString(),
                              style: theme.coreTextTheme.bodyNormal,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Center(
                        child: CyclingEscapeButton(
                          onClick: viewModel.onStartPressed,
                          text: localization.startButton,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void goToGame(PlaySettings playSettings) => MainNavigatorWidget.of(context).goToGame(playSettings);
}
