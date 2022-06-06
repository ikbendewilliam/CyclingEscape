import 'package:cycling_escape/database/cycling_escape_database.dart';
import 'package:cycling_escape/widget_game/data/result_data.dart';
import 'package:cycling_escape/widget_game/data/team.dart';
import 'package:drift/drift.dart';

@DataClassName('DbCareerResults')
class DbCareerResultsTable extends Table {
  @override
  Set<Column>? get primaryKey => {number};

  IntColumn get number => integer()();

  IntColumn get time => integer()();

  IntColumn get points => integer()();

  IntColumn get rank => integer()();

  IntColumn get teamNumberStart => integer().nullable()();

  BoolColumn get teamIsPlayer => boolean()();
}

extension DbCareerResultsExtension on DbCareerResults {
  ResultData get model => ResultData(
        rank,
        time,
        points,
        0,
        number,
        Team(teamIsPlayer, teamNumberStart, null),
        0,
      );
}

extension ResultDataExtension on ResultData {
  DbCareerResults get dbModel => DbCareerResults(
        number: number,
        time: time,
        points: points,
        rank: rank,
        teamNumberStart: team?.numberStart,
        teamIsPlayer: team?.isPlayer ?? false,
      );
}
