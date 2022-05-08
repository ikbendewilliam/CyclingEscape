import 'package:cycling_escape/styles/theme_data.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:flutter/widgets.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class DataProviderWidget extends BaseThemeProviderWidget<CyclingEscapeTheme, Localization> {
  const DataProviderWidget({
    Widget Function(BuildContext context, CyclingEscapeTheme theme)? childBuilderTheme,
    Widget Function(BuildContext context, Localization localization)? childBuilderLocalization,
    Widget Function(BuildContext context, CyclingEscapeTheme theme, Localization localization)? childBuilder,
  }) : super(
          childBuilderTheme: childBuilderTheme,
          childBuilderLocalization: childBuilderLocalization,
          childBuilder: childBuilder,
        );
}
