// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Clue _$ClueFromJson(Map<String, dynamic> json) {
  return _Clue.fromJson(json);
}

/// @nodoc
mixin _$Clue {
  /// Unique identifier for this clue
  String get id => throw _privateConstructorUsedError;

  /// The category of this clue
  ClueType get type => throw _privateConstructorUsedError;

  /// ID of the LocationRequirement where this clue is found
  String get locationId => throw _privateConstructorUsedError;

  /// Short title for notebook display
  String get title => throw _privateConstructorUsedError;

  /// Text shown when the clue is first discovered
  String get discoveryText => throw _privateConstructorUsedError;

  /// Condensed summary shown in the notebook
  String get notebookSummary => throw _privateConstructorUsedError;

  /// IDs of clues that must be discovered before this one appears
  List<String> get prerequisites => throw _privateConstructorUsedError;

  /// Location IDs that become visible after discovering this clue
  List<String> get reveals => throw _privateConstructorUsedError;

  /// If this clue comes from an NPC, their character ID
  String? get characterId => throw _privateConstructorUsedError;

  /// Whether this clue is required to solve the case
  bool get isEssential => throw _privateConstructorUsedError;

  /// Whether this clue is a deliberate misdirection
  bool get isRedHerring => throw _privateConstructorUsedError;

  /// Serializes this Clue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Clue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClueCopyWith<Clue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClueCopyWith<$Res> {
  factory $ClueCopyWith(Clue value, $Res Function(Clue) then) =
      _$ClueCopyWithImpl<$Res, Clue>;
  @useResult
  $Res call({
    String id,
    ClueType type,
    String locationId,
    String title,
    String discoveryText,
    String notebookSummary,
    List<String> prerequisites,
    List<String> reveals,
    String? characterId,
    bool isEssential,
    bool isRedHerring,
  });
}

/// @nodoc
class _$ClueCopyWithImpl<$Res, $Val extends Clue>
    implements $ClueCopyWith<$Res> {
  _$ClueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Clue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? locationId = null,
    Object? title = null,
    Object? discoveryText = null,
    Object? notebookSummary = null,
    Object? prerequisites = null,
    Object? reveals = null,
    Object? characterId = freezed,
    Object? isEssential = null,
    Object? isRedHerring = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ClueType,
            locationId: null == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            discoveryText: null == discoveryText
                ? _value.discoveryText
                : discoveryText // ignore: cast_nullable_to_non_nullable
                      as String,
            notebookSummary: null == notebookSummary
                ? _value.notebookSummary
                : notebookSummary // ignore: cast_nullable_to_non_nullable
                      as String,
            prerequisites: null == prerequisites
                ? _value.prerequisites
                : prerequisites // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            reveals: null == reveals
                ? _value.reveals
                : reveals // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            characterId: freezed == characterId
                ? _value.characterId
                : characterId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isEssential: null == isEssential
                ? _value.isEssential
                : isEssential // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRedHerring: null == isRedHerring
                ? _value.isRedHerring
                : isRedHerring // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClueImplCopyWith<$Res> implements $ClueCopyWith<$Res> {
  factory _$$ClueImplCopyWith(
    _$ClueImpl value,
    $Res Function(_$ClueImpl) then,
  ) = __$$ClueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    ClueType type,
    String locationId,
    String title,
    String discoveryText,
    String notebookSummary,
    List<String> prerequisites,
    List<String> reveals,
    String? characterId,
    bool isEssential,
    bool isRedHerring,
  });
}

