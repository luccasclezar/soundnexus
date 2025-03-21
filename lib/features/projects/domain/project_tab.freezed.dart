// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_tab.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectTab _$ProjectTabFromJson(Map<String, dynamic> json) {
  return _ProjectTab.fromJson(json);
}

/// @nodoc
mixin _$ProjectTab {
  Map<String, AudioFile> get audioFiles => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this ProjectTab to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectTab
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectTabCopyWith<ProjectTab> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectTabCopyWith<$Res> {
  factory $ProjectTabCopyWith(
          ProjectTab value, $Res Function(ProjectTab) then) =
      _$ProjectTabCopyWithImpl<$Res, ProjectTab>;
  @useResult
  $Res call(
      {Map<String, AudioFile> audioFiles, String id, int index, String name});
}

/// @nodoc
class _$ProjectTabCopyWithImpl<$Res, $Val extends ProjectTab>
    implements $ProjectTabCopyWith<$Res> {
  _$ProjectTabCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectTab
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioFiles = null,
    Object? id = null,
    Object? index = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      audioFiles: null == audioFiles
          ? _value.audioFiles
          : audioFiles // ignore: cast_nullable_to_non_nullable
              as Map<String, AudioFile>,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectTabImplCopyWith<$Res>
    implements $ProjectTabCopyWith<$Res> {
  factory _$$ProjectTabImplCopyWith(
          _$ProjectTabImpl value, $Res Function(_$ProjectTabImpl) then) =
      __$$ProjectTabImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, AudioFile> audioFiles, String id, int index, String name});
}

/// @nodoc
class __$$ProjectTabImplCopyWithImpl<$Res>
    extends _$ProjectTabCopyWithImpl<$Res, _$ProjectTabImpl>
    implements _$$ProjectTabImplCopyWith<$Res> {
  __$$ProjectTabImplCopyWithImpl(
      _$ProjectTabImpl _value, $Res Function(_$ProjectTabImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectTab
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioFiles = null,
    Object? id = null,
    Object? index = null,
    Object? name = null,
  }) {
    return _then(_$ProjectTabImpl(
      audioFiles: null == audioFiles
          ? _value._audioFiles
          : audioFiles // ignore: cast_nullable_to_non_nullable
              as Map<String, AudioFile>,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectTabImpl implements _ProjectTab {
  const _$ProjectTabImpl(
      {required final Map<String, AudioFile> audioFiles,
      required this.id,
      required this.index,
      required this.name})
      : _audioFiles = audioFiles;

  factory _$ProjectTabImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectTabImplFromJson(json);

  final Map<String, AudioFile> _audioFiles;
  @override
  Map<String, AudioFile> get audioFiles {
    if (_audioFiles is EqualUnmodifiableMapView) return _audioFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_audioFiles);
  }

  @override
  final String id;
  @override
  final int index;
  @override
  final String name;

  @override
  String toString() {
    return 'ProjectTab(audioFiles: $audioFiles, id: $id, index: $index, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectTabImpl &&
            const DeepCollectionEquality()
                .equals(other._audioFiles, _audioFiles) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_audioFiles), id, index, name);

  /// Create a copy of ProjectTab
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectTabImplCopyWith<_$ProjectTabImpl> get copyWith =>
      __$$ProjectTabImplCopyWithImpl<_$ProjectTabImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectTabImplToJson(
      this,
    );
  }
}

abstract class _ProjectTab implements ProjectTab {
  const factory _ProjectTab(
      {required final Map<String, AudioFile> audioFiles,
      required final String id,
      required final int index,
      required final String name}) = _$ProjectTabImpl;

  factory _ProjectTab.fromJson(Map<String, dynamic> json) =
      _$ProjectTabImpl.fromJson;

  @override
  Map<String, AudioFile> get audioFiles;
  @override
  String get id;
  @override
  int get index;
  @override
  String get name;

  /// Create a copy of ProjectTab
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectTabImplCopyWith<_$ProjectTabImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
