// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i46;
import 'package:drift/drift.dart' as _i10;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i8;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i18;

import '../database/cycling_escape_database.dart' as _i22;
import '../database/tour_results/tour_results_dao_storage.dart' as _i23;
import '../repository/calendar/calendar_repository.dart' as _i38;
import '../repository/debug/debug_repository.dart' as _i25;
import '../repository/locale/locale_repository.dart' as _i28;
import '../repository/name/name_repository.dart' as _i29;
import '../repository/refresh/refresh_repository.dart' as _i31;
import '../repository/secure_storage/auth/auth_storage.dart' as _i24;
import '../repository/secure_storage/secure_storage.dart' as _i17;
import '../repository/shared_prefs/local/local_storage.dart' as _i27;
import '../repository/tour/tour_repository.dart' as _i34;
import '../repository/tutorial/tutorial_repository.dart' as _i36;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i30;
import '../util/interceptor/network_error_interceptor.dart' as _i15;
import '../util/interceptor/network_log_interceptor.dart' as _i16;
import '../util/interceptor/network_refresh_interceptor.dart' as _i44;
import '../viewmodel/active_tour/active_tour_viewmodel.dart' as _i37;
import '../viewmodel/career_calendar/career_calendar_viewmodel.dart' as _i39;
import '../viewmodel/career_overview/career_overview_viewmodel.dart' as _i5;
import '../viewmodel/career_select_riders/career_select_riders_viewmodel.dart'
    as _i6;
import '../viewmodel/career_standings/career_standings_viewmodel.dart' as _i7;
import '../viewmodel/change_cyclist_names/change_cyclist_names_viewmodel.dart'
    as _i40;
