import 'package:flutter/material.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

class ThemeAssets {
  ThemeAssets._();

  static const _images = 'assets/images';

  static String _getIcon(BuildContext context, String name) {
    if (context.isIOSTheme) {
      return '$_images/icons/ios/$name.svg';
    }
    return '$_images/icons/android/$name.svg';
  }

  static String listIcon(BuildContext context) => _getIcon(context, 'list');

  static String settingsIcon(BuildContext context) => _getIcon(context, 'settings');

  static String addIcon(BuildContext context) => _getIcon(context, 'add');

  static String downloadIcon(BuildContext context) => _getIcon(context, 'download');

  static String closeIcon(BuildContext context) => _getIcon(context, 'close');

  static String backIcon(BuildContext context) => _getIcon(context, 'back');

  static String doneIcon(BuildContext context) => _getIcon(context, 'done');

  static String get menuBackground1 => '$_images/menu_background_1.png';

  static String get menuBackground2 => '$_images/menu_background_2.png';

  static String get menuBackground3 => '$_images/menu_background_3.png';

  static String get menuBackground4 => '$_images/menu_background_4.png';

  static String get menuCloud1 => '$_images/menu_cloud_1.png';

  static String get menuCloud2 => '$_images/menu_cloud_2.png';

  static String get menuCloud3 => '$_images/menu_cloud_3.png';

  static String get menuCloud4 => '$_images/menu_cloud_4.png';

  static String get menuCloud5 => '$_images/menu_cloud_5.png';

  static String get menuCyclistSilhouette => '$_images/menu_cyclist_silhouette.png';

  static String get menuTardis => '$_images/menu_tardis.png';

  static String get menuBox => '$_images/back_results.png';

  static String get menuHeader => '$_images/back_text_01.png';

  static String get menuHeaderBigger => '$_images/back_text_02.png';

  static String get menuHeaderBiggest => '$_images/back_text_03.png';

  static String get buttonDisabled => '$_images/black_button_01.png';

  static String get buttonDisabledPressed => '$_images/black_button_02.png';

  static String get buttonBlue => '$_images/blue_button_01.png';

  static String get buttonBluePressed => '$_images/blue_button_02.png';

  static String get buttonRed => '$_images/red_button_01.png';

  static String get buttonRedPressed => '$_images/red_button_02.png';

  static String get buttonGreen => '$_images/green_button_01.png';

  static String get buttonGreenPressed => '$_images/green_button_02.png';

  static String get buttonYellow => '$_images/yellow_button_01.png';

  static String get buttonYellowPressed => '$_images/yellow_button_02.png';

  static String get buttonIconPressed => '$_images/icon_pressed.png';

  static String get buttonIconPlus => '$_images/icon_plus.png';

  static String get buttonIconMinus => '$_images/icon_minus.png';
}
