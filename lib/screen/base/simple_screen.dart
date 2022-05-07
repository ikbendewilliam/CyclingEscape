import 'package:flutter/material.dart';

class SimpleScreen extends StatelessWidget {
  final Widget child;

  const SimpleScreen({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
