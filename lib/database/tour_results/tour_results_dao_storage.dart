import 'package:cycling_escape/database/cycling_escape_database.dart';
import 'package:cycling_escape/model/database/tour_results.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

part 'tour_results_dao_storage.g.dart';

@lazySingleton
abstract class TourResultsDaoStorage {
  @factoryMethod
  factory TourResultsDaoStorage(CyclingEscapeDatabase database) = _TourResultsDaoStorage;

  Future<List<ResultData>> getAllResults();

  Future<void> saveResults(List<ResultData> results);
}

@DriftAccessor(tables: [
  DbTourResultsTable,
])
class _TourResultsDaoStorage extends DatabaseAccessor<CyclingEscapeDatabase> with _$_TourResultsDaoStorageMixin implements TourResultsDaoStorage {
  _TourResultsDaoStorage(CyclingEscapeDatabase db) : super(db);

  @override
  Future<List<ResultData>> getAllResults() async => (await select(dbTourResultsTable).get()).map((result) => result.model).toList();

  @override
  Future<void> saveResults(List<ResultData> results) async {
    await delete(dbTourResultsTable).go();
    await batch((batch) => batch.insertAll(dbTourResultsTable, results.map((result) => result.dbModel)));
  }
}
