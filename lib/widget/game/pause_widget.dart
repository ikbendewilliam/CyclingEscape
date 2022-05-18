import 'package:cycling_escape/screen/base/simple_screen.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

class PauseWidget extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onSave;
  final VoidCallback onStop;

  const PauseWidget({
    required this.onContinue,
    required this.onSave,
    required this.onStop,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilder: (context, theme, localization) => SimpleScreen(
        transparant: true,
        child: MenuBox(
          title: localization.pausedTitle,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CyclingEscapeButton(
                type: CyclingEscapeButtonType.green,
                text: localization.continueButton,
                onClick: onContinue,
              ),
              CyclingEscapeButton(
                type: CyclingEscapeButtonType.yellow,
                text: localization.saveButton,
                onClick: onSave,
              ),
              CyclingEscapeButton(
                type: CyclingEscapeButtonType.red,
                text: localization.mainMenuButton,
                onClick: onStop,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
