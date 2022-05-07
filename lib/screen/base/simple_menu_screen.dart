import 'package:cycling_escape/screen/base/simple_screen.dart';
import 'package:cycling_escape/widget/menu_background/menu_background_widget.dart';
import 'package:flutter/material.dart';

class SimpleMenuScreen extends StatefulWidget {
  final Widget child;

  const SimpleMenuScreen({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<SimpleMenuScreen> createState() => _SimpleMenuScreenState();
}

class _SimpleMenuScreenState extends State<SimpleMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return SimpleScreen(
      child: Stack(
        children: [
          const MenuBackgroundWidget(),
          widget.child,
        ],
      ),
    );
  }
}
