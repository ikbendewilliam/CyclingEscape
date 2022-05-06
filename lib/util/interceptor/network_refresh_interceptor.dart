import 'package:cycling_escape/repository/refresh/refresh_repository.dart';
import 'package:dio/dio.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@singleton
class NetworkRefreshInterceptor extends SimpleInterceptor {
  final RefreshRepository _refreshRepo;

  NetworkRefreshInterceptor(
    this._refreshRepo,
  );

  @override
  Future<Object?> onResponse(Response response) {
    _refreshRepo.resetFailure();
    return super.onResponse(response);
  }
}
