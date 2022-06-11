import 'package:flutter/material.dart';

class SimpleScreen extends StatelessWidget {
  final Widget child;
  final bool transparant;

  const SimpleScreen({
    required this.child,
    this.transparant = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparant ? Colors.transparent : Colors.black,
      body: SafeArea(
        child: child,
      ),
    );
  }
}
