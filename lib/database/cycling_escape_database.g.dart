// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycling_escape_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DbTourResults extends DataClass implements Insertable<DbTourResults> {
  final int number;
  final int time;
  final int points;
  final int rank;
  final int mountain;
  final double? value;
  final int? teamNumberStart;
  final bool? teamIsPlayer;
  DbTourResults(
      {required this.number,
      required this.time,
      required this.points,
      required this.rank,
      required this.mountain,
      this.value,
      this.teamNumberStart,
      this.teamIsPlayer});
  factory DbTourResults.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbTourResults(
      number: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}number'])!,
      time: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time'])!,
      points: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}points'])!,
      rank: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rank'])!,
      mountain: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}mountain'])!,
      value: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}value']),
      teamNumberStart: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}team_number_start']),
      teamIsPlayer: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}team_is_player']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['number'] = Variable<int>(number);
    map['time'] = Variable<int>(time);
    map['points'] = Variable<int>(points);
    map['rank'] = Variable<int>(rank);
    map['mountain'] = Variable<int>(mountain);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double?>(value);
    }
    if (!nullToAbsent || teamNumberStart != null) {
      map['team_number_start'] = Variable<int?>(teamNumberStart);
    }
    if (!nullToAbsent || teamIsPlayer != null) {
      map['team_is_player'] = Variable<bool?>(teamIsPlayer);
    }
    return map;
  }

  DbTourResultsTableCompanion toCompanion(bool nullToAbsent) {
    return DbTourResultsTableCompanion(
      number: Value(number),
      time: Value(time),
      points: Value(points),
      rank: Value(rank),
      mountain: Value(mountain),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      teamNumberStart: teamNumberStart == null && nullToAbsent
          ? const Value.absent()
          : Value(teamNumberStart),
      teamIsPlayer: teamIsPlayer == null && nullToAbsent
          ? const Value.absent()
          : Value(teamIsPlayer),
    );
  }

  factory DbTourResults.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTourResults(
      number: serializer.fromJson<int>(json['number']),
      time: serializer.fromJson<int>(json['time']),
      points: serializer.fromJson<int>(json['points']),
      rank: serializer.fromJson<int>(json['rank']),
      mountain: serializer.fromJson<int>(json['mountain']),
      value: serializer.fromJson<double?>(json['value']),
      teamNumberStart: serializer.fromJson<int?>(json['teamNumberStart']),
      teamIsPlayer: serializer.fromJson<bool?>(json['teamIsPlayer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'number': serializer.toJson<int>(number),
      'time': serializer.toJson<int>(time),
      'points': serializer.toJson<int>(points),
      'rank': serializer.toJson<int>(rank),
      'mountain': serializer.toJson<int>(mountain),
      'value': serializer.toJson<double?>(value),
      'teamNumberStart': serializer.toJson<int?>(teamNumberStart),
      'teamIsPlayer': serializer.toJson<bool?>(teamIsPlayer),
    };
  }

  DbTourResults copyWith(
          {int? number,
          int? time,
          int? points,
          int? rank,
          int? mountain,
          double? value,
          int? teamNumberStart,
          bool? teamIsPlayer}) =>
      DbTourResults(
        number: number ?? this.number,
        time: time ?? this.time,
        points: points ?? this.points,
        rank: rank ?? this.rank,
        mountain: mountain ?? this.mountain,
        value: value ?? this.value,
        teamNumberStart: teamNumberStart ?? this.teamNumberStart,
        teamIsPlayer: teamIsPlayer ?? this.teamIsPlayer,
      );
  @override
  String toString() {
    return (StringBuffer('DbTourResults(')
          ..write('number: $number, ')
          ..write('time: $time, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('mountain: $mountain, ')
          ..write('value: $value, ')
          ..write('teamNumberStart: $teamNumberStart, ')
          ..write('teamIsPlayer: $teamIsPlayer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(number, time, points, rank, mountain, value,
      teamNumberStart, teamIsPlayer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTourResults &&
          other.number == this.number &&
          other.time == this.time &&
          other.points == this.points &&
          other.rank == this.rank &&
          other.mountain == this.mountain &&
          other.value == this.value &&
          other.teamNumberStart == this.teamNumberStart &&
          other.teamIsPlayer == this.teamIsPlayer);
}

class DbTourResultsTableCompanion extends UpdateCompanion<DbTourResults> {
  final Value<int> number;
  final Value<int> time;
  final Value<int> points;
  final Value<int> rank;
  final Value<int> mountain;
  final Value<double?> value;
  final Value<int?> teamNumberStart;
  final Value<bool?> teamIsPlayer;
  const DbTourResultsTableCompanion({
    this.number = const Value.absent(),
    this.time = const Value.absent(),
    this.points = const Value.absent(),
    this.rank = const Value.absent(),
    this.mountain = const Value.absent(),
    this.value = const Value.absent(),
    this.teamNumberStart = const Value.absent(),
    this.teamIsPlayer = const Value.absent(),
  });
  DbTourResultsTableCompanion.insert({
    this.number = const Value.absent(),
    required int time,
    required int points,
    required int rank,
    required int mountain,
    this.value = const Value.absent(),
    this.teamNumberStart = const Value.absent(),
    this.teamIsPlayer = const Value.absent(),
  })  : time = Value(time),
        points = Value(points),
        rank = Value(rank),
        mountain = Value(mountain);
  static Insertable<DbTourResults> custom({
    Expression<int>? number,
    Expression<int>? time,
    Expression<int>? points,
    Expression<int>? rank,
    Expression<int>? mountain,
    Expression<double?>? value,
    Expression<int?>? teamNumberStart,
    Expression<bool?>? teamIsPlayer,
  }) {
    return RawValuesInsertable({
      if (number != null) 'number': number,
      if (time != null) 'time': time,
      if (points != null) 'points': points,
      if (rank != null) 'rank': rank,
      if (mountain != null) 'mountain': mountain,
      if (value != null) 'value': value,
      if (teamNumberStart != null) 'team_number_start': teamNumberStart,
      if (teamIsPlayer != null) 'team_is_player': teamIsPlayer,
    });
  }

  DbTourResultsTableCompanion copyWith(
      {Value<int>? number,
      Value<int>? time,
      Value<int>? points,
      Value<int>? rank,
      Value<int>? mountain,
      Value<double?>? value,
      Value<int?>? teamNumberStart,
      Value<bool?>? teamIsPlayer}) {
    return DbTourResultsTableCompanion(
      number: number ?? this.number,
      time: time ?? this.time,
      points: points ?? this.points,
      rank: rank ?? this.rank,
      mountain: mountain ?? this.mountain,
      value: value ?? this.value,
      teamNumberStart: teamNumberStart ?? this.teamNumberStart,
      teamIsPlayer: teamIsPlayer ?? this.teamIsPlayer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (mountain.present) {
      map['mountain'] = Variable<int>(mountain.value);
    }
    if (value.present) {
      map['value'] = Variable<double?>(value.value);
    }
    if (teamNumberStart.present) {
      map['team_number_start'] = Variable<int?>(teamNumberStart.value);
    }
    if (teamIsPlayer.present) {
      map['team_is_player'] = Variable<bool?>(teamIsPlayer.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbTourResultsTableCompanion(')
          ..write('number: $number, ')
          ..write('time: $time, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('mountain: $mountain, ')
          ..write('value: $value, ')
          ..write('teamNumberStart: $teamNumberStart, ')
          ..write('teamIsPlayer: $teamIsPlayer')
          ..write(')'))
        .toString();
  }
}

class $DbTourResultsTableTable extends DbTourResultsTable
    with TableInfo<$DbTourResultsTableTable, DbTourResults> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DbTourResultsTableTable(this._db, [this._alias]);
  final VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int?> number = GeneratedColumn<int?>(
      'number', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int?> time = GeneratedColumn<int?>(
      'time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int?> points = GeneratedColumn<int?>(
      'points', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int?> rank = GeneratedColumn<int?>(
      'rank', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _mountainMeta = const VerificationMeta('mountain');
  @override
  late final GeneratedColumn<int?> mountain = GeneratedColumn<int?>(
      'mountain', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double?> value = GeneratedColumn<double?>(
      'value', aliasedName, true,
      type: const RealType(), requiredDuringInsert: false);
  final VerificationMeta _teamNumberStartMeta =
      const VerificationMeta('teamNumberStart');
  @override
  late final GeneratedColumn<int?> teamNumberStart = GeneratedColumn<int?>(
      'team_number_start', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _teamIsPlayerMeta =
      const VerificationMeta('teamIsPlayer');
  @override
  late final GeneratedColumn<bool?> teamIsPlayer = GeneratedColumn<bool?>(
      'team_is_player', aliasedName, true,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (team_is_player IN (0, 1))');
  @override
  List<GeneratedColumn> get $columns => [
        number,
        time,
        points,
        rank,
        mountain,
        value,
        teamNumberStart,
        teamIsPlayer
      ];
  @override
  String get aliasedName => _alias ?? 'db_tour_results_table';
  @override
  String get actualTableName => 'db_tour_results_table';
  @override
  VerificationContext validateIntegrity(Insertable<DbTourResults> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('points')) {
      context.handle(_pointsMeta,
          points.isAcceptableOrUnknown(data['points']!, _pointsMeta));
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
          _rankMeta, rank.isAcceptableOrUnknown(data['rank']!, _rankMeta));
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('mountain')) {
      context.handle(_mountainMeta,
          mountain.isAcceptableOrUnknown(data['mountain']!, _mountainMeta));
    } else if (isInserting) {
      context.missing(_mountainMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('team_number_start')) {
      context.handle(
          _teamNumberStartMeta,
          teamNumberStart.isAcceptableOrUnknown(
              data['team_number_start']!, _teamNumberStartMeta));
    }
    if (data.containsKey('team_is_player')) {
      context.handle(
          _teamIsPlayerMeta,
          teamIsPlayer.isAcceptableOrUnknown(
              data['team_is_player']!, _teamIsPlayerMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {number};
  @override
  DbTourResults map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DbTourResults.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbTourResultsTableTable createAlias(String alias) {
    return $DbTourResultsTableTable(_db, alias);
  }
}

class DbCareerCalendarEventWinners extends DataClass
    implements Insertable<DbCareerCalendarEventWinners> {
  final int resultId;
  final int number;
  DbCareerCalendarEventWinners({required this.resultId, required this.number});
  factory DbCareerCalendarEventWinners.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbCareerCalendarEventWinners(
      resultId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}result_id'])!,
      number: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}number'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['result_id'] = Variable<int>(resultId);
    map['number'] = Variable<int>(number);
    return map;
  }

  DbCareerCalendarEventWinnersTableCompanion toCompanion(bool nullToAbsent) {
    return DbCareerCalendarEventWinnersTableCompanion(
      resultId: Value(resultId),
      number: Value(number),
    );
  }

  factory DbCareerCalendarEventWinners.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCareerCalendarEventWinners(
      resultId: serializer.fromJson<int>(json['resultId']),
      number: serializer.fromJson<int>(json['number']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'resultId': serializer.toJson<int>(resultId),
      'number': serializer.toJson<int>(number),
    };
  }

  DbCareerCalendarEventWinners copyWith({int? resultId, int? number}) =>
      DbCareerCalendarEventWinners(
        resultId: resultId ?? this.resultId,
        number: number ?? this.number,
      );
  @override
  String toString() {
    return (StringBuffer('DbCareerCalendarEventWinners(')
          ..write('resultId: $resultId, ')
          ..write('number: $number')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(resultId, number);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCareerCalendarEventWinners &&
          other.resultId == this.resultId &&
          other.number == this.number);
}

class DbCareerCalendarEventWinnersTableCompanion
    extends UpdateCompanion<DbCareerCalendarEventWinners> {
  final Value<int> resultId;
  final Value<int> number;
  const DbCareerCalendarEventWinnersTableCompanion({
    this.resultId = const Value.absent(),
    this.number = const Value.absent(),
  });
  DbCareerCalendarEventWinnersTableCompanion.insert({
    required int resultId,
    required int number,
  })  : resultId = Value(resultId),
        number = Value(number);
  static Insertable<DbCareerCalendarEventWinners> custom({
    Expression<int>? resultId,
    Expression<int>? number,
  }) {
    return RawValuesInsertable({
      if (resultId != null) 'result_id': resultId,
      if (number != null) 'number': number,
    });
  }

  DbCareerCalendarEventWinnersTableCompanion copyWith(
      {Value<int>? resultId, Value<int>? number}) {
    return DbCareerCalendarEventWinnersTableCompanion(
      resultId: resultId ?? this.resultId,
      number: number ?? this.number,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (resultId.present) {
      map['result_id'] = Variable<int>(resultId.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCareerCalendarEventWinnersTableCompanion(')
          ..write('resultId: $resultId, ')
          ..write('number: $number')
          ..write(')'))
        .toString();
  }
}

class $DbCareerCalendarEventWinnersTableTable
    extends DbCareerCalendarEventWinnersTable
    with
        TableInfo<$DbCareerCalendarEventWinnersTableTable,
            DbCareerCalendarEventWinners> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DbCareerCalendarEventWinnersTableTable(this._db, [this._alias]);
  final VerificationMeta _resultIdMeta = const VerificationMeta('resultId');
  @override
  late final GeneratedColumn<int?> resultId = GeneratedColumn<int?>(
      'result_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int?> number = GeneratedColumn<int?>(
      'number', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [resultId, number];
  @override
  String get aliasedName => _alias ?? 'db_career_calendar_event_winners_table';
  @override
  String get actualTableName => 'db_career_calendar_event_winners_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DbCareerCalendarEventWinners> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('result_id')) {
      context.handle(_resultIdMeta,
          resultId.isAcceptableOrUnknown(data['result_id']!, _resultIdMeta));
    } else if (isInserting) {
      context.missing(_resultIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {number, resultId};
  @override
  DbCareerCalendarEventWinners map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    return DbCareerCalendarEventWinners.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbCareerCalendarEventWinnersTableTable createAlias(String alias) {
    return $DbCareerCalendarEventWinnersTableTable(_db, alias);
  }
}

class DbCareerResults extends DataClass implements Insertable<DbCareerResults> {
  final int number;
  final int time;
  final int points;
  final int rank;
  final int? teamNumberStart;
  DbCareerResults(
      {required this.number,
      required this.time,
      required this.points,
      required this.rank,
      this.teamNumberStart});
  factory DbCareerResults.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DbCareerResults(
      number: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}number'])!,
      time: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time'])!,
      points: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}points'])!,
      rank: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rank'])!,
      teamNumberStart: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}team_number_start']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['number'] = Variable<int>(number);
    map['time'] = Variable<int>(time);
    map['points'] = Variable<int>(points);
    map['rank'] = Variable<int>(rank);
    if (!nullToAbsent || teamNumberStart != null) {
      map['team_number_start'] = Variable<int?>(teamNumberStart);
    }
    return map;
  }

  DbCareerResultsTableCompanion toCompanion(bool nullToAbsent) {
    return DbCareerResultsTableCompanion(
      number: Value(number),
      time: Value(time),
      points: Value(points),
      rank: Value(rank),
      teamNumberStart: teamNumberStart == null && nullToAbsent
          ? const Value.absent()
          : Value(teamNumberStart),
    );
  }

  factory DbCareerResults.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCareerResults(
      number: serializer.fromJson<int>(json['number']),
      time: serializer.fromJson<int>(json['time']),
      points: serializer.fromJson<int>(json['points']),
      rank: serializer.fromJson<int>(json['rank']),
      teamNumberStart: serializer.fromJson<int?>(json['teamNumberStart']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'number': serializer.toJson<int>(number),
      'time': serializer.toJson<int>(time),
      'points': serializer.toJson<int>(points),
      'rank': serializer.toJson<int>(rank),
      'teamNumberStart': serializer.toJson<int?>(teamNumberStart),
    };
  }

  DbCareerResults copyWith(
          {int? number,
          int? time,
          int? points,
          int? rank,
          int? teamNumberStart}) =>
      DbCareerResults(
        number: number ?? this.number,
        time: time ?? this.time,
        points: points ?? this.points,
        rank: rank ?? this.rank,
        teamNumberStart: teamNumberStart ?? this.teamNumberStart,
      );
  @override
  String toString() {
    return (StringBuffer('DbCareerResults(')
          ..write('number: $number, ')
          ..write('time: $time, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('teamNumberStart: $teamNumberStart')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(number, time, points, rank, teamNumberStart);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCareerResults &&
          other.number == this.number &&
          other.time == this.time &&
          other.points == this.points &&
          other.rank == this.rank &&
          other.teamNumberStart == this.teamNumberStart);
}

class DbCareerResultsTableCompanion extends UpdateCompanion<DbCareerResults> {
  final Value<int> number;
  final Value<int> time;
  final Value<int> points;
  final Value<int> rank;
  final Value<int?> teamNumberStart;
  const DbCareerResultsTableCompanion({
    this.number = const Value.absent(),
    this.time = const Value.absent(),
    this.points = const Value.absent(),
    this.rank = const Value.absent(),
    this.teamNumberStart = const Value.absent(),
  });
  DbCareerResultsTableCompanion.insert({
    this.number = const Value.absent(),
    required int time,
    required int points,
    required int rank,
    this.teamNumberStart = const Value.absent(),
  })  : time = Value(time),
        points = Value(points),
        rank = Value(rank);
  static Insertable<DbCareerResults> custom({
    Expression<int>? number,
    Expression<int>? time,
    Expression<int>? points,
    Expression<int>? rank,
    Expression<int?>? teamNumberStart,
  }) {
    return RawValuesInsertable({
      if (number != null) 'number': number,
      if (time != null) 'time': time,
      if (points != null) 'points': points,
      if (rank != null) 'rank': rank,
      if (teamNumberStart != null) 'team_number_start': teamNumberStart,
    });
  }

  DbCareerResultsTableCompanion copyWith(
      {Value<int>? number,
      Value<int>? time,
      Value<int>? points,
      Value<int>? rank,
      Value<int?>? teamNumberStart}) {
    return DbCareerResultsTableCompanion(
      number: number ?? this.number,
      time: time ?? this.time,
      points: points ?? this.points,
      rank: rank ?? this.rank,
      teamNumberStart: teamNumberStart ?? this.teamNumberStart,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (teamNumberStart.present) {
      map['team_number_start'] = Variable<int?>(teamNumberStart.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCareerResultsTableCompanion(')
          ..write('number: $number, ')
          ..write('time: $time, ')
          ..write('points: $points, ')
          ..write('rank: $rank, ')
          ..write('teamNumberStart: $teamNumberStart')
          ..write(')'))
        .toString();
  }
}

class $DbCareerResultsTableTable extends DbCareerResultsTable
    with TableInfo<$DbCareerResultsTableTable, DbCareerResults> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DbCareerResultsTableTable(this._db, [this._alias]);
  final VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int?> number = GeneratedColumn<int?>(
      'number', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int?> time = GeneratedColumn<int?>(
      'time', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int?> points = GeneratedColumn<int?>(
      'points', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int?> rank = GeneratedColumn<int?>(
      'rank', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _teamNumberStartMeta =
      const VerificationMeta('teamNumberStart');
  @override
  late final GeneratedColumn<int?> teamNumberStart = GeneratedColumn<int?>(
      'team_number_start', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [number, time, points, rank, teamNumberStart];
  @override
  String get aliasedName => _alias ?? 'db_career_results_table';
  @override
  String get actualTableName => 'db_career_results_table';
  @override
  VerificationContext validateIntegrity(Insertable<DbCareerResults> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('points')) {
      context.handle(_pointsMeta,
          points.isAcceptableOrUnknown(data['points']!, _pointsMeta));
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
          _rankMeta, rank.isAcceptableOrUnknown(data['rank']!, _rankMeta));
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('team_number_start')) {
      context.handle(
          _teamNumberStartMeta,
          teamNumberStart.isAcceptableOrUnknown(
              data['team_number_start']!, _teamNumberStartMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {number};
  @override
  DbCareerResults map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DbCareerResults.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DbCareerResultsTableTable createAlias(String alias) {
    return $DbCareerResultsTableTable(_db, alias);
  }
}

abstract class _$CyclingEscapeDatabase extends GeneratedDatabase {
  _$CyclingEscapeDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  _$CyclingEscapeDatabase.connect(DatabaseConnection c) : super.connect(c);
  late final $DbTourResultsTableTable dbTourResultsTable =
      $DbTourResultsTableTable(this);
  late final $DbCareerCalendarEventWinnersTableTable
      dbCareerCalendarEventWinnersTable =
      $DbCareerCalendarEventWinnersTableTable(this);
  late final $DbCareerResultsTableTable dbCareerResultsTable =
      $DbCareerResultsTableTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        dbTourResultsTable,
        dbCareerCalendarEventWinnersTable,
        dbCareerResultsTable
      ];
}
