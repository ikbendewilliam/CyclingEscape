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
}
