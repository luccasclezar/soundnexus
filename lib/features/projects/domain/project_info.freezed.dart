// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectInfo _$ProjectInfoFromJson(Map<String, dynamic> json) {
  return _ProjectInfo.fromJson(json);
}

/// @nodoc
mixin _$ProjectInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this ProjectInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectInfoCopyWith<ProjectInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectInfoCopyWith<$Res> {
  factory $ProjectInfoCopyWith(
          ProjectInfo value, $Res Function(ProjectInfo) then) =
      _$ProjectInfoCopyWithImpl<$Res, ProjectInfo>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$ProjectInfoCopyWithImpl<$Res, $Val extends ProjectInfo>
    implements $ProjectInfoCopyWith<$Res> {
  _$ProjectInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectInfoImplCopyWith<$Res>
    implements $ProjectInfoCopyWith<$Res> {
  factory _$$ProjectInfoImplCopyWith(
          _$ProjectInfoImpl value, $Res Function(_$ProjectInfoImpl) then) =
      __$$ProjectInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$ProjectInfoImplCopyWithImpl<$Res>
    extends _$ProjectInfoCopyWithImpl<$Res, _$ProjectInfoImpl>
    implements _$$ProjectInfoImplCopyWith<$Res> {
  __$$ProjectInfoImplCopyWithImpl(
      _$ProjectInfoImpl _value, $Res Function(_$ProjectInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$ProjectInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectInfoImpl implements _ProjectInfo {
  const _$ProjectInfoImpl({required this.id, required this.name});

  factory _$ProjectInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'ProjectInfo(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectInfoImplCopyWith<_$ProjectInfoImpl> get copyWith =>
      __$$ProjectInfoImplCopyWithImpl<_$ProjectInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectInfoImplToJson(
      this,
    );
  }
}

abstract class _ProjectInfo implements ProjectInfo {
  const factory _ProjectInfo(
      {required final String id,
      required final String name}) = _$ProjectInfoImpl;

  factory _ProjectInfo.fromJson(Map<String, dynamic> json) =
      _$ProjectInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of ProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectInfoImplCopyWith<_$ProjectInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
