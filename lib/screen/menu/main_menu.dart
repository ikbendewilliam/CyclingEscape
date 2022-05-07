import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  static const routeName = 'main_menu';

  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleMenuScreen(
      child: Center(
        child: Text('test main menu'),
      ),
    );
  }
}
