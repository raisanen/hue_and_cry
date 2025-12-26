// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bound_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoundLocationImpl _$$BoundLocationImplFromJson(Map<String, dynamic> json) =>
    _$BoundLocationImpl(
      templateId: json['templateId'] as String,
      poi: POI.fromJson(json['poi'] as Map<String, dynamic>),
      displayName: json['displayName'] as String,
      distanceFromStart: (json['distanceFromStart'] as num).toDouble(),
    );

Map<String, dynamic> _$$BoundLocationImplToJson(_$BoundLocationImpl instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'poi': instance.poi,
      'displayName': instance.displayName,
      'distanceFromStart': instance.distanceFromStart,
    };

_$BoundCaseImpl _$$BoundCaseImplFromJson(Map<String, dynamic> json) =>
    _$BoundCaseImpl(
      template: CaseTemplate.fromJson(json['template'] as Map<String, dynamic>),
      playerStart: const LatLngConverter().fromJson(
        json['playerStart'] as Map<String, dynamic>,
      ),
      boundLocations:
          (json['boundLocations'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, BoundLocation.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      unboundOptional:
          (json['unboundOptional'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BoundCaseImplToJson(_$BoundCaseImpl instance) =>
    <String, dynamic>{
      'template': instance.template,
      'playerStart': const LatLngConverter().toJson(instance.playerStart),
      'boundLocations': instance.boundLocations,
      'unboundOptional': instance.unboundOptional,
    };
