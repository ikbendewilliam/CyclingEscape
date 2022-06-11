import 'package:cycling_escape/database/cycling_escape_database.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:drift/drift.dart';

@DataClassName('DbTourResults')
class DbTourResultsTable extends Table {
  @override
  Set<Column>? get primaryKey => {number};

  IntColumn get number => integer()();

  IntColumn get time => integer()();

  IntColumn get points => integer()();

  IntColumn get rank => integer()();

  IntColumn get mountain => integer()();

  RealColumn get value => real().nullable()();

  IntColumn get teamNumberStart => integer().nullable()();

  BoolColumn get teamIsPlayer => boolean().nullable()();
}

extension DbTourResultsExtension on DbTourResults {
  ResultData get model => ResultData(
        rank,
        time,
        points,
        mountain,
        number,
        Team(teamIsPlayer, teamNumberStart, null),
        value,
      );
}

extension ResultDataExtension on ResultData {
  DbTourResults get dbModel => DbTourResults(
        number: number,
        time: time,
        points: points,
        mountain: mountain,
        rank: rank,
        value: value,
        teamIsPlayer: team?.isPlayer,
        teamNumberStart: team?.numberStart,
      );
}
