// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Career _$CareerFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['riders', 'rankingTypes', 'raceTypes', 'cash'],
  );
  return Career(
    riders: json['riders'] as int,
    rankingTypes: json['rankingTypes'] as int,
    raceTypes: json['raceTypes'] as int,
    cash: json['cash'] as int,
  );
}

Map<String, dynamic> _$CareerToJson(Career instance) => <String, dynamic>{
      'riders': instance.riders,
      'rankingTypes': instance.rankingTypes,
      'raceTypes': instance.raceTypes,
      'cash': instance.cash,
    };
