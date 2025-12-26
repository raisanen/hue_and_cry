// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return _GameState.fromJson(json);
}

/// @nodoc
mixin _$GameState {
  /// ID of the case being played
  String get caseId => throw _privateConstructorUsedError;

  /// Current game phase
  GamePhase get phase => throw _privateConstructorUsedError;

  /// IDs of locations the player has visited
  Set<String> get visitedLocations => throw _privateConstructorUsedError;

  /// IDs of clues the player has discovered
  Set<String> get discoveredClues => throw _privateConstructorUsedError;

  /// IDs of locations revealed by clues (initially hidden)
  Set<String> get unlockedLocations => throw _privateConstructorUsedError;

  /// Order in which locations were visited (for scoring)
  List<String> get visitOrder => throw _privateConstructorUsedError;

  /// When the game was started
  DateTime get startedAt => throw _privateConstructorUsedError;

  /// When the case was solved (null if still in progress)
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    String caseId,
    GamePhase phase,
    Set<String> visitedLocations,
    Set<String> discoveredClues,
    Set<String> unlockedLocations,
    List<String> visitOrder,
    DateTime startedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? phase = null,
    Object? visitedLocations = null,
    Object? discoveredClues = null,
    Object? unlockedLocations = null,
    Object? visitOrder = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            caseId: null == caseId
                ? _value.caseId
                : caseId // ignore: cast_nullable_to_non_nullable
                      as String,
            phase: null == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                      as GamePhase,
            visitedLocations: null == visitedLocations
                ? _value.visitedLocations
                : visitedLocations // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            discoveredClues: null == discoveredClues
                ? _value.discoveredClues
                : discoveredClues // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            unlockedLocations: null == unlockedLocations
                ? _value.unlockedLocations
                : unlockedLocations // ignore: cast_nullable_to_non_nullable
                      as Set<String>,
            visitOrder: null == visitOrder
                ? _value.visitOrder
                : visitOrder // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String caseId,
    GamePhase phase,
    Set<String> visitedLocations,
    Set<String> discoveredClues,
    Set<String> unlockedLocations,
    List<String> visitOrder,
    DateTime startedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caseId = null,
    Object? phase = null,
    Object? visitedLocations = null,
    Object? discoveredClues = null,
    Object? unlockedLocations = null,
    Object? visitOrder = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$GameStateImpl(
        caseId: null == caseId
            ? _value.caseId
            : caseId // ignore: cast_nullable_to_non_nullable
                  as String,
        phase: null == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as GamePhase,
        visitedLocations: null == visitedLocations
            ? _value._visitedLocations
            : visitedLocations // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        discoveredClues: null == discoveredClues
            ? _value._discoveredClues
            : discoveredClues // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        unlockedLocations: null == unlockedLocations
            ? _value._unlockedLocations
            : unlockedLocations // ignore: cast_nullable_to_non_nullable
                  as Set<String>,
        visitOrder: null == visitOrder
            ? _value._visitOrder
            : visitOrder // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateImpl implements _GameState {
  const _$GameStateImpl({
    required this.caseId,
    this.phase = GamePhase.setup,
    final Set<String> visitedLocations = const {},
    final Set<String> discoveredClues = const {},
    final Set<String> unlockedLocations = const {},
    final List<String> visitOrder = const [],
    required this.startedAt,
    this.completedAt,
  }) : _visitedLocations = visitedLocations,
       _discoveredClues = discoveredClues,
       _unlockedLocations = unlockedLocations,
       _visitOrder = visitOrder;

  factory _$GameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateImplFromJson(json);

  /// ID of the case being played
  @override
  final String caseId;

  /// Current game phase
  @override
  @JsonKey()
  final GamePhase phase;

  /// IDs of locations the player has visited
  final Set<String> _visitedLocations;

  /// IDs of locations the player has visited
  @override
  @JsonKey()
  Set<String> get visitedLocations {
    if (_visitedLocations is EqualUnmodifiableSetView) return _visitedLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_visitedLocations);
  }

  /// IDs of clues the player has discovered
  final Set<String> _discoveredClues;

  /// IDs of clues the player has discovered
  @override
  @JsonKey()
  Set<String> get discoveredClues {
    if (_discoveredClues is EqualUnmodifiableSetView) return _discoveredClues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_discoveredClues);
  }

  /// IDs of locations revealed by clues (initially hidden)
  final Set<String> _unlockedLocations;

  /// IDs of locations revealed by clues (initially hidden)
  @override
  @JsonKey()
  Set<String> get unlockedLocations {
    if (_unlockedLocations is EqualUnmodifiableSetView)
      return _unlockedLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_unlockedLocations);
  }

  /// Order in which locations were visited (for scoring)
  final List<String> _visitOrder;

  /// Order in which locations were visited (for scoring)
  @override
  @JsonKey()
  List<String> get visitOrder {
    if (_visitOrder is EqualUnmodifiableListView) return _visitOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_visitOrder);
  }

  /// When the game was started
  @override
  final DateTime startedAt;

  /// When the case was solved (null if still in progress)
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'GameState(caseId: $caseId, phase: $phase, visitedLocations: $visitedLocations, discoveredClues: $discoveredClues, unlockedLocations: $unlockedLocations, visitOrder: $visitOrder, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.caseId, caseId) || other.caseId == caseId) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            const DeepCollectionEquality().equals(
              other._visitedLocations,
              _visitedLocations,
            ) &&
            const DeepCollectionEquality().equals(
              other._discoveredClues,
              _discoveredClues,
            ) &&
            const DeepCollectionEquality().equals(
              other._unlockedLocations,
              _unlockedLocations,
            ) &&
            const DeepCollectionEquality().equals(
              other._visitOrder,
              _visitOrder,
            ) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    caseId,
    phase,
    const DeepCollectionEquality().hash(_visitedLocations),
    const DeepCollectionEquality().hash(_discoveredClues),
    const DeepCollectionEquality().hash(_unlockedLocations),
    const DeepCollectionEquality().hash(_visitOrder),
    startedAt,
    completedAt,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateImplToJson(this);
  }
}

abstract class _GameState implements GameState {
  const factory _GameState({
    required final String caseId,
    final GamePhase phase,
    final Set<String> visitedLocations,
    final Set<String> discoveredClues,
    final Set<String> unlockedLocations,
    final List<String> visitOrder,
    required final DateTime startedAt,
    final DateTime? completedAt,
  }) = _$GameStateImpl;

  factory _GameState.fromJson(Map<String, dynamic> json) =
      _$GameStateImpl.fromJson;

  /// ID of the case being played
  @override
  String get caseId;

  /// Current game phase
  @override
  GamePhase get phase;

  /// IDs of locations the player has visited
  @override
  Set<String> get visitedLocations;

  /// IDs of clues the player has discovered
  @override
  Set<String> get discoveredClues;

  /// IDs of locations revealed by clues (initially hidden)
  @override
  Set<String> get unlockedLocations;

  /// Order in which locations were visited (for scoring)
  @override
  List<String> get visitOrder;

  /// When the game was started
  @override
  DateTime get startedAt;

  /// When the case was solved (null if still in progress)
  @override
  DateTime? get completedAt;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
