import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class FlutterTemplateSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FlutterTemplateSwitch({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilderTheme: (context, theme) => Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: theme.colorsTheme.accent,
      ),
    );
  }
}
