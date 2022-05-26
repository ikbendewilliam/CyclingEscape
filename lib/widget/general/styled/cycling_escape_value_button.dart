import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class CyclingEscapeValueButton extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final String text;
  final String? label;
  final ValueChanged<int>? onChange;
  final CyclingEscapeButtonType type;

  const CyclingEscapeValueButton({
    required this.value,
    required this.text,
    this.label,
    this.type = CyclingEscapeButtonType.yellow,
    this.minValue = 0,
    this.maxValue = 8,
    this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  State<CyclingEscapeValueButton> createState() => _CyclingEscapeValueButtonState();
}

class _CyclingEscapeValueButtonState extends State<CyclingEscapeValueButton> {
  late var value = widget.value;

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilder: (context, theme, localization) {
        final buttons = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CyclingEscapeButton(
              type: CyclingEscapeButtonType.iconMinus,
              onClick: () {
                if (--value < widget.minValue) {
                  value = widget.maxValue;
                }
                widget.onChange?.call(value);
              },
            ),
            const SizedBox(width: 2),
            CyclingEscapeButton(
              text: widget.text,
              type: widget.type,
            ),
            const SizedBox(width: 2),
            CyclingEscapeButton(
              type: CyclingEscapeButtonType.iconPlus,
              onClick: () {
                if (++value > widget.maxValue) {
                  value = widget.minValue;
                }
                widget.onChange?.call(value);
              },
            ),
          ],
        );
        if (widget.label != null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Center(
                child: Text(
                  widget.label!,
                  style: theme.coreTextTheme.bodyUltraSmall,
                ),
              ),
              const SizedBox(height: 4),
              buttons,
            ],
          );
        }
        return buttons;
      },
    );
  }
}
