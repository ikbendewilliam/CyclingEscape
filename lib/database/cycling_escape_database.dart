import 'package:drift/drift.dart';

part 'cycling_escape_database.g.dart';

@DriftDatabase(tables: [
])
class FlutterTemplateDatabase extends _$FlutterTemplateDatabase {
  FlutterTemplateDatabase(QueryExecutor db) : super(db);

  FlutterTemplateDatabase.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  Future<void> deleteAllData() {
    return transaction(() async {
      for (final table in allTables) {
        await delete<Table, dynamic>(table).go();
      }
    });
  }
}
