// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bound_case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BoundLocation _$BoundLocationFromJson(Map<String, dynamic> json) {
  return _BoundLocation.fromJson(json);
}

/// @nodoc
mixin _$BoundLocation {
  /// The template location ID this is bound to
  String get templateId => throw _privateConstructorUsedError;

  /// The real-world POI
  POI get poi => throw _privateConstructorUsedError;

  /// Display name (may incorporate POI name or template description)
  String get displayName => throw _privateConstructorUsedError;

  /// Distance from the player's starting position in meters
  double get distanceFromStart => throw _privateConstructorUsedError;

  /// Serializes this BoundLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoundLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoundLocationCopyWith<BoundLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoundLocationCopyWith<$Res> {
  factory $BoundLocationCopyWith(
    BoundLocation value,
    $Res Function(BoundLocation) then,
  ) = _$BoundLocationCopyWithImpl<$Res, BoundLocation>;
  @useResult
  $Res call({
    String templateId,
    POI poi,
    String displayName,
    double distanceFromStart,
  });

  $POICopyWith<$Res> get poi;
}

/// @nodoc
class _$BoundLocationCopyWithImpl<$Res, $Val extends BoundLocation>
    implements $BoundLocationCopyWith<$Res> {
  _$BoundLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoundLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? poi = null,
    Object? displayName = null,
    Object? distanceFromStart = null,
  }) {
    return _then(
      _value.copyWith(
            templateId: null == templateId
                ? _value.templateId
                : templateId // ignore: cast_nullable_to_non_nullable
                      as String,
            poi: null == poi
                ? _value.poi
                : poi // ignore: cast_nullable_to_non_nullable
                      as POI,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            distanceFromStart: null == distanceFromStart
                ? _value.distanceFromStart
                : distanceFromStart // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of BoundLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $POICopyWith<$Res> get poi {
    return $POICopyWith<$Res>(_value.poi, (value) {
      return _then(_value.copyWith(poi: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoundLocationImplCopyWith<$Res>
    implements $BoundLocationCopyWith<$Res> {
  factory _$$BoundLocationImplCopyWith(
    _$BoundLocationImpl value,
    $Res Function(_$BoundLocationImpl) then,
  ) = __$$BoundLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String templateId,
    POI poi,
    String displayName,
    double distanceFromStart,
  });

  @override
  $POICopyWith<$Res> get poi;
}

/// @nodoc
class __$$BoundLocationImplCopyWithImpl<$Res>
    extends _$BoundLocationCopyWithImpl<$Res, _$BoundLocationImpl>
    implements _$$BoundLocationImplCopyWith<$Res> {
  __$$BoundLocationImplCopyWithImpl(
    _$BoundLocationImpl _value,
    $Res Function(_$BoundLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoundLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? poi = null,
    Object? displayName = null,
    Object? distanceFromStart = null,
  }) {
    return _then(
      _$BoundLocationImpl(
        templateId: null == templateId
            ? _value.templateId
            : templateId // ignore: cast_nullable_to_non_nullable
                  as String,
        poi: null == poi
            ? _value.poi
            : poi // ignore: cast_nullable_to_non_nullable
                  as POI,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        distanceFromStart: null == distanceFromStart
            ? _value.distanceFromStart
            : distanceFromStart // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoundLocationImpl implements _BoundLocation {
  const _$BoundLocationImpl({
    required this.templateId,
    required this.poi,
    required this.displayName,
    required this.distanceFromStart,
  });

  factory _$BoundLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoundLocationImplFromJson(json);

  /// The template location ID this is bound to
  @override
  final String templateId;

  /// The real-world POI
  @override
  final POI poi;

  /// Display name (may incorporate POI name or template description)
  @override
  final String displayName;

  /// Distance from the player's starting position in meters
  @override
  final double distanceFromStart;

  @override
  String toString() {
    return 'BoundLocation(templateId: $templateId, poi: $poi, displayName: $displayName, distanceFromStart: $distanceFromStart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoundLocationImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.poi, poi) || other.poi == poi) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.distanceFromStart, distanceFromStart) ||
                other.distanceFromStart == distanceFromStart));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, templateId, poi, displayName, distanceFromStart);

  /// Create a copy of BoundLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoundLocationImplCopyWith<_$BoundLocationImpl> get copyWith =>
      __$$BoundLocationImplCopyWithImpl<_$BoundLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoundLocationImplToJson(this);
  }
}

abstract class _BoundLocation implements BoundLocation {
  const factory _BoundLocation({
    required final String templateId,
    required final POI poi,
    required final String displayName,
    required final double distanceFromStart,
  }) = _$BoundLocationImpl;

  factory _BoundLocation.fromJson(Map<String, dynamic> json) =
      _$BoundLocationImpl.fromJson;

  /// The template location ID this is bound to
  @override
  String get templateId;

  /// The real-world POI
  @override
  POI get poi;

  /// Display name (may incorporate POI name or template description)
  @override
  String get displayName;

  /// Distance from the player's starting position in meters
  @override
  double get distanceFromStart;

  /// Create a copy of BoundLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoundLocationImplCopyWith<_$BoundLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BoundCase _$BoundCaseFromJson(Map<String, dynamic> json) {
  return _BoundCase.fromJson(json);
}

/// @nodoc
mixin _$BoundCase {
  /// The original case template
  CaseTemplate get template => throw _privateConstructorUsedError;

  /// Where the player started the game
  @LatLngConverter()
  LatLng get playerStart => throw _privateConstructorUsedError;

  /// Successfully bound locations mapped by template location ID
  Map<String, BoundLocation> get boundLocations =>
      throw _privateConstructorUsedError;

  /// Template location IDs that couldn't be bound (optional locations only)
  List<String> get unboundOptional => throw _privateConstructorUsedError;

  /// Serializes this BoundCase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoundCase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoundCaseCopyWith<BoundCase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoundCaseCopyWith<$Res> {
  factory $BoundCaseCopyWith(BoundCase value, $Res Function(BoundCase) then) =
      _$BoundCaseCopyWithImpl<$Res, BoundCase>;
  @useResult
  $Res call({
    CaseTemplate template,
    @LatLngConverter() LatLng playerStart,
    Map<String, BoundLocation> boundLocations,
    List<String> unboundOptional,
  });

  $CaseTemplateCopyWith<$Res> get template;
}

/// @nodoc
class _$BoundCaseCopyWithImpl<$Res, $Val extends BoundCase>
    implements $BoundCaseCopyWith<$Res> {
  _$BoundCaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoundCase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? template = null,
    Object? playerStart = null,
    Object? boundLocations = null,
    Object? unboundOptional = null,
  }) {
    return _then(
      _value.copyWith(
            template: null == template
                ? _value.template
                : template // ignore: cast_nullable_to_non_nullable
                      as CaseTemplate,
            playerStart: null == playerStart
                ? _value.playerStart
                : playerStart // ignore: cast_nullable_to_non_nullable
                      as LatLng,
            boundLocations: null == boundLocations
                ? _value.boundLocations
                : boundLocations // ignore: cast_nullable_to_non_nullable
                      as Map<String, BoundLocation>,
            unboundOptional: null == unboundOptional
                ? _value.unboundOptional
                : unboundOptional // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of BoundCase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CaseTemplateCopyWith<$Res> get template {
    return $CaseTemplateCopyWith<$Res>(_value.template, (value) {
      return _then(_value.copyWith(template: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BoundCaseImplCopyWith<$Res>
    implements $BoundCaseCopyWith<$Res> {
  factory _$$BoundCaseImplCopyWith(
    _$BoundCaseImpl value,
    $Res Function(_$BoundCaseImpl) then,
  ) = __$$BoundCaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CaseTemplate template,
    @LatLngConverter() LatLng playerStart,
    Map<String, BoundLocation> boundLocations,
    List<String> unboundOptional,
  });

  @override
  $CaseTemplateCopyWith<$Res> get template;
}

/// @nodoc
class __$$BoundCaseImplCopyWithImpl<$Res>
    extends _$BoundCaseCopyWithImpl<$Res, _$BoundCaseImpl>
    implements _$$BoundCaseImplCopyWith<$Res> {
  __$$BoundCaseImplCopyWithImpl(
    _$BoundCaseImpl _value,
    $Res Function(_$BoundCaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoundCase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? template = null,
    Object? playerStart = null,
    Object? boundLocations = null,
    Object? unboundOptional = null,
  }) {
    return _then(
      _$BoundCaseImpl(
        template: null == template
            ? _value.template
            : template // ignore: cast_nullable_to_non_nullable
                  as CaseTemplate,
        playerStart: null == playerStart
            ? _value.playerStart
            : playerStart // ignore: cast_nullable_to_non_nullable
                  as LatLng,
        boundLocations: null == boundLocations
            ? _value._boundLocations
            : boundLocations // ignore: cast_nullable_to_non_nullable
                  as Map<String, BoundLocation>,
        unboundOptional: null == unboundOptional
            ? _value._unboundOptional
            : unboundOptional // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoundCaseImpl extends _BoundCase {
  const _$BoundCaseImpl({
    required this.template,
    @LatLngConverter() required this.playerStart,
    final Map<String, BoundLocation> boundLocations = const {},
    final List<String> unboundOptional = const [],
  }) : _boundLocations = boundLocations,
       _unboundOptional = unboundOptional,
       super._();

  factory _$BoundCaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoundCaseImplFromJson(json);

  /// The original case template
  @override
  final CaseTemplate template;

  /// Where the player started the game
  @override
  @LatLngConverter()
  final LatLng playerStart;

  /// Successfully bound locations mapped by template location ID
  final Map<String, BoundLocation> _boundLocations;

  /// Successfully bound locations mapped by template location ID
  @override
  @JsonKey()
  Map<String, BoundLocation> get boundLocations {
    if (_boundLocations is EqualUnmodifiableMapView) return _boundLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_boundLocations);
  }

  /// Template location IDs that couldn't be bound (optional locations only)
  final List<String> _unboundOptional;

  /// Template location IDs that couldn't be bound (optional locations only)
  @override
  @JsonKey()
  List<String> get unboundOptional {
    if (_unboundOptional is EqualUnmodifiableListView) return _unboundOptional;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unboundOptional);
  }

  @override
  String toString() {
    return 'BoundCase(template: $template, playerStart: $playerStart, boundLocations: $boundLocations, unboundOptional: $unboundOptional)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoundCaseImpl &&
            (identical(other.template, template) ||
                other.template == template) &&
            (identical(other.playerStart, playerStart) ||
                other.playerStart == playerStart) &&
            const DeepCollectionEquality().equals(
              other._boundLocations,
              _boundLocations,
            ) &&
            const DeepCollectionEquality().equals(
              other._unboundOptional,
              _unboundOptional,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    template,
    playerStart,
    const DeepCollectionEquality().hash(_boundLocations),
    const DeepCollectionEquality().hash(_unboundOptional),
  );

  /// Create a copy of BoundCase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoundCaseImplCopyWith<_$BoundCaseImpl> get copyWith =>
      __$$BoundCaseImplCopyWithImpl<_$BoundCaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoundCaseImplToJson(this);
  }
}

abstract class _BoundCase extends BoundCase {
  const factory _BoundCase({
    required final CaseTemplate template,
    @LatLngConverter() required final LatLng playerStart,
    final Map<String, BoundLocation> boundLocations,
    final List<String> unboundOptional,
  }) = _$BoundCaseImpl;
  const _BoundCase._() : super._();

  factory _BoundCase.fromJson(Map<String, dynamic> json) =
      _$BoundCaseImpl.fromJson;

  /// The original case template
  @override
  CaseTemplate get template;

  /// Where the player started the game
  @override
  @LatLngConverter()
  LatLng get playerStart;

  /// Successfully bound locations mapped by template location ID
  @override
  Map<String, BoundLocation> get boundLocations;

  /// Template location IDs that couldn't be bound (optional locations only)
  @override
  List<String> get unboundOptional;

  /// Create a copy of BoundCase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoundCaseImplCopyWith<_$BoundCaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
