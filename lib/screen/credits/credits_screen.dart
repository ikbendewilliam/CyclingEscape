import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/credits/credits_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CreditsScreen extends StatefulWidget {
  static const String routeName = 'credits';

  const CreditsScreen({Key? key}) : super(key: key);

  @override
  CreditsScreenState createState() => CreditsScreenState();
}

class CreditsScreenState extends State<CreditsScreen> with BackNavigatorMixin implements CreditsNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CreditsViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: localization.creditsTitle,
          wide: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Column(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        localization.creditsText,
                        style: theme.coreTextTheme.bodyNormal,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  CyclingEscapeButton(
                    text: 'back',
                    onClick: viewModel.onBackPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
