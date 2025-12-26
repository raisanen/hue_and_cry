// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClueImpl _$$ClueImplFromJson(Map<String, dynamic> json) => _$ClueImpl(
  id: json['id'] as String,
  type: $enumDecode(_$ClueTypeEnumMap, json['type']),
  locationId: json['locationId'] as String,
  title: json['title'] as String,
  discoveryText: json['discoveryText'] as String,
  notebookSummary: json['notebookSummary'] as String,
  prerequisites:
      (json['prerequisites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  reveals:
      (json['reveals'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  characterId: json['characterId'] as String?,
  isEssential: json['isEssential'] as bool? ?? false,
  isRedHerring: json['isRedHerring'] as bool? ?? false,
);

Map<String, dynamic> _$$ClueImplToJson(_$ClueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ClueTypeEnumMap[instance.type]!,
      'locationId': instance.locationId,
      'title': instance.title,
      'discoveryText': instance.discoveryText,
      'notebookSummary': instance.notebookSummary,
      'prerequisites': instance.prerequisites,
      'reveals': instance.reveals,
      'characterId': instance.characterId,
      'isEssential': instance.isEssential,
      'isRedHerring': instance.isRedHerring,
    };

const _$ClueTypeEnumMap = {
  ClueType.physical: 'physical',
  ClueType.testimony: 'testimony',
  ClueType.observation: 'observation',
  ClueType.record: 'record',
};
