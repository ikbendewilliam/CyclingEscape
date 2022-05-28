import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/viewmodel/change_cyclist_names/change_cyclist_names_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ChangeCyclistNamesScreen extends StatefulWidget {
  static const String routeName = 'change_cyclist_names';

  const ChangeCyclistNamesScreen({Key? key}) : super(key: key);

  @override
  ChangeCyclistNamesScreenState createState() => ChangeCyclistNamesScreenState();
}

class ChangeCyclistNamesScreenState extends State<ChangeCyclistNamesScreen> with BackNavigatorMixin implements ChangeCyclistNamesNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<ChangeCyclistNamesViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'Change Cyclist names',
          onClosePressed: viewModel.onClosePressed,
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Padding(
                padding: const EdgeInsets.only(left: 48, top: 16, bottom: 8),
                child: CyclingEscapeListView.children(
                  children: viewModel.names.entries.map(
                    (e) {
                      final teamId = Team.getIdFromCyclistNumber(e.key);
                      return TouchFeedBack(
                        onClick: () => viewModel.onEditNamePressed(e.key, e.value),
                        borderRadius: BorderRadius.circular(80),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Team.getColorFromId(teamId),
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: Row(
                            children: [
                              Text(
                                e.key.toString(),
                                style: theme.coreTextTheme.bodyNormal.copyWith(color: Team.getTextColorFromId(teamId)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    e.value,
                                    style: theme.coreTextTheme.bodyNormal.copyWith(color: Team.getTextColorFromId(teamId)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                ThemeAssets.iconEdit,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<String?> editName(String value) => MainNavigatorWidget.of(context).showEditNameDialog(value);
}
