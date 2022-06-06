// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i49;
import 'package:drift/drift.dart' as _i7;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:icapps_architecture/icapps_architecture.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i15;

import '../database/career/calendar_results_dao_storage.dart' as _i23;
import '../database/career/career_calendar_dao_storage.dart' as _i22;
import '../database/cycling_escape_database.dart' as _i19;
import '../database/tour_results/tour_results_dao_storage.dart' as _i20;
import '../repository/calendar/calendar_repository.dart' as _i37;
import '../repository/career/career_repository.dart' as _i39;
import '../repository/debug/debug_repository.dart' as _i24;
import '../repository/locale/locale_repository.dart' as _i27;
import '../repository/name/name_repository.dart' as _i28;
import '../repository/refresh/refresh_repository.dart' as _i30;
import '../repository/secure_storage/auth/auth_storage.dart' as _i21;
import '../repository/secure_storage/secure_storage.dart' as _i14;
import '../repository/shared_prefs/local/local_storage.dart' as _i26;
import '../repository/tour/tour_repository.dart' as _i33;
import '../repository/tutorial/tutorial_repository.dart' as _i35;
import '../util/cache/cache_controller.dart' as _i4;
import '../util/cache/cache_controlling.dart' as _i3;
import '../util/interceptor/network_auth_interceptor.dart' as _i29;
import '../util/interceptor/network_error_interceptor.dart' as _i12;
import '../util/interceptor/network_log_interceptor.dart' as _i13;
import '../util/interceptor/network_refresh_interceptor.dart' as _i46;
import '../viewmodel/active_tour/active_tour_viewmodel.dart' as _i36;
import '../viewmodel/career_calendar/career_calendar_viewmodel.dart' as _i38;
import '../viewmodel/career_overview/career_overview_viewmodel.dart' as _i48;
import '../viewmodel/career_select_riders/career_select_riders_viewmodel.dart'
    as _i40;
import '../viewmodel/career_standings/career_standings_viewmodel.dart' as _i41;
import '../viewmodel/change_cyclist_names/change_cyclist_names_viewmodel.dart'
    as _i42;
