// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$POIImpl _$$POIImplFromJson(Map<String, dynamic> json) => _$POIImpl(
  osmId: (json['osmId'] as num).toInt(),
  name: json['name'] as String?,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  osmTags:
      (json['osmTags'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  storyRoles:
      (json['storyRoles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$StoryRoleEnumMap, e))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$POIImplToJson(_$POIImpl instance) => <String, dynamic>{
  'osmId': instance.osmId,
  'name': instance.name,
  'lat': instance.lat,
  'lon': instance.lon,
  'osmTags': instance.osmTags,
  'storyRoles': instance.storyRoles.map((e) => _$StoryRoleEnumMap[e]!).toList(),
};

const _$StoryRoleEnumMap = {
  StoryRole.crimeScene: 'crimeScene',
  StoryRole.witness: 'witness',
  StoryRole.suspectWork: 'suspectWork',
  StoryRole.information: 'information',
  StoryRole.authority: 'authority',
  StoryRole.hidden: 'hidden',
  StoryRole.atmosphere: 'atmosphere',
};
