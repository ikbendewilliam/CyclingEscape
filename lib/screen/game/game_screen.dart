import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/viewmodel/game/game_viewmodel.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = 'game';

  const GameScreen({Key? key}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> implements GameNavigator {
  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderLocalization: (context, localization) => ProviderWidget<GameViewModel>(
        create: () => GetIt.I()..init(this, localization),
        childBuilderWithViewModel: (context, viewModel, theme, _) => GameWidget(game: viewModel.gameManager),
      ),
    );
  }

  @override
  Future<void> openTutorial(TutorialType type) async => print('opening tutorial');
}
