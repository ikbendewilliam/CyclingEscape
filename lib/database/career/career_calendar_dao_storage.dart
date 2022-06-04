import 'package:cycling_escape/database/cycling_escape_database.dart';
import 'package:cycling_escape/model/data/calendar_event.dart';
import 'package:cycling_escape/model/database/career_calendar_event_winners.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

part 'career_calendar_dao_storage.g.dart';

@lazySingleton
abstract class CareerCalendarDaoStorage {
  @factoryMethod
  factory CareerCalendarDaoStorage(CyclingEscapeDatabase database) = _CareerCalendarDaoStorage;

  Future<void> getAllWinners(List<CalendarEvent> events);

  Future<void> saveResults(List<CalendarEvent> results);
}

@DriftAccessor(tables: [
  DbCareerCalendarEventWinnersTable,
])
class _CareerCalendarDaoStorage extends DatabaseAccessor<CyclingEscapeDatabase> with _$_CareerCalendarDaoStorageMixin implements CareerCalendarDaoStorage {
  _CareerCalendarDaoStorage(CyclingEscapeDatabase db) : super(db);

  @override
  Future<void> getAllWinners(List<CalendarEvent> events) async {
    final eventsResults = (await select(dbCareerCalendarEventWinnersTable).get());
    for (final result in eventsResults) {
      result.setWinners(events);
    }
  }

  @override
  Future<void> saveResults(List<CalendarEvent> results) async {
    await delete(dbCareerCalendarEventWinnersTable).go();
    await batch((batch) => batch.insertAll(dbCareerCalendarEventWinnersTable, results.map((result) => result.winnerDbModel)));
  }
}
