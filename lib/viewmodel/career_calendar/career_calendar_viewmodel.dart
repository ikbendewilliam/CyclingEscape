import 'package:cycling_escape/model/data/calendar_event.dart';
import 'package:cycling_escape/navigator/mixin/back_navigator.dart';
import 'package:cycling_escape/repository/calendar/calendar_repository.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:injectable/injectable.dart';

@injectable
class CareerCalendarViewModel with ChangeNotifierEx {
  late final CareerCalendarNavigator _navigator;
  final CalendarRepository _calendarRepository;

  List<CalendarEvent> get calendarEvents => _calendarRepository.calendarEvents;

  CareerCalendarViewModel(
    this._calendarRepository,
  );

  Future<void> init(CareerCalendarNavigator navigator) async {
    _navigator = navigator;
  }

  void onClosePressed() => _navigator.goBack<void>();
}

mixin CareerCalendarNavigator implements BackNavigator {}
