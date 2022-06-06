import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_calendar/career_calendar_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CareerCalendarScreen extends StatefulWidget {
  static const String routeName = 'career_calendar';

  const CareerCalendarScreen({Key? key}) : super(key: key);

  @override
  CareerCalendarScreenState createState() => CareerCalendarScreenState();
}

class CareerCalendarScreenState extends State<CareerCalendarScreen> with BackNavigatorMixin implements CareerCalendarNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CareerCalendarViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: localization.careerCalendarTitle,
          onClosePressed: viewModel.onClosePressed,
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          localization.careerStandingsNumber,
                          style: theme.coreTextTheme.bodyNormal,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          localization.careerStandingsName,
                          style: theme.coreTextTheme.bodyNormal,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          localization.careerStandingsRaces,
                          style: theme.coreTextTheme.bodyNormal,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          localization.careerStandingsPoints,
                          style: theme.coreTextTheme.bodyNormal,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          localization.careerStandingsWinner,
                          style: theme.coreTextTheme.bodyNormal,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  Expanded(
                    child: CyclingEscapeListView(
                      itemCount: viewModel.calendarEvents.length,
                      itemBuilder: (context, index) {
                        final event = viewModel.calendarEvents[index];
                        final color =
                            event.winner == null || event.winner == 0 ? theme.colorsTheme.inverseText : Team.getTextColorFromId(Team.getIdFromCyclistNumber(event.winner!));
                        final backgroundColor = event.winner == null || event.winner == 0 ? Colors.white : Team.getColorFromId(Team.getIdFromCyclistNumber(event.winner!));
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  event.id.toString(),
                                  style: theme.coreTextTheme.bodyNormal.copyWith(color: color),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    localization.getTranslation(event.localizationKey),
                                    style: theme.coreTextTheme.bodyNormal.copyWith(color: color),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  event.playSettings.totalRaces.toString(),
                                  style: theme.coreTextTheme.bodyNormal.copyWith(color: color),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  event.points.toString(),
                                  style: theme.coreTextTheme.bodyNormal.copyWith(color: color),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    viewModel.numberToName(event.winner),
                                    style: theme.coreTextTheme.bodyNormal.copyWith(color: color),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
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
      ),
    );
  }
}
