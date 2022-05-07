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
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ProviderWidget<MenuBackgroundViewModel>(
        create: () => GetIt.I<MenuBackgroundViewModel>()..init(this, constraints.maxWidth),
        childBuilderWithViewModel: (context, viewModel, theme, localization) => AnimatedBuilder(
          animation: viewModel.animation,
          builder: (context, child) => Stack(
            children: [
              Container(color: Colors.blue[100]),
              ...viewModel.backgroundOffsets.entries.map(
                (entry) => Positioned(
                  left: -constraints.maxWidth + entry.value % constraints.maxWidth,
                  top: constraints.maxHeight * 0.1,
                  bottom: -constraints.maxHeight * 0.2,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ClipRect(
                      child: Row(
                        children: [
                          Image.asset(
                            entry.key,
                            width: constraints.maxWidth,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            entry.key,
                            width: constraints.maxWidth,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
