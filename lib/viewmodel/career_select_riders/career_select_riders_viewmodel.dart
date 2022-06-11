import 'package:cycling_escape/model/data/calendar_event.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/repository/calendar/calendar_repository.dart';
import 'package:cycling_escape/repository/tour/tour_repository.dart';
import 'package:cycling_escape/widget_game/data/play_settings.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerSelectRidersViewModel with ChangeNotifierEx {
  late final CareerSelectRidersNavigator _navigator;
  final CalendarRepository _calendarRepository;
  final TourRepository _tourRepository;
  CalendarEvent? _calendarEvent;

  CalendarEvent? get calendarEvent => _calendarEvent;

  CareerSelectRidersViewModel(
    this._calendarRepository,
    this._tourRepository,
  );

  Future<void> init(CareerSelectRidersNavigator navigator) async {
    _navigator = navigator;
    final events = await _calendarRepository.calendarEvents;
    final currentEvent = _calendarRepository.eventsCompleted;
    _calendarEvent = events[currentEvent];
    notifyListeners();
  }

  void onClosePressed() => _navigator.goBack<void>();

  Future<void> onStartPressed() async {
    final playSettings = _calendarEvent!.playSettings;
    if ((playSettings.totalRaces ?? 0) > 1) await _tourRepository.startNewTour(playSettings);
    _navigator.goToGame(playSettings);
  }
}

mixin CareerSelectRidersNavigator implements BackNavigator {
  void goToGame(PlaySettings playSettings);
}