/// @nodoc
class __$$ClueImplCopyWithImpl<$Res>
    extends _$ClueCopyWithImpl<$Res, _$ClueImpl>
    implements _$$ClueImplCopyWith<$Res> {
  __$$ClueImplCopyWithImpl(_$ClueImpl _value, $Res Function(_$ClueImpl) _then)
    : super(_value, _then);

  /// Create a copy of Clue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? locationId = null,
    Object? title = null,
    Object? discoveryText = null,
    Object? notebookSummary = null,
    Object? prerequisites = null,
    Object? reveals = null,
    Object? characterId = freezed,
    Object? isEssential = null,
    Object? isRedHerring = null,
  }) {
    return _then(
      _$ClueImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ClueType,
        locationId: null == locationId
            ? _value.locationId
            : locationId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        discoveryText: null == discoveryText
            ? _value.discoveryText
            : discoveryText // ignore: cast_nullable_to_non_nullable
                  as String,
        notebookSummary: null == notebookSummary
            ? _value.notebookSummary
            : notebookSummary // ignore: cast_nullable_to_non_nullable
                  as String,
        prerequisites: null == prerequisites
            ? _value._prerequisites
            : prerequisites // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        reveals: null == reveals
            ? _value._reveals
            : reveals // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        characterId: freezed == characterId
            ? _value.characterId
            : characterId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isEssential: null == isEssential
            ? _value.isEssential
            : isEssential // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRedHerring: null == isRedHerring
            ? _value.isRedHerring
            : isRedHerring // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClueImpl implements _Clue {
  const _$ClueImpl({
    required this.id,
    required this.type,
    required this.locationId,
    required this.title,
    required this.discoveryText,
    required this.notebookSummary,
    final List<String> prerequisites = const [],
    final List<String> reveals = const [],
    this.characterId,
    this.isEssential = false,
    this.isRedHerring = false,
  }) : _prerequisites = prerequisites,
       _reveals = reveals;

  factory _$ClueImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClueImplFromJson(json);

  /// Unique identifier for this clue
  @override
  final String id;

  /// The category of this clue
  @override
  final ClueType type;

  /// ID of the LocationRequirement where this clue is found
  @override
  final String locationId;

  /// Short title for notebook display
  @override
  final String title;

  /// Text shown when the clue is first discovered
  @override
  final String discoveryText;

  /// Condensed summary shown in the notebook
  @override
  final String notebookSummary;

  /// IDs of clues that must be discovered before this one appears
  final List<String> _prerequisites;

  /// IDs of clues that must be discovered before this one appears
  @override
  @JsonKey()
  List<String> get prerequisites {
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prerequisites);
  }

  /// Location IDs that become visible after discovering this clue
  final List<String> _reveals;

  /// Location IDs that become visible after discovering this clue
  @override
  @JsonKey()
  List<String> get reveals {
    if (_reveals is EqualUnmodifiableListView) return _reveals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reveals);
  }

  /// If this clue comes from an NPC, their character ID
  @override
  final String? characterId;

  /// Whether this clue is required to solve the case
  @override
  @JsonKey()
  final bool isEssential;

  /// Whether this clue is a deliberate misdirection
  @override
  @JsonKey()
  final bool isRedHerring;

  @override
  String toString() {
    return 'Clue(id: $id, type: $type, locationId: $locationId, title: $title, discoveryText: $discoveryText, notebookSummary: $notebookSummary, prerequisites: $prerequisites, reveals: $reveals, characterId: $characterId, isEssential: $isEssential, isRedHerring: $isRedHerring)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.discoveryText, discoveryText) ||
                other.discoveryText == discoveryText) &&
            (identical(other.notebookSummary, notebookSummary) ||
                other.notebookSummary == notebookSummary) &&
            const DeepCollectionEquality().equals(
              other._prerequisites,
              _prerequisites,
            ) &&
            const DeepCollectionEquality().equals(other._reveals, _reveals) &&
            (identical(other.characterId, characterId) ||
                other.characterId == characterId) &&
            (identical(other.isEssential, isEssential) ||
                other.isEssential == isEssential) &&
            (identical(other.isRedHerring, isRedHerring) ||
                other.isRedHerring == isRedHerring));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    locationId,
    title,
    discoveryText,
    notebookSummary,
    const DeepCollectionEquality().hash(_prerequisites),
    const DeepCollectionEquality().hash(_reveals),
    characterId,
    isEssential,
    isRedHerring,
  );

  /// Create a copy of Clue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClueImplCopyWith<_$ClueImpl> get copyWith =>
      __$$ClueImplCopyWithImpl<_$ClueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClueImplToJson(this);
  }
}

abstract class _Clue implements Clue {
  const factory _Clue({
    required final String id,
    required final ClueType type,
    required final String locationId,
    required final String title,
    required final String discoveryText,
    required final String notebookSummary,
    final List<String> prerequisites,
    final List<String> reveals,
    final String? characterId,
    final bool isEssential,
    final bool isRedHerring,
  }) = _$ClueImpl;

  factory _Clue.fromJson(Map<String, dynamic> json) = _$ClueImpl.fromJson;

  /// Unique identifier for this clue
  @override
  String get id;

  /// The category of this clue
  @override
  ClueType get type;

  /// ID of the LocationRequirement where this clue is found
  @override
  String get locationId;

  /// Short title for notebook display
  @override
  String get title;

  /// Text shown when the clue is first discovered
  @override
  String get discoveryText;

  /// Condensed summary shown in the notebook
  @override
  String get notebookSummary;

  /// IDs of clues that must be discovered before this one appears
  @override
  List<String> get prerequisites;

  /// Location IDs that become visible after discovering this clue
  @override
  List<String> get reveals;

  /// If this clue comes from an NPC, their character ID
  @override
  String? get characterId;

  /// Whether this clue is required to solve the case
  @override
  bool get isEssential;

  /// Whether this clue is a deliberate misdirection
  @override
  bool get isRedHerring;

  /// Create a copy of Clue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClueImplCopyWith<_$ClueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
