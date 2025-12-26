// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'case_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CaseTemplate _$CaseTemplateFromJson(Map<String, dynamic> json) {
  return _CaseTemplate.fromJson(json);
}

/// @nodoc
mixin _$CaseTemplate {
  /// Unique identifier for this case
  String get id => throw _privateConstructorUsedError;

  /// Main title, e.g., "The Vanishing Violinist"
  String get title => throw _privateConstructorUsedError;

  /// Subtitle/tagline for the case
  String get subtitle => throw _privateConstructorUsedError;

  /// Short teaser text for the case listing (newspaper prose style)
  String get teaser => throw _privateConstructorUsedError;

  /// Opening briefing text presented to the player
  String get briefing => throw _privateConstructorUsedError;

  /// Location requirements mapped by their IDs
  Map<String, LocationRequirement> get locations =>
      throw _privateConstructorUsedError;

  /// NPCs in this case
  List<Character> get characters => throw _privateConstructorUsedError;

  /// All clues available in this case
  List<Clue> get clues => throw _privateConstructorUsedError;

  /// The correct solution
  Solution get solution => throw _privateConstructorUsedError;

  /// Target number of location visits for a perfect score
  int get parVisits => throw _privateConstructorUsedError;

  /// Estimated play time in minutes
  int get estimatedMinutes => throw _privateConstructorUsedError;

  /// Difficulty rating (1-5)
  int get difficulty => throw _privateConstructorUsedError;

  /// Serializes this CaseTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseTemplateCopyWith<CaseTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseTemplateCopyWith<$Res> {
  factory $CaseTemplateCopyWith(
    CaseTemplate value,
    $Res Function(CaseTemplate) then,
  ) = _$CaseTemplateCopyWithImpl<$Res, CaseTemplate>;
  @useResult
  $Res call({
    String id,
    String title,
    String subtitle,
    String teaser,
    String briefing,
    Map<String, LocationRequirement> locations,
    List<Character> characters,
    List<Clue> clues,
    Solution solution,
    int parVisits,
    int estimatedMinutes,
    int difficulty,
  });

  $SolutionCopyWith<$Res> get solution;
}

