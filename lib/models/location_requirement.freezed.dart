// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_requirement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LocationRequirement _$LocationRequirementFromJson(Map<String, dynamic> json) {
  return _LocationRequirement.fromJson(json);
}

/// @nodoc
mixin _$LocationRequirement {
  /// Unique identifier for this location within the case
  String get id => throw _privateConstructorUsedError;

  /// Primary story role this location should fulfill
  StoryRole get role => throw _privateConstructorUsedError;

  /// Preferred OSM tags, e.g., ["amenity=cafe", "amenity=restaurant"]
  List<String> get preferredTags => throw _privateConstructorUsedError;

  /// Whether this location is required for the case to be playable
  bool get required => throw _privateConstructorUsedError;

  /// Alternative role to try if primary role has no matches
  StoryRole? get fallbackRole => throw _privateConstructorUsedError;

  /// Template for describing this location, e.g., "a quiet café where..."
  String get descriptionTemplate => throw _privateConstructorUsedError;

  /// Serializes this LocationRequirement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationRequirement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationRequirementCopyWith<LocationRequirement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationRequirementCopyWith<$Res> {
  factory $LocationRequirementCopyWith(
    LocationRequirement value,
    $Res Function(LocationRequirement) then,
  ) = _$LocationRequirementCopyWithImpl<$Res, LocationRequirement>;
  @useResult
  $Res call({
    String id,
    StoryRole role,
    List<String> preferredTags,
    bool required,
    StoryRole? fallbackRole,
    String descriptionTemplate,
  });
}

/// @nodoc
class _$LocationRequirementCopyWithImpl<$Res, $Val extends LocationRequirement>
    implements $LocationRequirementCopyWith<$Res> {
  _$LocationRequirementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationRequirement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? preferredTags = null,
    Object? required = null,
    Object? fallbackRole = freezed,
    Object? descriptionTemplate = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as StoryRole,
            preferredTags: null == preferredTags
                ? _value.preferredTags
                : preferredTags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            required: null == required
                ? _value.required
                : required // ignore: cast_nullable_to_non_nullable
                      as bool,
            fallbackRole: freezed == fallbackRole
                ? _value.fallbackRole
                : fallbackRole // ignore: cast_nullable_to_non_nullable
                      as StoryRole?,
            descriptionTemplate: null == descriptionTemplate
                ? _value.descriptionTemplate
                : descriptionTemplate // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationRequirementImplCopyWith<$Res>
    implements $LocationRequirementCopyWith<$Res> {
  factory _$$LocationRequirementImplCopyWith(
    _$LocationRequirementImpl value,
    $Res Function(_$LocationRequirementImpl) then,
  ) = __$$LocationRequirementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    StoryRole role,
    List<String> preferredTags,
    bool required,
    StoryRole? fallbackRole,
    String descriptionTemplate,
  });
}

/// @nodoc
class __$$LocationRequirementImplCopyWithImpl<$Res>
    extends _$LocationRequirementCopyWithImpl<$Res, _$LocationRequirementImpl>
    implements _$$LocationRequirementImplCopyWith<$Res> {
  __$$LocationRequirementImplCopyWithImpl(
    _$LocationRequirementImpl _value,
    $Res Function(_$LocationRequirementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationRequirement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? preferredTags = null,
    Object? required = null,
    Object? fallbackRole = freezed,
    Object? descriptionTemplate = null,
  }) {
    return _then(
      _$LocationRequirementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as StoryRole,
        preferredTags: null == preferredTags
            ? _value._preferredTags
            : preferredTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        required: null == required
            ? _value.required
            : required // ignore: cast_nullable_to_non_nullable
                  as bool,
        fallbackRole: freezed == fallbackRole
            ? _value.fallbackRole
            : fallbackRole // ignore: cast_nullable_to_non_nullable
                  as StoryRole?,
        descriptionTemplate: null == descriptionTemplate
            ? _value.descriptionTemplate
            : descriptionTemplate // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationRequirementImpl implements _LocationRequirement {
  const _$LocationRequirementImpl({
    required this.id,
    required this.role,
    final List<String> preferredTags = const [],
    this.required = true,
    this.fallbackRole,
    this.descriptionTemplate = '',
  }) : _preferredTags = preferredTags;

  factory _$LocationRequirementImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationRequirementImplFromJson(json);

  /// Unique identifier for this location within the case
  @override
  final String id;

  /// Primary story role this location should fulfill
  @override
  final StoryRole role;

  /// Preferred OSM tags, e.g., ["amenity=cafe", "amenity=restaurant"]
  final List<String> _preferredTags;

  /// Preferred OSM tags, e.g., ["amenity=cafe", "amenity=restaurant"]
  @override
  @JsonKey()
  List<String> get preferredTags {
    if (_preferredTags is EqualUnmodifiableListView) return _preferredTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preferredTags);
  }

  /// Whether this location is required for the case to be playable
  @override
  @JsonKey()
  final bool required;

  /// Alternative role to try if primary role has no matches
  @override
  final StoryRole? fallbackRole;

  /// Template for describing this location, e.g., "a quiet café where..."
  @override
  @JsonKey()
  final String descriptionTemplate;

  @override
  String toString() {
    return 'LocationRequirement(id: $id, role: $role, preferredTags: $preferredTags, required: $required, fallbackRole: $fallbackRole, descriptionTemplate: $descriptionTemplate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationRequirementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality().equals(
              other._preferredTags,
              _preferredTags,
            ) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.fallbackRole, fallbackRole) ||
                other.fallbackRole == fallbackRole) &&
            (identical(other.descriptionTemplate, descriptionTemplate) ||
                other.descriptionTemplate == descriptionTemplate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    role,
    const DeepCollectionEquality().hash(_preferredTags),
    required,
    fallbackRole,
    descriptionTemplate,
  );

  /// Create a copy of LocationRequirement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationRequirementImplCopyWith<_$LocationRequirementImpl> get copyWith =>
      __$$LocationRequirementImplCopyWithImpl<_$LocationRequirementImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationRequirementImplToJson(this);
  }
}

abstract class _LocationRequirement implements LocationRequirement {
  const factory _LocationRequirement({
    required final String id,
    required final StoryRole role,
    final List<String> preferredTags,
    final bool required,
    final StoryRole? fallbackRole,
    final String descriptionTemplate,
  }) = _$LocationRequirementImpl;

  factory _LocationRequirement.fromJson(Map<String, dynamic> json) =
      _$LocationRequirementImpl.fromJson;

  /// Unique identifier for this location within the case
  @override
  String get id;

  /// Primary story role this location should fulfill
  @override
  StoryRole get role;

  /// Preferred OSM tags, e.g., ["amenity=cafe", "amenity=restaurant"]
  @override
  List<String> get preferredTags;

  /// Whether this location is required for the case to be playable
  @override
  bool get required;

  /// Alternative role to try if primary role has no matches
  @override
  StoryRole? get fallbackRole;

  /// Template for describing this location, e.g., "a quiet café where..."
  @override
  String get descriptionTemplate;

  /// Create a copy of LocationRequirement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationRequirementImplCopyWith<_$LocationRequirementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
