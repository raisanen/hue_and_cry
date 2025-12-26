// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      caseId: json['caseId'] as String,
      phase:
          $enumDecodeNullable(_$GamePhaseEnumMap, json['phase']) ??
          GamePhase.setup,
      visitedLocations:
          (json['visitedLocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      discoveredClues:
          (json['discoveredClues'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      unlockedLocations:
          (json['unlockedLocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      visitOrder:
          (json['visitOrder'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'caseId': instance.caseId,
      'phase': _$GamePhaseEnumMap[instance.phase]!,
      'visitedLocations': instance.visitedLocations.toList(),
      'discoveredClues': instance.discoveredClues.toList(),
      'unlockedLocations': instance.unlockedLocations.toList(),
      'visitOrder': instance.visitOrder,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$GamePhaseEnumMap = {
  GamePhase.setup: 'setup',
  GamePhase.active: 'active',
  GamePhase.solved: 'solved',
};
