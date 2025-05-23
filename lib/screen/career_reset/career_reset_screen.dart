import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/career_reset/career_reset_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CareerResetScreen extends StatefulWidget {
  static const String routeName = 'career_reset';

  const CareerResetScreen({Key? key}) : super(key: key);

  @override
  CareerResetScreenState createState() => CareerResetScreenState();
}

class CareerResetScreenState extends State<CareerResetScreen> with BackNavigatorMixin implements CareerResetNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CareerResetViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: localization.careerResetTitle,
          wide: true,
          onClosePressed: viewModel.onCancelPressed,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: AspectRatio(
              aspectRatio: 2.22,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localization.careerResetMessage,
                    style: theme.coreTextTheme.bodyNormal,
                  ),
                  const SizedBox(height: 8),
                  CyclingEscapeButton(
                    text: localization.careerResetButton,
                    onClick: viewModel.onResetPressed,
                    type: CyclingEscapeButtonType.red,
                  ),
                  const SizedBox(height: 8),
                  CyclingEscapeButton(
                    text: localization.careerResetBack,
                    onClick: viewModel.onCancelPressed,
                    type: CyclingEscapeButtonType.green,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToCareerOverview() => MainNavigatorWidget.of(context).goToCareerOverview();
}
