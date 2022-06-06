import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/util/locale/localization.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class InformationViewModel with ChangeNotifierEx {
  late final InformationNavigator _navigator;

  InformationViewModel();

  Future<void> init(InformationNavigator navigator) async {
    _navigator = navigator;
  }

  void launchDiscord(Localization localization) => launchUrl(Uri.parse(localization.discordServerUrl));

  void onBackPressed() => _navigator.goBack<void>();
}

mixin InformationNavigator implements BackNavigator {}
