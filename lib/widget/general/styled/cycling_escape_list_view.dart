import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:flutter/widgets.dart';

class CyclingEscapeListView extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  const CyclingEscapeListView({
    required this.itemBuilder,
    required this.itemCount,
    super.key,
  });

  @override
  State<CyclingEscapeListView> createState() => _CyclingEscapeListViewState();
}

class _CyclingEscapeListViewState extends State<CyclingEscapeListView> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
  }

  void _scrollTo(double dy, {required bool animate}) {
    final position = dy / controller.position.maxScrollExtent * widget.itemCount * widget.itemCount;
    if (animate) {
      controller.animateTo(
        position,
        duration: ThemeDurations.shortAnimationDuration,
        curve: Curves.easeOut,
      );
    } else {
      controller.jumpTo(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: widget.itemBuilder,
            itemCount: widget.itemCount,
            controller: controller,
            physics: const BouncingScrollPhysics(),
          ),
        ),
        GestureDetector(
          onPanUpdate: (details) => _scrollTo(details.localPosition.dy, animate: false),
          onTapDown: (details) => _scrollTo(details.localPosition.dy, animate: true),
          child: Stack(
            children: [
              Image.asset(
                ThemeAssets.scrollbarBackground,
                fit: BoxFit.fitHeight,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment(
                      0, controller.hasClients && controller.position.maxScrollExtent > 0 ? (controller.offset / controller.position.maxScrollExtent * 2 - 1).clamp(-1, 1) : -1),
                  child: Image.asset(
                    ThemeAssets.scrollbarForeground,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
