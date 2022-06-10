import 'package:cycling_escape/navigator/main_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/v2dialog/v2dialog_viewmodel.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class V2dialogScreen extends StatefulWidget {
  static const String routeName = 'v2dialog';

  const V2dialogScreen({Key? key}) : super(key: key);

  @override
  V2dialogScreenState createState() => V2dialogScreenState();
}

class V2dialogScreenState extends State<V2dialogScreen> implements V2dialogNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<V2dialogViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          onClosePressed: viewModel.onBackPressed,
          wide: true,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Center(
                child: Text(
                  localization.v2dialogText,
                  style: theme.coreTextTheme.bodyUltraSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void goToHome() => MainNavigatorWidget.of(context).goToHome();
}
