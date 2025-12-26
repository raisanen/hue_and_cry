// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'solution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Solution _$SolutionFromJson(Map<String, dynamic> json) {
  return _Solution.fromJson(json);
}

/// @nodoc
mixin _$Solution {
  /// Character ID of the guilty party
  String get perpetratorId => throw _privateConstructorUsedError;

  /// The reason/motivation for the crime
  String get motive => throw _privateConstructorUsedError;

  /// How the crime was committed
  String get method => throw _privateConstructorUsedError;

  /// IDs of clues that prove the solution
  List<String> get keyEvidence => throw _privateConstructorUsedError;

  /// The optimal sequence of location visits (for scoring)
  List<String> get optimalPath => throw _privateConstructorUsedError;

  /// Serializes this Solution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Solution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SolutionCopyWith<Solution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SolutionCopyWith<$Res> {
  factory $SolutionCopyWith(Solution value, $Res Function(Solution) then) =
      _$SolutionCopyWithImpl<$Res, Solution>;
  @useResult
  $Res call({
    String perpetratorId,
    String motive,
    String method,
    List<String> keyEvidence,
    List<String> optimalPath,
  });
}

/// @nodoc
class _$SolutionCopyWithImpl<$Res, $Val extends Solution>
    implements $SolutionCopyWith<$Res> {
  _$SolutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Solution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? perpetratorId = null,
    Object? motive = null,
    Object? method = null,
    Object? keyEvidence = null,
    Object? optimalPath = null,
  }) {
    return _then(
      _value.copyWith(
            perpetratorId: null == perpetratorId
                ? _value.perpetratorId
                : perpetratorId // ignore: cast_nullable_to_non_nullable
                      as String,
            motive: null == motive
                ? _value.motive
                : motive // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String,
            keyEvidence: null == keyEvidence
                ? _value.keyEvidence
                : keyEvidence // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            optimalPath: null == optimalPath
                ? _value.optimalPath
                : optimalPath // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SolutionImplCopyWith<$Res>
    implements $SolutionCopyWith<$Res> {
  factory _$$SolutionImplCopyWith(
    _$SolutionImpl value,
    $Res Function(_$SolutionImpl) then,
  ) = __$$SolutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String perpetratorId,
    String motive,
    String method,
    List<String> keyEvidence,
    List<String> optimalPath,
  });
}

/// @nodoc
class __$$SolutionImplCopyWithImpl<$Res>
    extends _$SolutionCopyWithImpl<$Res, _$SolutionImpl>
    implements _$$SolutionImplCopyWith<$Res> {
  __$$SolutionImplCopyWithImpl(
    _$SolutionImpl _value,
    $Res Function(_$SolutionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Solution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? perpetratorId = null,
    Object? motive = null,
    Object? method = null,
    Object? keyEvidence = null,
    Object? optimalPath = null,
  }) {
    return _then(
      _$SolutionImpl(
        perpetratorId: null == perpetratorId
            ? _value.perpetratorId
            : perpetratorId // ignore: cast_nullable_to_non_nullable
                  as String,
        motive: null == motive
            ? _value.motive
            : motive // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        keyEvidence: null == keyEvidence
            ? _value._keyEvidence
            : keyEvidence // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        optimalPath: null == optimalPath
            ? _value._optimalPath
            : optimalPath // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SolutionImpl implements _Solution {
  const _$SolutionImpl({
    required this.perpetratorId,
    required this.motive,
    required this.method,
    final List<String> keyEvidence = const [],
    final List<String> optimalPath = const [],
  }) : _keyEvidence = keyEvidence,
       _optimalPath = optimalPath;

  factory _$SolutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SolutionImplFromJson(json);

  /// Character ID of the guilty party
  @override
  final String perpetratorId;

  /// The reason/motivation for the crime
  @override
  final String motive;

  /// How the crime was committed
  @override
  final String method;

  /// IDs of clues that prove the solution
  final List<String> _keyEvidence;

  /// IDs of clues that prove the solution
  @override
  @JsonKey()
  List<String> get keyEvidence {
    if (_keyEvidence is EqualUnmodifiableListView) return _keyEvidence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyEvidence);
  }

  /// The optimal sequence of location visits (for scoring)
  final List<String> _optimalPath;

  /// The optimal sequence of location visits (for scoring)
  @override
  @JsonKey()
  List<String> get optimalPath {
    if (_optimalPath is EqualUnmodifiableListView) return _optimalPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_optimalPath);
  }

  @override
  String toString() {
    return 'Solution(perpetratorId: $perpetratorId, motive: $motive, method: $method, keyEvidence: $keyEvidence, optimalPath: $optimalPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SolutionImpl &&
            (identical(other.perpetratorId, perpetratorId) ||
                other.perpetratorId == perpetratorId) &&
            (identical(other.motive, motive) || other.motive == motive) &&
            (identical(other.method, method) || other.method == method) &&
            const DeepCollectionEquality().equals(
              other._keyEvidence,
              _keyEvidence,
            ) &&
            const DeepCollectionEquality().equals(
              other._optimalPath,
              _optimalPath,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    perpetratorId,
    motive,
    method,
    const DeepCollectionEquality().hash(_keyEvidence),
    const DeepCollectionEquality().hash(_optimalPath),
  );

  /// Create a copy of Solution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SolutionImplCopyWith<_$SolutionImpl> get copyWith =>
      __$$SolutionImplCopyWithImpl<_$SolutionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SolutionImplToJson(this);
  }
}

abstract class _Solution implements Solution {
  const factory _Solution({
    required final String perpetratorId,
    required final String motive,
    required final String method,
    final List<String> keyEvidence,
    final List<String> optimalPath,
  }) = _$SolutionImpl;

  factory _Solution.fromJson(Map<String, dynamic> json) =
      _$SolutionImpl.fromJson;

  /// Character ID of the guilty party
  @override
  String get perpetratorId;

  /// The reason/motivation for the crime
  @override
  String get motive;

  /// How the crime was committed
  @override
  String get method;

  /// IDs of clues that prove the solution
  @override
  List<String> get keyEvidence;

  /// The optimal sequence of location visits (for scoring)
  @override
  List<String> get optimalPath;

  /// Create a copy of Solution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SolutionImplCopyWith<_$SolutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