import '../viewmodel/credits/credits_viewmodel.dart' as _i9;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i11;
import '../viewmodel/debug/debug_viewmodel.dart' as _i26;
import '../viewmodel/game/game_viewmodel.dart' as _i41;
import '../viewmodel/global/global_viewmodel.dart' as _i42;
import '../viewmodel/license/license_viewmodel.dart' as _i13;
import '../viewmodel/main_menu/main_menu_viewmodel.dart' as _i43;
import '../viewmodel/menu_background/menu_background_viewmodel.dart' as _i14;
import '../viewmodel/results/results_viewmodel.dart' as _i45;
import '../viewmodel/settings/settings_viewmodel.dart' as _i32;
import '../viewmodel/single_race_menu/single_race_menu_viewmodel.dart' as _i19;
import '../viewmodel/splash/splash_viewmodel.dart' as _i33;
import '../viewmodel/tour_in_progress/tour_in_progress_viewmodel.dart' as _i21;
import '../viewmodel/tour_select/tour_select_viewmodel.dart' as _i35;
import '../widget_game/data/sprite_manager.dart' as _i20;
import 'injectable.dart' as _i47; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.CacheControlling>(_i4.CacheController());
  gh.factory<_i5.CareerOverviewViewModel>(() => _i5.CareerOverviewViewModel());
  gh.factory<_i6.CareerSelectRidersViewModel>(
      () => _i6.CareerSelectRidersViewModel());
  gh.factory<_i7.CareerStandingsViewModel>(
      () => _i7.CareerStandingsViewModel());
  gh.singleton<_i8.ConnectivityHelper>(registerModule.connectivityHelper());
  gh.factory<_i9.CreditsViewModel>(() => _i9.CreditsViewModel());
  await gh.singletonAsync<_i10.DatabaseConnection>(
      () => registerModule.provideDatabaseConnection(),
      preResolve: true);
  gh.factory<_i11.DebugPlatformSelectorViewModel>(
      () => _i11.DebugPlatformSelectorViewModel());
  gh.lazySingleton<_i12.FlutterSecureStorage>(() => registerModule.storage());
  gh.factory<_i13.LicenseViewModel>(() => _i13.LicenseViewModel());
  gh.factory<_i14.MenuBackgroundViewModel>(
      () => _i14.MenuBackgroundViewModel());
  gh.singleton<_i15.NetworkErrorInterceptor>(
      _i15.NetworkErrorInterceptor(get<_i8.ConnectivityHelper>()));
  gh.singleton<_i16.NetworkLogInterceptor>(_i16.NetworkLogInterceptor());
  gh.lazySingleton<_i17.SecureStorage>(
      () => _i17.SecureStorage(get<_i12.FlutterSecureStorage>()));
  await gh.singletonAsync<_i18.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.factory<_i19.SingleRaceMenuViewModel>(
      () => _i19.SingleRaceMenuViewModel());
  gh.singleton<_i20.SpriteManager>(_i20.SpriteManager());
  gh.factory<_i21.TourInProgressViewModel>(
      () => _i21.TourInProgressViewModel());
  gh.lazySingleton<_i22.CyclingEscapeDatabase>(() => registerModule
      .provideCyclingEscapeDatabase(get<_i10.DatabaseConnection>()));
  gh.lazySingleton<_i8.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i18.SharedPreferences>()));
  gh.lazySingleton<_i8.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i8.SharedPreferenceStorage>(), get<_i17.SecureStorage>()));
  gh.lazySingleton<_i23.TourResultsDaoStorage>(
      () => _i23.TourResultsDaoStorage(get<_i22.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i24.AuthStorage>(
      () => _i24.AuthStorage(get<_i8.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i25.DebugRepository>(
      () => _i25.DebugRepository(get<_i8.SharedPreferenceStorage>()));
  gh.factory<_i26.DebugViewModel>(
      () => _i26.DebugViewModel(get<_i25.DebugRepository>()));
  gh.lazySingleton<_i27.LocalStorage>(() => _i27.LocalStorage(
      get<_i24.AuthStorage>(), get<_i8.SharedPreferenceStorage>()));
  gh.lazySingleton<_i28.LocaleRepository>(
      () => _i28.LocaleRepository(get<_i8.SharedPreferenceStorage>()));
  gh.lazySingleton<_i29.NameRepository>(
      () => _i29.NameRepository(get<_i27.LocalStorage>()));
  gh.singleton<_i30.NetworkAuthInterceptor>(
      _i30.NetworkAuthInterceptor(get<_i24.AuthStorage>()));
  gh.lazySingleton<_i31.RefreshRepository>(
      () => _i31.RefreshRepository(get<_i24.AuthStorage>()));
  gh.factory<_i32.SettingsViewModel>(
      () => _i32.SettingsViewModel(get<_i27.LocalStorage>()));
  gh.factory<_i33.SplashViewModel>(
      () => _i33.SplashViewModel(get<_i27.LocalStorage>()));
  gh.lazySingleton<_i34.TourRepository>(() => _i34.TourRepository(
      get<_i23.TourResultsDaoStorage>(), get<_i27.LocalStorage>()));
  gh.factory<_i35.TourSelectViewModel>(
      () => _i35.TourSelectViewModel(get<_i34.TourRepository>()));
  gh.lazySingleton<_i36.TutorialRepository>(
      () => _i36.TutorialRepository(get<_i27.LocalStorage>()));
  gh.factory<_i37.ActiveTourViewModel>(() => _i37.ActiveTourViewModel(
      get<_i34.TourRepository>(), get<_i29.NameRepository>()));
  gh.lazySingleton<_i38.CalendarRepository>(
      () => _i38.CalendarRepository(get<_i27.LocalStorage>()));
  gh.factory<_i39.CareerCalendarViewModel>(
      () => _i39.CareerCalendarViewModel(get<_i38.CalendarRepository>()));
  gh.factory<_i40.ChangeCyclistNamesViewModel>(
      () => _i40.ChangeCyclistNamesViewModel(get<_i29.NameRepository>()));
  gh.factory<_i41.GameViewModel>(() => _i41.GameViewModel(
      get<_i36.TutorialRepository>(),
      get<_i27.LocalStorage>(),
      get<_i20.SpriteManager>()));
  gh.singleton<_i42.GlobalViewModel>(_i42.GlobalViewModel(
      get<_i28.LocaleRepository>(),
      get<_i25.DebugRepository>(),
      get<_i27.LocalStorage>()));
  gh.factory<_i43.MainMenuViewModel>(
      () => _i43.MainMenuViewModel(get<_i34.TourRepository>()));
  gh.singleton<_i44.NetworkRefreshInterceptor>(
      _i44.NetworkRefreshInterceptor(get<_i31.RefreshRepository>()));
  gh.factory<_i45.ResultsViewModel>(() => _i45.ResultsViewModel(
      get<_i29.NameRepository>(), get<_i34.TourRepository>()));
  gh.lazySingleton<_i8.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i16.NetworkLogInterceptor>(),
          get<_i30.NetworkAuthInterceptor>(),
          get<_i15.NetworkErrorInterceptor>(),
          get<_i44.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i46.Dio>(
      () => registerModule.provideDio(get<_i8.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i47.RegisterModule {}
