// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Character _$CharacterFromJson(Map<String, dynamic> json) {
  return _Character.fromJson(json);
}

/// @nodoc
mixin _$Character {
  /// Unique identifier for this character
  String get id => throw _privateConstructorUsedError;

  /// Character's display name
  String get name => throw _privateConstructorUsedError;

  /// Character's role/occupation, e.g., "bartender", "witness"
  String get role => throw _privateConstructorUsedError;

  /// ID of the LocationRequirement where this character is found
  String get locationId => throw _privateConstructorUsedError;

  /// Physical/personality description shown to the player
  String get description => throw _privateConstructorUsedError;

  /// Dialogue shown when first meeting the character
  String get initialDialogue => throw _privateConstructorUsedError;

  /// Additional dialogue unlocked by discovering specific clues.
  /// Maps clue ID → dialogue text.
  Map<String, String> get conditionalDialogue =>
      throw _privateConstructorUsedError;

  /// Serializes this Character to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterCopyWith<Character> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) then) =
      _$CharacterCopyWithImpl<$Res, Character>;
  @useResult
  $Res call({
    String id,
    String name,
    String role,
    String locationId,
    String description,
    String initialDialogue,
    Map<String, String> conditionalDialogue,
  });
}

/// @nodoc
class _$CharacterCopyWithImpl<$Res, $Val extends Character>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? role = null,
    Object? locationId = null,
    Object? description = null,
    Object? initialDialogue = null,
    Object? conditionalDialogue = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            locationId: null == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            initialDialogue: null == initialDialogue
                ? _value.initialDialogue
                : initialDialogue // ignore: cast_nullable_to_non_nullable
                      as String,
            conditionalDialogue: null == conditionalDialogue
                ? _value.conditionalDialogue
                : conditionalDialogue // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CharacterImplCopyWith<$Res>
    implements $CharacterCopyWith<$Res> {
  factory _$$CharacterImplCopyWith(
    _$CharacterImpl value,
    $Res Function(_$CharacterImpl) then,
  ) = __$$CharacterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String role,
    String locationId,
    String description,
    String initialDialogue,
    Map<String, String> conditionalDialogue,
  });
}

/// @nodoc
class __$$CharacterImplCopyWithImpl<$Res>
    extends _$CharacterCopyWithImpl<$Res, _$CharacterImpl>
    implements _$$CharacterImplCopyWith<$Res> {
  __$$CharacterImplCopyWithImpl(
    _$CharacterImpl _value,
    $Res Function(_$CharacterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? role = null,
    Object? locationId = null,
    Object? description = null,
    Object? initialDialogue = null,
    Object? conditionalDialogue = null,
  }) {
    return _then(
      _$CharacterImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        locationId: null == locationId
            ? _value.locationId
            : locationId // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        initialDialogue: null == initialDialogue
            ? _value.initialDialogue
            : initialDialogue // ignore: cast_nullable_to_non_nullable
                  as String,
        conditionalDialogue: null == conditionalDialogue
            ? _value._conditionalDialogue
            : conditionalDialogue // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterImpl implements _Character {
  const _$CharacterImpl({
    required this.id,
    required this.name,
    required this.role,
    required this.locationId,
    required this.description,
    required this.initialDialogue,
    final Map<String, String> conditionalDialogue = const {},
  }) : _conditionalDialogue = conditionalDialogue;

  factory _$CharacterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterImplFromJson(json);

  /// Unique identifier for this character
  @override
  final String id;

  /// Character's display name
  @override
  final String name;

  /// Character's role/occupation, e.g., "bartender", "witness"
  @override
  final String role;

  /// ID of the LocationRequirement where this character is found
  @override
  final String locationId;

  /// Physical/personality description shown to the player
  @override
  final String description;

  /// Dialogue shown when first meeting the character
  @override
  final String initialDialogue;

  /// Additional dialogue unlocked by discovering specific clues.
  /// Maps clue ID → dialogue text.
  final Map<String, String> _conditionalDialogue;

  /// Additional dialogue unlocked by discovering specific clues.
  /// Maps clue ID → dialogue text.
  @override
  @JsonKey()
  Map<String, String> get conditionalDialogue {
    if (_conditionalDialogue is EqualUnmodifiableMapView)
      return _conditionalDialogue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conditionalDialogue);
  }

  @override
  String toString() {
    return 'Character(id: $id, name: $name, role: $role, locationId: $locationId, description: $description, initialDialogue: $initialDialogue, conditionalDialogue: $conditionalDialogue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.initialDialogue, initialDialogue) ||
                other.initialDialogue == initialDialogue) &&
            const DeepCollectionEquality().equals(
              other._conditionalDialogue,
              _conditionalDialogue,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    role,
    locationId,
    description,
    initialDialogue,
    const DeepCollectionEquality().hash(_conditionalDialogue),
  );

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      __$$CharacterImplCopyWithImpl<_$CharacterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterImplToJson(this);
  }
}

abstract class _Character implements Character {
  const factory _Character({
    required final String id,
    required final String name,
    required final String role,
    required final String locationId,
    required final String description,
    required final String initialDialogue,
    final Map<String, String> conditionalDialogue,
  }) = _$CharacterImpl;

  factory _Character.fromJson(Map<String, dynamic> json) =
      _$CharacterImpl.fromJson;

  /// Unique identifier for this character
  @override
  String get id;

  /// Character's display name
  @override
  String get name;

  /// Character's role/occupation, e.g., "bartender", "witness"
  @override
  String get role;

  /// ID of the LocationRequirement where this character is found
  @override
  String get locationId;

  /// Physical/personality description shown to the player
  @override
  String get description;

  /// Dialogue shown when first meeting the character
  @override
  String get initialDialogue;

  /// Additional dialogue unlocked by discovering specific clues.
  /// Maps clue ID → dialogue text.
  @override
  Map<String, String> get conditionalDialogue;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
