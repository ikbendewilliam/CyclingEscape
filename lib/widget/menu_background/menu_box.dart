import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class MenuBox extends StatelessWidget {
  final bool wide;
  final Widget child;
  final String? title;
  final VoidCallback? onClosePressed;

  const MenuBox({
    required this.child,
    this.title,
    this.onClosePressed,
    this.wide = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilder: (context, theme, localization) => Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                wide ? ThemeAssets.menuBoxWide : ThemeAssets.menuBox,
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16).add(const EdgeInsets.only(top: 32)),
              child: child,
            ),
            if (title != null) ...[
              Positioned(
                top: title!.length > 8 ? -12 : -13,
                bottom: null,
                height: 48,
                child: Stack(
                  children: [
                    Image.asset(
                      title!.length > 8 ? ThemeAssets.menuHeaderBigger : ThemeAssets.menuHeader,
                    ),
                    Positioned.fill(
                      left: 16,
                      right: 16,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title!,
                          style: theme.coreTextTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (onClosePressed != null)
              Positioned(
                top: 10,
                right: 10,
                child: CyclingEscapeButton(
                  onClick: onClosePressed,
                  type: CyclingEscapeButtonType.iconClose,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