import '../viewmodel/credits/credits_viewmodel.dart' as _i6;
import '../viewmodel/debug/debug_platform_selector_viewmodel.dart' as _i8;
import '../viewmodel/debug/debug_viewmodel.dart' as _i25;
import '../viewmodel/game/game_viewmodel.dart' as _i43;
import '../viewmodel/global/global_viewmodel.dart' as _i44;
import '../viewmodel/license/license_viewmodel.dart' as _i10;
import '../viewmodel/main_menu/main_menu_viewmodel.dart' as _i45;
import '../viewmodel/menu_background/menu_background_viewmodel.dart' as _i11;
import '../viewmodel/results/results_viewmodel.dart' as _i47;
import '../viewmodel/settings/settings_viewmodel.dart' as _i31;
import '../viewmodel/single_race_menu/single_race_menu_viewmodel.dart' as _i16;
import '../viewmodel/splash/splash_viewmodel.dart' as _i32;
import '../viewmodel/tour_in_progress/tour_in_progress_viewmodel.dart' as _i18;
import '../viewmodel/tour_select/tour_select_viewmodel.dart' as _i34;
import '../widget_game/data/sprite_manager.dart' as _i17;
import 'injectable.dart' as _i50; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.singleton<_i3.CacheControlling>(_i4.CacheController());
  gh.singleton<_i5.ConnectivityHelper>(registerModule.connectivityHelper());
  gh.factory<_i6.CreditsViewModel>(() => _i6.CreditsViewModel());
  await gh.singletonAsync<_i7.DatabaseConnection>(
      () => registerModule.provideDatabaseConnection(),
      preResolve: true);
  gh.factory<_i8.DebugPlatformSelectorViewModel>(
      () => _i8.DebugPlatformSelectorViewModel());
  gh.lazySingleton<_i9.FlutterSecureStorage>(() => registerModule.storage());
  gh.factory<_i10.LicenseViewModel>(() => _i10.LicenseViewModel());
  gh.factory<_i11.MenuBackgroundViewModel>(
      () => _i11.MenuBackgroundViewModel());
  gh.singleton<_i12.NetworkErrorInterceptor>(
      _i12.NetworkErrorInterceptor(get<_i5.ConnectivityHelper>()));
  gh.singleton<_i13.NetworkLogInterceptor>(_i13.NetworkLogInterceptor());
  gh.lazySingleton<_i14.SecureStorage>(
      () => _i14.SecureStorage(get<_i9.FlutterSecureStorage>()));
  await gh.singletonAsync<_i15.SharedPreferences>(() => registerModule.prefs(),
      preResolve: true);
  gh.factory<_i16.SingleRaceMenuViewModel>(
      () => _i16.SingleRaceMenuViewModel());
  gh.singleton<_i17.SpriteManager>(_i17.SpriteManager());
  gh.factory<_i18.TourInProgressViewModel>(
      () => _i18.TourInProgressViewModel());
  gh.lazySingleton<_i19.CyclingEscapeDatabase>(() => registerModule
      .provideCyclingEscapeDatabase(get<_i7.DatabaseConnection>()));
  gh.lazySingleton<_i5.SharedPreferenceStorage>(
      () => registerModule.sharedPreferences(get<_i15.SharedPreferences>()));
  gh.lazySingleton<_i5.SimpleKeyValueStorage>(() =>
      registerModule.keyValueStorage(
          get<_i5.SharedPreferenceStorage>(), get<_i14.SecureStorage>()));
  gh.lazySingleton<_i20.TourResultsDaoStorage>(
      () => _i20.TourResultsDaoStorage(get<_i19.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i21.AuthStorage>(
      () => _i21.AuthStorage(get<_i5.SimpleKeyValueStorage>()));
  gh.lazySingleton<_i22.CareerCalendarDaoStorage>(
      () => _i22.CareerCalendarDaoStorage(get<_i19.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i23.CareerResultsDaoStorage>(
      () => _i23.CareerResultsDaoStorage(get<_i19.CyclingEscapeDatabase>()));
  gh.lazySingleton<_i24.DebugRepository>(
      () => _i24.DebugRepository(get<_i5.SharedPreferenceStorage>()));
  gh.factory<_i25.DebugViewModel>(
      () => _i25.DebugViewModel(get<_i24.DebugRepository>()));
  gh.lazySingleton<_i26.LocalStorage>(() => _i26.LocalStorage(
      get<_i21.AuthStorage>(), get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i27.LocaleRepository>(
      () => _i27.LocaleRepository(get<_i5.SharedPreferenceStorage>()));
  gh.lazySingleton<_i28.NameRepository>(
      () => _i28.NameRepository(get<_i26.LocalStorage>()));
  gh.singleton<_i29.NetworkAuthInterceptor>(
      _i29.NetworkAuthInterceptor(get<_i21.AuthStorage>()));
  gh.lazySingleton<_i30.RefreshRepository>(
      () => _i30.RefreshRepository(get<_i21.AuthStorage>()));
  gh.factory<_i31.SettingsViewModel>(
      () => _i31.SettingsViewModel(get<_i26.LocalStorage>()));
  gh.factory<_i32.SplashViewModel>(
      () => _i32.SplashViewModel(get<_i26.LocalStorage>()));
  gh.lazySingleton<_i33.TourRepository>(() => _i33.TourRepository(
      get<_i20.TourResultsDaoStorage>(), get<_i26.LocalStorage>()));
  gh.factory<_i34.TourSelectViewModel>(
      () => _i34.TourSelectViewModel(get<_i33.TourRepository>()));
  gh.lazySingleton<_i35.TutorialRepository>(
      () => _i35.TutorialRepository(get<_i26.LocalStorage>()));
  gh.factory<_i36.ActiveTourViewModel>(() => _i36.ActiveTourViewModel(
      get<_i33.TourRepository>(), get<_i28.NameRepository>()));
  gh.lazySingleton<_i37.CalendarRepository>(() => _i37.CalendarRepository(
      get<_i26.LocalStorage>(), get<_i22.CareerCalendarDaoStorage>()));
  gh.factory<_i38.CareerCalendarViewModel>(() => _i38.CareerCalendarViewModel(
      get<_i37.CalendarRepository>(), get<_i28.NameRepository>()));
  gh.lazySingleton<_i39.CareerRepository>(() => _i39.CareerRepository(
      get<_i23.CareerResultsDaoStorage>(), get<_i37.CalendarRepository>()));
  gh.factory<_i40.CareerSelectRidersViewModel>(() =>
      _i40.CareerSelectRidersViewModel(
          get<_i37.CalendarRepository>(), get<_i33.TourRepository>()));
  gh.factory<_i41.CareerStandingsViewModel>(() => _i41.CareerStandingsViewModel(
      get<_i39.CareerRepository>(),
      get<_i37.CalendarRepository>(),
      get<_i28.NameRepository>()));
  gh.factory<_i42.ChangeCyclistNamesViewModel>(
      () => _i42.ChangeCyclistNamesViewModel(get<_i28.NameRepository>()));
  gh.factory<_i43.GameViewModel>(() => _i43.GameViewModel(
      get<_i35.TutorialRepository>(),
      get<_i26.LocalStorage>(),
      get<_i17.SpriteManager>()));
  gh.singleton<_i44.GlobalViewModel>(_i44.GlobalViewModel(
      get<_i27.LocaleRepository>(),
      get<_i24.DebugRepository>(),
      get<_i26.LocalStorage>()));
  gh.factory<_i45.MainMenuViewModel>(
      () => _i45.MainMenuViewModel(get<_i33.TourRepository>()));
  gh.singleton<_i46.NetworkRefreshInterceptor>(
      _i46.NetworkRefreshInterceptor(get<_i30.RefreshRepository>()));
  gh.factory<_i47.ResultsViewModel>(() => _i47.ResultsViewModel(
      get<_i28.NameRepository>(),
      get<_i33.TourRepository>(),
      get<_i39.CareerRepository>()));
  gh.factory<_i48.CareerOverviewViewModel>(() => _i48.CareerOverviewViewModel(
      get<_i39.CareerRepository>(), get<_i28.NameRepository>()));
  gh.lazySingleton<_i5.CombiningSmartInterceptor>(() =>
      registerModule.provideCombiningSmartInterceptor(
          get<_i13.NetworkLogInterceptor>(),
          get<_i29.NetworkAuthInterceptor>(),
          get<_i12.NetworkErrorInterceptor>(),
          get<_i46.NetworkRefreshInterceptor>()));
  gh.lazySingleton<_i49.Dio>(
      () => registerModule.provideDio(get<_i5.CombiningSmartInterceptor>()));
  return get;
}

class _$RegisterModule extends _i50.RegisterModule {}
