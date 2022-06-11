import 'package:cycling_escape/database/cycling_escape_database.dart';
import 'package:cycling_escape/model/database/career_results.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

part 'calendar_results_dao_storage.g.dart';

@lazySingleton
abstract class CareerResultsDaoStorage {
  @factoryMethod
  factory CareerResultsDaoStorage(CyclingEscapeDatabase database) = _CareerResultsDaoStorage;

  Future<List<ResultData>> getAllResults();

  Future<void> saveResults(List<ResultData> results);
}

@DriftAccessor(tables: [
  DbCareerResultsTable,
])
class _CareerResultsDaoStorage extends DatabaseAccessor<CyclingEscapeDatabase> with _$_CareerResultsDaoStorageMixin implements CareerResultsDaoStorage {
  _CareerResultsDaoStorage(CyclingEscapeDatabase db) : super(db);

  @override
  Future<List<ResultData>> getAllResults() async => (await select(dbCareerResultsTable).get()).map((result) => result.model).toList();

  @override
  Future<void> saveResults(List<ResultData> results) async {
    await delete(dbCareerResultsTable).go();
    await batch((batch) => batch.insertAll(dbCareerResultsTable, results.map((result) => result.dbModel)));
  }
}
