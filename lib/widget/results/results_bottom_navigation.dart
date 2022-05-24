import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ResultsBottomNavigation extends StatefulWidget {
  final PageController controller;

  const ResultsBottomNavigation({
    required this.controller,
    super.key,
  });

  @override
  State<ResultsBottomNavigation> createState() => _ResultsBottomNavigationState();
}

class _ResultsBottomNavigationState extends State<ResultsBottomNavigation> {
  final _icons = {
    ThemeAssets.iconRank: Colors.blue,
    ThemeAssets.iconTime: Colors.yellow,
    ThemeAssets.iconYoung: Colors.black,
    ThemeAssets.iconPoints: Colors.green,
    ThemeAssets.iconMountain: Colors.red,
  };

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_update);
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _icons.keys
                .toList()
                .asMap()
                .entries
                .map((e) => TouchFeedBack(
                      onClick: () => widget.controller.animateToPage(
                        e.key,
                        duration: ThemeDurations.shortAnimationDuration,
                        curve: Curves.easeInOut,
                      ),
                      child: Image.asset(
                        e.value,
                        fit: BoxFit.contain,
                      ),
                    ))
                .toList(),
          ),
          IgnorePointer(
            child: Center(
              child: ClipPath(
                clipper: _BottomNavigationClipper(widget.controller.hasClients ? (widget.controller.page ?? 0) / _icons.length : 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _icons.entries
                      .map((e) => Image.asset(
                            e.key,
                            fit: BoxFit.contain,
                            color: e.value,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationClipper extends CustomClipper<Path> {
  final double widthFraction;

  _BottomNavigationClipper(this.widthFraction);

  @override
  Path getClip(Size size) {
    final x0 = size.width * widthFraction;
    final x1 = size.height + x0;
    final dx = size.height / 4;
    return Path()
      ..moveTo(x0, 0)
      // ..arcToPoint(Offset(x0, size.height), radius: const Radius.circular(1), largeArc: true)
      ..quadraticBezierTo(x0 - dx / 2, size.height / 4, x0 - 2, size.height / 2)
      ..quadraticBezierTo(x0 + dx / 2, size.height / 4 * 3, x0, size.height)
      ..lineTo(x1, size.height)
      ..quadraticBezierTo(x1 + dx / 2, size.height / 4 * 3, x1 + 2, size.height / 2)
      ..quadraticBezierTo(x1 - dx / 2, size.height / 4, x1, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => oldClipper is! _BottomNavigationClipper || widthFraction != oldClipper.widthFraction;
}
