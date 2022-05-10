import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/tour_menu/tour_menu_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TourMenuScreen extends StatefulWidget {
  static const String routeName = 'tour_menu';

  const TourMenuScreen({Key? key}) : super(key: key);

  @override
  TourMenuScreenState createState() => TourMenuScreenState();
}

class TourMenuScreenState extends State<TourMenuScreen> with BackNavigatorMixin implements TourMenuNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TourMenuViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'Tour',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CyclingEscapeButton(
                  text: 'Back',
                  onClick: viewModel.onBackClicked,
                  type: CyclingEscapeButtonType.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
