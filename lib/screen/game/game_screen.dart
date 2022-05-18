import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/viewmodel/game/game_viewmodel.dart';
import 'package:cycling_escape/widget/game/pause_widget.dart';
import 'package:cycling_escape/widget/game/tutorial_widget.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = 'game';
  final PlaySettings playSettings;

  const GameScreen({
    required this.playSettings,
    Key? key,
  }) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> implements GameNavigator {
  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderLocalization: (context, localization) => ProviderWidget<GameViewModel>(
        create: () => GetIt.I()..init(this, localization, widget.playSettings),
        childBuilderWithViewModel: (context, viewModel, theme, _) {
          return Stack(
            children: [
              IgnorePointer(
                ignoring: viewModel.ignorePointer,
                child: viewModel.gameWidget,
              ),
              if (viewModel.isPaused)
                PauseWidget(
                  onContinue: viewModel.onContinue,
                  onSave: viewModel.onSave,
                  onStop: viewModel.onStop,
                ),
              if (viewModel.tutorialType != null)
                TutorialWidget(
                  tutorialType: viewModel.tutorialType!,
                  onDismiss: viewModel.onTutorialDismiss,
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Future<void> openTutorial(TutorialType type) async => print('opening tutorial');
}
