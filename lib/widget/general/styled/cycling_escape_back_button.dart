import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/util/keys.dart';
import 'package:cycling_escape/widget/general/action/action_item.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class CyclingEscapeBackButton extends StatelessWidget {
  final VoidCallback? onClick;
  final bool fullScreen;
  final bool isLight;

  const CyclingEscapeBackButton.light({
    required this.onClick,
    this.fullScreen = false,
    Key? key,
  })  : isLight = true,
        super(key: key);

  const CyclingEscapeBackButton.dark({
    required this.onClick,
    this.fullScreen = false,
    Key? key,
  })  : isLight = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderTheme: (context, theme) => ActionItem(
        key: Keys.backButton,
        svgAsset: getCorrectIcon(context),
        color: isLight ? theme.colorsTheme.icon : theme.colorsTheme.inverseIcon,
        onClick: onClick,
      ),
    );
  }

  String getCorrectIcon(BuildContext context) {
    if (fullScreen) {
      return ThemeAssets.closeIcon(context);
    }
    return ThemeAssets.backIcon(context);
  }
}
