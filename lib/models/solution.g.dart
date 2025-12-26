// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SolutionImpl _$$SolutionImplFromJson(Map<String, dynamic> json) =>
    _$SolutionImpl(
      perpetratorId: json['perpetratorId'] as String,
      motive: json['motive'] as String,
      method: json['method'] as String,
      keyEvidence:
          (json['keyEvidence'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      optimalPath:
          (json['optimalPath'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SolutionImplToJson(_$SolutionImpl instance) =>
    <String, dynamic>{
      'perpetratorId': instance.perpetratorId,
      'motive': instance.motive,
      'method': instance.method,
      'keyEvidence': instance.keyEvidence,
      'optimalPath': instance.optimalPath,
    };
