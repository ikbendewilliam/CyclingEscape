import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ResultsBottomNavigation extends StatefulWidget {
  final PageController controller;
  final List<ResultsType> pages;

  const ResultsBottomNavigation({
    required this.controller,
    required this.pages,
    super.key,
  });

  @override
  State<ResultsBottomNavigation> createState() => _ResultsBottomNavigationState();
}

class _ResultsBottomNavigationState extends State<ResultsBottomNavigation> {
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
            children: widget.pages
                .asMap()
                .entries
                .map(
                  (e) => TouchFeedBack(
                    onClick: () => widget.controller.animateToPage(
                      e.key,
                      duration: ThemeDurations.shortAnimationDuration,
                      curve: Curves.easeInOut,
                    ),
                    child: Image.asset(
                      e.value.icon,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                .toList(),
          ),
          IgnorePointer(
            child: Center(
              child: ClipPath(
                clipper: _BottomNavigationClipper(
                  widget.controller.hasClients ? (widget.controller.page ?? 0) / widget.pages.length : 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.pages
                      .map(
                        (e) => Image.asset(
                          e.icon,
                          fit: BoxFit.contain,
                          color: e.color,
                        ),
                      )
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
