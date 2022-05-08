import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/viewmodel/menu_background/menu_background_viewmodel.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MenuBackgroundWidget extends StatefulWidget {
  const MenuBackgroundWidget({Key? key}) : super(key: key);

  @override
  MenuBackgroundWidgetState createState() => MenuBackgroundWidgetState();
}

class MenuBackgroundWidgetState extends State<MenuBackgroundWidget> with TickerProviderStateMixin {
  Widget _buildBackground(BoxConstraints constraints, MapEntry<String, double> background) => Positioned(
        left: -constraints.maxWidth + background.value % constraints.maxWidth,
        top: constraints.maxHeight * 0.2,
        bottom: -constraints.maxHeight * 0.15,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: ClipRect(
            child: Row(
              children: [
                Image.asset(
                  background.key,
                  width: constraints.maxWidth,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  background.key,
                  width: constraints.maxWidth,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ProviderWidget<MenuBackgroundViewModel>(
        create: () => GetIt.I<MenuBackgroundViewModel>()..init(this, constraints),
        childBuilderWithViewModel: (context, viewModel, theme, localization) => AnimatedBuilder(
          animation: viewModel.animation,
          builder: (context, child) => Stack(
            children: [
              Container(color: Colors.blue[100]),
              ...viewModel.backgroundOffsets.entries.take(viewModel.backgroundOffsets.length - 1).map(
                    (background) => _buildBackground(constraints, background),
                  ),
              ...viewModel.objectsOffsets.entries.map(
                (entry) => Positioned(
                  left: entry.value % (constraints.maxWidth * (entry.key.asset == ThemeAssets.menuTardis ? 5.1 : 1.1)) - constraints.maxWidth * 0.1,
                  top: entry.key.topOffsetPercentage * constraints.maxHeight,
                  height: 1 / entry.key.scale * constraints.maxHeight / 7,
                  child: Image.asset(entry.key.asset),
                ),
              ),
              _buildBackground(constraints, viewModel.backgroundOffsets.entries.last),
            ],
          ),
        ),
      ),
    );
  }
}
