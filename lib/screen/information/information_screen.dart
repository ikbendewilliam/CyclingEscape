import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/information/information_viewmodel.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class InformationScreen extends StatefulWidget {
  static const String routeName = 'information';

  const InformationScreen({Key? key}) : super(key: key);

  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen> with BackNavigatorMixin implements InformationNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<InformationViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: localization.careerInfoTitle,
          wide: true,
          child: AspectRatio(
            aspectRatio: 2.1,
            child: Column(
              children: [
                const Spacer(),
                Text(
                  localization.discordServerIntro,
                  style: theme.coreTextTheme.bodyNormal,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => viewModel.launchDiscord(localization),
                  child: Text(
                    localization.discordServerUrl,
                    style: theme.coreTextTheme.bodyNormal.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
