// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

POI _$POIFromJson(Map<String, dynamic> json) {
  return _POI.fromJson(json);
}

/// @nodoc
mixin _$POI {
  /// OpenStreetMap node/way ID
  int get osmId => throw _privateConstructorUsedError;

  /// Optional name from OSM tags
  String? get name => throw _privateConstructorUsedError;

  /// Latitude coordinate
  double get lat => throw _privateConstructorUsedError;

  /// Longitude coordinate
  double get lon => throw _privateConstructorUsedError;

  /// Raw OSM tags for this POI
  Map<String, String> get osmTags => throw _privateConstructorUsedError;

  /// Story roles this POI can fulfill based on its tags
  List<StoryRole> get storyRoles => throw _privateConstructorUsedError;

  /// Serializes this POI to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of POI
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $POICopyWith<POI> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $POICopyWith<$Res> {
  factory $POICopyWith(POI value, $Res Function(POI) then) =
      _$POICopyWithImpl<$Res, POI>;
  @useResult
  $Res call({
    int osmId,
    String? name,
    double lat,
    double lon,
    Map<String, String> osmTags,
    List<StoryRole> storyRoles,
  });
}

/// @nodoc
class _$POICopyWithImpl<$Res, $Val extends POI> implements $POICopyWith<$Res> {
  _$POICopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of POI
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? osmId = null,
    Object? name = freezed,
    Object? lat = null,
    Object? lon = null,
    Object? osmTags = null,
    Object? storyRoles = null,
  }) {
    return _then(
      _value.copyWith(
            osmId: null == osmId
                ? _value.osmId
                : osmId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lon: null == lon
                ? _value.lon
                : lon // ignore: cast_nullable_to_non_nullable
                      as double,
            osmTags: null == osmTags
                ? _value.osmTags
                : osmTags // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            storyRoles: null == storyRoles
                ? _value.storyRoles
                : storyRoles // ignore: cast_nullable_to_non_nullable
                      as List<StoryRole>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$POIImplCopyWith<$Res> implements $POICopyWith<$Res> {
  factory _$$POIImplCopyWith(_$POIImpl value, $Res Function(_$POIImpl) then) =
      __$$POIImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int osmId,
    String? name,
    double lat,
    double lon,
    Map<String, String> osmTags,
    List<StoryRole> storyRoles,
  });
}

/// @nodoc
class __$$POIImplCopyWithImpl<$Res> extends _$POICopyWithImpl<$Res, _$POIImpl>
    implements _$$POIImplCopyWith<$Res> {
  __$$POIImplCopyWithImpl(_$POIImpl _value, $Res Function(_$POIImpl) _then)
    : super(_value, _then);

  /// Create a copy of POI
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? osmId = null,
    Object? name = freezed,
    Object? lat = null,
    Object? lon = null,
    Object? osmTags = null,
    Object? storyRoles = null,
  }) {
    return _then(
      _$POIImpl(
        osmId: null == osmId
            ? _value.osmId
            : osmId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lon: null == lon
            ? _value.lon
            : lon // ignore: cast_nullable_to_non_nullable
                  as double,
        osmTags: null == osmTags
            ? _value._osmTags
            : osmTags // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        storyRoles: null == storyRoles
            ? _value._storyRoles
            : storyRoles // ignore: cast_nullable_to_non_nullable
                  as List<StoryRole>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$POIImpl extends _POI {
  const _$POIImpl({
    required this.osmId,
    this.name,
    required this.lat,
    required this.lon,
    final Map<String, String> osmTags = const {},
    final List<StoryRole> storyRoles = const [],
  }) : _osmTags = osmTags,
       _storyRoles = storyRoles,
       super._();

  factory _$POIImpl.fromJson(Map<String, dynamic> json) =>
      _$$POIImplFromJson(json);

  /// OpenStreetMap node/way ID
  @override
  final int osmId;

  /// Optional name from OSM tags
  @override
  final String? name;

  /// Latitude coordinate
  @override
  final double lat;

  /// Longitude coordinate
  @override
  final double lon;

  /// Raw OSM tags for this POI
  final Map<String, String> _osmTags;

  /// Raw OSM tags for this POI
  @override
  @JsonKey()
  Map<String, String> get osmTags {
    if (_osmTags is EqualUnmodifiableMapView) return _osmTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_osmTags);
  }

  /// Story roles this POI can fulfill based on its tags
  final List<StoryRole> _storyRoles;

  /// Story roles this POI can fulfill based on its tags
  @override
  @JsonKey()
  List<StoryRole> get storyRoles {
    if (_storyRoles is EqualUnmodifiableListView) return _storyRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_storyRoles);
  }

  @override
  String toString() {
    return 'POI(osmId: $osmId, name: $name, lat: $lat, lon: $lon, osmTags: $osmTags, storyRoles: $storyRoles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$POIImpl &&
            (identical(other.osmId, osmId) || other.osmId == osmId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon) &&
            const DeepCollectionEquality().equals(other._osmTags, _osmTags) &&
            const DeepCollectionEquality().equals(
              other._storyRoles,
              _storyRoles,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    osmId,
    name,
    lat,
    lon,
    const DeepCollectionEquality().hash(_osmTags),
    const DeepCollectionEquality().hash(_storyRoles),
  );

  /// Create a copy of POI
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$POIImplCopyWith<_$POIImpl> get copyWith =>
      __$$POIImplCopyWithImpl<_$POIImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$POIImplToJson(this);
  }
}

abstract class _POI extends POI {
  const factory _POI({
    required final int osmId,
    final String? name,
    required final double lat,
    required final double lon,
    final Map<String, String> osmTags,
    final List<StoryRole> storyRoles,
  }) = _$POIImpl;
  const _POI._() : super._();

  factory _POI.fromJson(Map<String, dynamic> json) = _$POIImpl.fromJson;

  /// OpenStreetMap node/way ID
  @override
  int get osmId;

  /// Optional name from OSM tags
  @override
  String? get name;

  /// Latitude coordinate
  @override
  double get lat;

  /// Longitude coordinate
  @override
  double get lon;

  /// Raw OSM tags for this POI
  @override
  Map<String, String> get osmTags;

  /// Story roles this POI can fulfill based on its tags
  @override
  List<StoryRole> get storyRoles;

  /// Create a copy of POI
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$POIImplCopyWith<_$POIImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
