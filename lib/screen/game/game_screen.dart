import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/viewmodel/game/game_viewmodel.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:flame/game.dart';
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
          final game = GameWidget(game: viewModel.gameManager);
          return Stack(
            children: [
              if (viewModel.ignorePointer) ...[
                IgnorePointer(child: game),
              ] else ...[
                game,
              ],
              if (viewModel.isPaused) Center(child: Container(color: Colors.blue, width: 100, height: 100)),
              if (viewModel.tutorialType != null) Center(child: Container(color: Colors.red, width: 100, height: 100)),
            ],
          );
        },
      ),
    );
  }

  @override
  Future<void> openTutorial(TutorialType type) async => print('opening tutorial');
}