/// @nodoc
class _$CaseTemplateCopyWithImpl<$Res, $Val extends CaseTemplate>
    implements $CaseTemplateCopyWith<$Res> {
  _$CaseTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? teaser = null,
    Object? briefing = null,
    Object? locations = null,
    Object? characters = null,
    Object? clues = null,
    Object? solution = null,
    Object? parVisits = null,
    Object? estimatedMinutes = null,
    Object? difficulty = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            subtitle: null == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String,
            teaser: null == teaser
                ? _value.teaser
                : teaser // ignore: cast_nullable_to_non_nullable
                      as String,
            briefing: null == briefing
                ? _value.briefing
                : briefing // ignore: cast_nullable_to_non_nullable
                      as String,
            locations: null == locations
                ? _value.locations
                : locations // ignore: cast_nullable_to_non_nullable
                      as Map<String, LocationRequirement>,
            characters: null == characters
                ? _value.characters
                : characters // ignore: cast_nullable_to_non_nullable
                      as List<Character>,
            clues: null == clues
                ? _value.clues
                : clues // ignore: cast_nullable_to_non_nullable
                      as List<Clue>,
            solution: null == solution
                ? _value.solution
                : solution // ignore: cast_nullable_to_non_nullable
                      as Solution,
            parVisits: null == parVisits
                ? _value.parVisits
                : parVisits // ignore: cast_nullable_to_non_nullable
                      as int,
            estimatedMinutes: null == estimatedMinutes
                ? _value.estimatedMinutes
                : estimatedMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of CaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SolutionCopyWith<$Res> get solution {
    return $SolutionCopyWith<$Res>(_value.solution, (value) {
      return _then(_value.copyWith(solution: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CaseTemplateImplCopyWith<$Res>
    implements $CaseTemplateCopyWith<$Res> {
  factory _$$CaseTemplateImplCopyWith(
    _$CaseTemplateImpl value,
    $Res Function(_$CaseTemplateImpl) then,
  ) = __$$CaseTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String subtitle,
    String teaser,
    String briefing,
    Map<String, LocationRequirement> locations,
    List<Character> characters,
    List<Clue> clues,
    Solution solution,
    int parVisits,
    int estimatedMinutes,
    int difficulty,
  });

  @override
  $SolutionCopyWith<$Res> get solution;
}

/// @nodoc
class __$$CaseTemplateImplCopyWithImpl<$Res>
    extends _$CaseTemplateCopyWithImpl<$Res, _$CaseTemplateImpl>
    implements _$$CaseTemplateImplCopyWith<$Res> {
  __$$CaseTemplateImplCopyWithImpl(
    _$CaseTemplateImpl _value,
    $Res Function(_$CaseTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? teaser = null,
    Object? briefing = null,
    Object? locations = null,
    Object? characters = null,
    Object? clues = null,
    Object? solution = null,
    Object? parVisits = null,
    Object? estimatedMinutes = null,
    Object? difficulty = null,
  }) {
    return _then(
      _$CaseTemplateImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: null == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String,
        teaser: null == teaser
            ? _value.teaser
            : teaser // ignore: cast_nullable_to_non_nullable
                  as String,
        briefing: null == briefing
            ? _value.briefing
            : briefing // ignore: cast_nullable_to_non_nullable
                  as String,
        locations: null == locations
            ? _value._locations
            : locations // ignore: cast_nullable_to_non_nullable
                  as Map<String, LocationRequirement>,
        characters: null == characters
            ? _value._characters
            : characters // ignore: cast_nullable_to_non_nullable
                  as List<Character>,
        clues: null == clues
            ? _value._clues
            : clues // ignore: cast_nullable_to_non_nullable
                  as List<Clue>,
        solution: null == solution
            ? _value.solution
            : solution // ignore: cast_nullable_to_non_nullable
                  as Solution,
        parVisits: null == parVisits
            ? _value.parVisits
            : parVisits // ignore: cast_nullable_to_non_nullable
                  as int,
        estimatedMinutes: null == estimatedMinutes
            ? _value.estimatedMinutes
            : estimatedMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaseTemplateImpl implements _CaseTemplate {
  const _$CaseTemplateImpl({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.teaser,
    required this.briefing,
    final Map<String, LocationRequirement> locations = const {},
    final List<Character> characters = const [],
    final List<Clue> clues = const [],
    required this.solution,
    this.parVisits = 5,
    this.estimatedMinutes = 60,
    this.difficulty = 3,
  }) : _locations = locations,
       _characters = characters,
       _clues = clues;

  factory _$CaseTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaseTemplateImplFromJson(json);

  /// Unique identifier for this case
  @override
  final String id;

  /// Main title, e.g., "The Vanishing Violinist"
  @override
  final String title;

  /// Subtitle/tagline for the case
  @override
  final String subtitle;

  /// Short teaser text for the case listing (newspaper prose style)
  @override
  final String teaser;

  /// Opening briefing text presented to the player
  @override
  final String briefing;

  /// Location requirements mapped by their IDs
  final Map<String, LocationRequirement> _locations;

  /// Location requirements mapped by their IDs
  @override
  @JsonKey()
  Map<String, LocationRequirement> get locations {
    if (_locations is EqualUnmodifiableMapView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_locations);
  }

  /// NPCs in this case
  final List<Character> _characters;

  /// NPCs in this case
  @override
  @JsonKey()
  List<Character> get characters {
    if (_characters is EqualUnmodifiableListView) return _characters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_characters);
  }

  /// All clues available in this case
  final List<Clue> _clues;

  /// All clues available in this case
  @override
  @JsonKey()
  List<Clue> get clues {
    if (_clues is EqualUnmodifiableListView) return _clues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clues);
  }

  /// The correct solution
  @override
  final Solution solution;

  /// Target number of location visits for a perfect score
  @override
  @JsonKey()
  final int parVisits;

  /// Estimated play time in minutes
  @override
  @JsonKey()
  final int estimatedMinutes;

  /// Difficulty rating (1-5)
  @override
  @JsonKey()
  final int difficulty;

  @override
  String toString() {
    return 'CaseTemplate(id: $id, title: $title, subtitle: $subtitle, teaser: $teaser, briefing: $briefing, locations: $locations, characters: $characters, clues: $clues, solution: $solution, parVisits: $parVisits, estimatedMinutes: $estimatedMinutes, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.teaser, teaser) || other.teaser == teaser) &&
            (identical(other.briefing, briefing) ||
                other.briefing == briefing) &&
            const DeepCollectionEquality().equals(
              other._locations,
              _locations,
            ) &&
            const DeepCollectionEquality().equals(
              other._characters,
              _characters,
            ) &&
            const DeepCollectionEquality().equals(other._clues, _clues) &&
            (identical(other.solution, solution) ||
                other.solution == solution) &&
            (identical(other.parVisits, parVisits) ||
                other.parVisits == parVisits) &&
            (identical(other.estimatedMinutes, estimatedMinutes) ||
                other.estimatedMinutes == estimatedMinutes) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    subtitle,
    teaser,
    briefing,
    const DeepCollectionEquality().hash(_locations),
    const DeepCollectionEquality().hash(_characters),
    const DeepCollectionEquality().hash(_clues),
    solution,
    parVisits,
    estimatedMinutes,
    difficulty,
  );

  /// Create a copy of CaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseTemplateImplCopyWith<_$CaseTemplateImpl> get copyWith =>
      __$$CaseTemplateImplCopyWithImpl<_$CaseTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CaseTemplateImplToJson(this);
  }
}

abstract class _CaseTemplate implements CaseTemplate {
  const factory _CaseTemplate({
    required final String id,
    required final String title,
    required final String subtitle,
    required final String teaser,
    required final String briefing,
    final Map<String, LocationRequirement> locations,
    final List<Character> characters,
    final List<Clue> clues,
    required final Solution solution,
    final int parVisits,
    final int estimatedMinutes,
    final int difficulty,
  }) = _$CaseTemplateImpl;

  factory _CaseTemplate.fromJson(Map<String, dynamic> json) =
      _$CaseTemplateImpl.fromJson;

  /// Unique identifier for this case
  @override
  String get id;

  /// Main title, e.g., "The Vanishing Violinist"
  @override
  String get title;

  /// Subtitle/tagline for the case
  @override
  String get subtitle;

  /// Short teaser text for the case listing (newspaper prose style)
  @override
  String get teaser;

  /// Opening briefing text presented to the player
  @override
  String get briefing;

  /// Location requirements mapped by their IDs
  @override
  Map<String, LocationRequirement> get locations;

  /// NPCs in this case
  @override
  List<Character> get characters;

  /// All clues available in this case
  @override
  List<Clue> get clues;

  /// The correct solution
  @override
  Solution get solution;

  /// Target number of location visits for a perfect score
  @override
  int get parVisits;

  /// Estimated play time in minutes
  @override
  int get estimatedMinutes;

  /// Difficulty rating (1-5)
  @override
  int get difficulty;

  /// Create a copy of CaseTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseTemplateImplCopyWith<_$CaseTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
