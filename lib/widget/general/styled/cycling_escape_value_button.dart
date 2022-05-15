import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class CyclingEscapeValueButton extends StatefulWidget {
  final int value;
  final int minValue;
  final int maxValue;
  final String text;
  final ValueChanged<int>? onChange;
  final CyclingEscapeButtonType type;

  const CyclingEscapeValueButton({
    required this.text,
    required this.value,
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
      childBuilder: (context, theme, localization) => Row(
        children: [
          CyclingEscapeIconButton(
            text: '-',
            onClick: () {
              if (--value < widget.minValue) {
                value = widget.maxValue;
              }
              widget.onChange?.call(value);
            },
          ),
          CyclingEscapeButton(
            text: widget.text,
            type: widget.type,
            onClick: () {},
          ),
          CyclingEscapeIconButton(
            text: '+',
            onClick: () {
              if (++value > widget.maxValue) {
                value = widget.minValue;
              }
              widget.onChange?.call(value);
            },
          ),
        ],
      ),
    );
  }
}
