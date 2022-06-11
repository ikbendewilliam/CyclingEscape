import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@singleton
class NetworkErrorInterceptor extends SimpleInterceptor {
  final ConnectivityHelper connectivityHelper;

  NetworkErrorInterceptor(this.connectivityHelper);
}
