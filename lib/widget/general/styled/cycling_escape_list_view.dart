import 'package:cycling_escape/styles/theme_assets.dart';
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
        const SizedBox(width: 16),
        Stack(
          children: [
            Image.asset(
              ThemeAssets.scrollbarBackground,
              fit: BoxFit.fitHeight,
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment(
                  0,
                  controller.hasClients && controller.position.maxScrollExtent > 0 ? (controller.offset / controller.position.maxScrollExtent * 2 - 1).clamp(-1, 1) : -1,
                ),
                child: Image.asset(
                  ThemeAssets.scrollbarForeground,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}