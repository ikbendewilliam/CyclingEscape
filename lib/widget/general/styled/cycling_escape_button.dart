import 'package:cycling_escape/styles/theme_assets.dart';
import 'package:cycling_escape/widget/provider/data_provider_widget.dart';
import 'package:flutter/material.dart';

enum CyclingEscapeButtonType {
  blue,
  red,
  green,
  yellow,
  iconPlus,
  iconMinus,
  iconNext,
  iconClose,
}

class CyclingEscapeButton extends StatefulWidget {
  final String? text;
  final bool isEnabled;
  final VoidCallback? onClick;
  final CyclingEscapeButtonType type;

  const CyclingEscapeButton({
    this.onClick,
    this.text,
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
    switch (widget.type) {
      case CyclingEscapeButtonType.blue:
        return _isPressed ? ThemeAssets.buttonBluePressed : ThemeAssets.buttonBlue;
      case CyclingEscapeButtonType.red:
        return _isPressed ? ThemeAssets.buttonRedPressed : ThemeAssets.buttonRed;
      case CyclingEscapeButtonType.green:
        return _isPressed ? ThemeAssets.buttonGreenPressed : ThemeAssets.buttonGreen;
      case CyclingEscapeButtonType.yellow:
        return _isPressed ? ThemeAssets.buttonYellowPressed : ThemeAssets.buttonYellow;
      case CyclingEscapeButtonType.iconPlus:
        return _isPressed ? ThemeAssets.buttonIconPressed : ThemeAssets.buttonIconPlus;
      case CyclingEscapeButtonType.iconMinus:
        return _isPressed ? ThemeAssets.buttonIconPressed : ThemeAssets.buttonIconMinus;
      case CyclingEscapeButtonType.iconNext:
        return _isPressed ? ThemeAssets.buttonIconPressed : ThemeAssets.buttonIconNext;
      case CyclingEscapeButtonType.iconClose:
        return _isPressed ? ThemeAssets.buttonIconPressed : ThemeAssets.buttonIconClose;
    }
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
                height: 48,
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
                    child: Center(
                      child: Text(
                        widget.text ?? '',
                        style: theme.coreTextTheme.labelButtonBig,
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
