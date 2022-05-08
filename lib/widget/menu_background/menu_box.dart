import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class MenuBox extends StatelessWidget {
  final Widget child;
  final String? title;

  const MenuBox({
    required this.child,
    this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilder: (context, theme, localization) => Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Image.asset(
                ThemeAssets.menuBox,
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16).add(const EdgeInsets.only(top: 32)),
              child: child,
            ),
            if (title != null) ...[
              Positioned(
                top: -12,
                bottom: null,
                height: 48,
                left: 0,
                right: 0,
                child: Image.asset(
                  ThemeAssets.menuHeaderBigger,
                ),
              ),
              Positioned.fill(
                top: 0,
                bottom: null,
                child: Text(
                  title!,
                  style: theme.coreTextTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
