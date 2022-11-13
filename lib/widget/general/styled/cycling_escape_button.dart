import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/util/audio/audio_controller.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

enum CyclingEscapeButtonType {
  blue(ThemeAssets.buttonBluePressed, ThemeAssets.buttonBlue),
  red(ThemeAssets.buttonRedPressed, ThemeAssets.buttonRed),
  green(ThemeAssets.buttonGreenPressed, ThemeAssets.buttonGreen),
  yellow(ThemeAssets.buttonYellowPressed, ThemeAssets.buttonYellow),
  iconInfo(ThemeAssets.buttonIconPressed, ThemeAssets.buttonIconInfo),
  iconPlus(ThemeAssets.buttonIconPressed, ThemeAssets.buttonIconPlus),
  iconMinus(ThemeAssets.buttonIconPressed, ThemeAssets.buttonIconMinus),
  iconNext(ThemeAssets.buttonIconPressed, ThemeAssets.buttonIconNext),
  iconClose(ThemeAssets.buttonIconPressed, ThemeAssets.buttonIconClose),
  iconCredits(ThemeAssets.buttonIconPressed, ThemeAssets.buttonIconCredits),
  iconSettings(ThemeAssets.buttonIconPressed, ThemeAssets.buttonIconSettings);

  final String pressed;
  final String normal;

  const CyclingEscapeButtonType(this.pressed, this.normal);
}

class CyclingEscapeButton extends StatefulWidget {
  final bool isEnabled;
  final double size;
  final String? text;
  final VoidCallback? onClick;
  final CyclingEscapeButtonType type;

  const CyclingEscapeButton({
    this.onClick,
    this.text,
    this.size = 48,
    this.isEnabled = true,
    this.type = CyclingEscapeButtonType.blue,
    Key? key,
  }) : super(key: key);

  @override
  State<CyclingEscapeButton> createState() => _CyclingEscapeButtonState();
}

class _CyclingEscapeButtonState extends State<CyclingEscapeButton> {
  var _isPressed = false;

  String get _imageAsset {
    if (!widget.isEnabled) return ThemeAssets.buttonDisabled;
    return _isPressed ? widget.type.pressed : widget.type.normal;
  }

  @override
  Widget build(BuildContext context) {
    return DataProviderWidget(
      childBuilder: (context, theme, localization) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: GestureDetector(
          onTapDown: (details) {
            if (!widget.isEnabled || widget.onClick == null) return;
            setState(() {
              _isPressed = true;
            });
          },
          onTapUp: (details) {
            if (!widget.isEnabled || widget.onClick == null) return;
            setState(() {
              _isPressed = false;
            });
            GetIt.I<AudioController>().playButtonPress();
            widget.onClick?.call();
          },
          onPanUpdate: (details) {
            if (!widget.isEnabled || widget.onClick == null) return;
            setState(() {
              _isPressed = false;
            });
          },
          child: Stack(
            children: [
              Image.asset(
                _imageAsset,
                fit: BoxFit.fitHeight,
                height: widget.size,
              ),
              if (widget.text != null) ...[
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: _isPressed && widget.isEnabled ? 4 : 0,
                      bottom: 8,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.text ?? '',
                        style: theme.coreTextTheme.labelButtonBig,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
