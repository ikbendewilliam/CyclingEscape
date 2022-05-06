import 'package:cycling_escape/styles/theme_dimens.dart';
import 'package:cycling_escape/widget/general/svg_icon.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ActionItem extends StatelessWidget {
  final String svgAsset;
  final VoidCallback? onClick;
  final Color? color;

  const ActionItem({
    required this.svgAsset,
    required this.onClick,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderTheme: (context, theme) => SizedBox(
        height: ThemeDimens.padding56,
        width: ThemeDimens.padding56,
        child: Center(
          child: SizedBox(
            height: ThemeDimens.padding48,
            width: ThemeDimens.padding48,
            child: TouchFeedBack(
              borderRadius: BorderRadius.circular(ThemeDimens.padding48),
              child: Center(
                child: SvgIcon(
                  svgAsset: svgAsset,
                  size: ThemeDimens.padding24,
                  color: color ?? theme.colorsTheme.icon,
                ),
              ),
              onClick: onClick,
            ),
          ),
        ),
      ),
    );
  }
}
