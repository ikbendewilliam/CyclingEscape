import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_calendar/career_calendar_viewmodel.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
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
          title: localization.activeTourTitle,
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
