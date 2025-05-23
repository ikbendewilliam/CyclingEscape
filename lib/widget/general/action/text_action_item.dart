import 'package:cycling_escape/styles/theme_dimens.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class TextActionItem extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool enabled;
  final VoidCallback onClick;

  const TextActionItem({
    required this.text,
    required this.enabled,
    required this.onClick,
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderTheme: (context, theme) => Center(
        child: TouchFeedBack(
          borderRadius: BorderRadius.circular(ThemeDimens.padding4),
          onClick: enabled ? onClick : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeDimens.padding16, vertical: ThemeDimens.padding8),
            child: AnimatedDefaultTextStyle(
              style: style ?? theme.inverseCoreTextTheme.labelButtonSmall,
              duration: ThemeDurations.shortAnimationDuration,
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}
