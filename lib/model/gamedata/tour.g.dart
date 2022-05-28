// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tour _$TourFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'teams',
      'ridersPerTeam',
      'races',
      'mapType',
      'mapLength'
    ],
  );
  return Tour(
    teams: json['teams'] as int,
    ridersPerTeam: json['ridersPerTeam'] as int,
    races: json['races'] as int,
    mapType: $enumDecode(_$MapTypeEnumMap, json['mapType']),
    mapLength: $enumDecode(_$MapLengthEnumMap, json['mapLength']),
  );
}

Map<String, dynamic> _$TourToJson(Tour instance) => <String, dynamic>{
      'teams': instance.teams,
      'ridersPerTeam': instance.ridersPerTeam,
      'races': instance.races,
      'mapType': _$MapTypeEnumMap[instance.mapType],
      'mapLength': _$MapLengthEnumMap[instance.mapLength],
    };

const _$MapTypeEnumMap = {
  MapType.flat: 'flat',
  MapType.cobble: 'cobble',
  MapType.hills: 'hills',
  MapType.heavy: 'heavy',
};

const _$MapLengthEnumMap = {
  MapLength.short: 'short',
  MapLength.medium: 'medium',
  MapLength.long: 'long',
  MapLength.veryLong: 'veryLong',
};
