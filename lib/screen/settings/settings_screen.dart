import 'package:cycling_escape/model/data/enums.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/screen/base/simple_menu_screen.dart';
import 'package:cycling_escape/viewmodel/settings/settings_viewmodel.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_button.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_checkbox.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_list_view.dart';
import 'package:cycling_escape/widget/general/styled/cycling_escape_value_button.dart';
import 'package:cycling_escape/widget/menu_background/menu_box.dart';
import 'package:cycling_escape/widget/provider/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = 'settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with BackNavigatorMixin implements SettingsNavigator {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SettingsViewModel>(
      create: () => GetIt.I()..init(this),
      childBuilderWithViewModel: (context, viewModel, theme, localization) => SimpleMenuScreen(
        child: MenuBox(
          title: localization.settingsTitle,
          wide: true,
          child: Container(
            padding: const EdgeInsets.only(left: 48, right: 48, bottom: 16),
            height: MediaQuery.of(context).size.height * 0.7,
            child: AspectRatio(
              aspectRatio: 2.1,
              child: Padding(
                padding: const EdgeInsets.only(left: 48),
                child: CyclingEscapeListView.children(
                  children: [
                    CyclingEscapeValueButton(
                      label: localization.settingsAutofollowThreshold,
                      value: viewModel.autofollowThreshold,
                      text: viewModel.autofollowThreshold.toString(),
                      onChange: viewModel.autofollowThresholdChanged,
                      maxValue: 12,
                      minValue: 2,
                    ),
                    CyclingEscapeCheckBox(
                      text: 'Autofollow ask below threshold',
                      value: viewModel.autofollowThresholdBelowAsk,
                      onChanged: viewModel.autofollowThresholdBelowAskChanged,
                    ),
                    CyclingEscapeCheckBox(
                      text: 'Autofollow ask above threshold',
                      value: viewModel.autofollowThresholdAboveAsk,
                      onChanged: viewModel.autofollowThresholdAboveAskChanged,
                    ),
                    CyclingEscapeValueButton(
                      label: localization.settingsCyclistMoveSpeed,
                      value: viewModel.cyclistMoveSpeedIndex,
                      text: localization.getTranslation(viewModel.cyclistMoveSpeed.localizationKey),
                      maxValue: CyclistMovementType.values.length - 1,
                      onChange: viewModel.cyclistMoveSpeedChanged,
                    ),
                    CyclingEscapeValueButton(
                      label: localization.settingsCameraAutoMove,
                      value: viewModel.cameraAutoMoveIndex,
                      text: localization.getTranslation(viewModel.cameraAutoMove.localizationKey),
                      maxValue: CameraMovementType.values.length - 1,
                      onChange: viewModel.cameraAutoMoveChanged,
                    ),
                    CyclingEscapeValueButton(
                      label: localization.settingsDifficulty,
                      value: viewModel.difficultyIndex,
                      text: localization.getTranslation(viewModel.difficulty.localizationKey),
                      maxValue: DifficultyType.values.length - 1,
                      onChange: viewModel.difficultyChanged,
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: CyclingEscapeButton(
                        text: 'Save',
                        onClick: viewModel.onBackPressed,
                        type: CyclingEscapeButtonType.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
