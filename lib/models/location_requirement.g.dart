// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_requirement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationRequirementImpl _$$LocationRequirementImplFromJson(
  Map<String, dynamic> json,
) => _$LocationRequirementImpl(
  id: json['id'] as String,
  role: $enumDecode(_$StoryRoleEnumMap, json['role']),
  preferredTags:
      (json['preferredTags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  required: json['required'] as bool? ?? true,
  fallbackRole: $enumDecodeNullable(_$StoryRoleEnumMap, json['fallbackRole']),
  descriptionTemplate: json['descriptionTemplate'] as String? ?? '',
);

Map<String, dynamic> _$$LocationRequirementImplToJson(
  _$LocationRequirementImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'role': _$StoryRoleEnumMap[instance.role]!,
  'preferredTags': instance.preferredTags,
  'required': instance.required,
  'fallbackRole': _$StoryRoleEnumMap[instance.fallbackRole],
  'descriptionTemplate': instance.descriptionTemplate,
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
