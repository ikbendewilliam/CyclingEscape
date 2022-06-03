import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_select_riders/career_select_riders_viewmodel.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
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
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: 'Select your riders',
          onClosePressed: viewModel.onClosePressed,
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Column(
                children: const [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
