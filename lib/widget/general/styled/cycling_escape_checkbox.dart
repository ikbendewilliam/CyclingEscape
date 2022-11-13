import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/styles/theme_durations.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class CyclingEscapeCheckBox extends StatelessWidget {
  final bool value;
  final String text;
  final ValueChanged<bool> onChanged;

  const CyclingEscapeCheckBox({
    required this.text,
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderTheme: (context, theme) => GestureDetector(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: theme.coreTextTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedCrossFade(
                duration: ThemeDurations.shortAnimationDuration,
                crossFadeState: value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                firstChild: Image.asset(
                  ThemeAssets.switchButtonOn,
                  height: 32,
                  fit: BoxFit.fitHeight,
                ),
                secondChild: Image.asset(
                  ThemeAssets.switchButtonOff,
                  height: 32,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
