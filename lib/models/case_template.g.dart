// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaseTemplateImpl _$$CaseTemplateImplFromJson(Map<String, dynamic> json) =>
    _$CaseTemplateImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      teaser: json['teaser'] as String,
      briefing: json['briefing'] as String,
      locations:
          (json['locations'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              LocationRequirement.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
      characters:
          (json['characters'] as List<dynamic>?)
              ?.map((e) => Character.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      clues:
          (json['clues'] as List<dynamic>?)
              ?.map((e) => Clue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      solution: Solution.fromJson(json['solution'] as Map<String, dynamic>),
      parVisits: (json['parVisits'] as num?)?.toInt() ?? 5,
      estimatedMinutes: (json['estimatedMinutes'] as num?)?.toInt() ?? 60,
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$$CaseTemplateImplToJson(_$CaseTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'teaser': instance.teaser,
      'briefing': instance.briefing,
      'locations': instance.locations,
      'characters': instance.characters,
      'clues': instance.clues,
      'solution': instance.solution,
      'parVisits': instance.parVisits,
      'estimatedMinutes': instance.estimatedMinutes,
      'difficulty': instance.difficulty,
    };
