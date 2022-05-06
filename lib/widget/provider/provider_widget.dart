import 'package:cycling_escape/styles/theme_data.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:flutter/widgets.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ProviderWidget<T extends ChangeNotifier> extends BaseProviderWidget<T, FlutterTemplateTheme, Localization> {
  const ProviderWidget({
    required T Function() create,
    Widget? child,
    Widget Function(BuildContext context, FlutterTemplateTheme theme, Localization localization)? childBuilder,
    Widget Function(BuildContext context, T viewModel, FlutterTemplateTheme theme, Localization localization)? childBuilderWithViewModel,
    Widget? consumerChild,
    Widget Function(BuildContext context, T viewModel, Widget? child)? consumer,
    Widget Function(BuildContext context, T viewModel, Widget? child, FlutterTemplateTheme theme, Localization localization)? consumerWithThemeAndLocalization,
    bool lazy = true,
  }) : super(
          create: create,
          child: child,
          childBuilder: childBuilder,
          childBuilderWithViewModel: childBuilderWithViewModel,
          consumerChild: consumerChild,
          consumer: consumer,
          consumerWithThemeAndLocalization: consumerWithThemeAndLocalization,
          lazy: lazy,
        );
}
