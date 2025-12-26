// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CharacterImpl _$$CharacterImplFromJson(Map<String, dynamic> json) =>
    _$CharacterImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      locationId: json['locationId'] as String,
      description: json['description'] as String,
      initialDialogue: json['initialDialogue'] as String,
      conditionalDialogue:
          (json['conditionalDialogue'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$CharacterImplToJson(_$CharacterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'locationId': instance.locationId,
      'description': instance.description,
      'initialDialogue': instance.initialDialogue,
      'conditionalDialogue': instance.conditionalDialogue,
    };
