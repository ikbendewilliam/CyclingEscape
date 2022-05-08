import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/styles/theme_dimens.dart';
import 'package:cycling_escape/widget/general/svg_icon.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class CyclingEscapeCheckBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CyclingEscapeCheckBox({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isIOSTheme) {
      return DataProviderWidget(
        childBuilderTheme: (context, theme) => GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            color: Colors.transparent,
            height: ThemeDimens.padding48,
            width: ThemeDimens.padding48,
            child: value
                ? Center(
                    child: SvgIcon(
                      svgAsset: ThemeAssets.doneIcon(context),
                      color: theme.colorsTheme.accent,
                      size: ThemeDimens.padding24,
                    ),
                  )
                : Container(),
          ),
        ),
      );
    }
    return DataProviderWidget(
      childBuilderTheme: (context, theme) => Checkbox(
        value: value,
        onChanged: (value) => onChanged(value ?? false),
        activeColor: theme.colorsTheme.accent,
      ),
    );
  }
}
