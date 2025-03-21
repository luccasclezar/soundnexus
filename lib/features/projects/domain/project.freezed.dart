// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return _Project.fromJson(json);
}

/// @nodoc
mixin _$Project {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get rows => throw _privateConstructorUsedError;
  int get columns => throw _privateConstructorUsedError;
  Map<String, ProjectTab> get tabs => throw _privateConstructorUsedError;

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectCopyWith<Project> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) then) =
      _$ProjectCopyWithImpl<$Res, Project>;
  @useResult
  $Res call(
      {String id,
      String name,
      int rows,
      int columns,
      Map<String, ProjectTab> tabs});
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res, $Val extends Project>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rows = null,
    Object? columns = null,
    Object? tabs = null,
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
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
      columns: null == columns
          ? _value.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as int,
      tabs: null == tabs
          ? _value.tabs
          : tabs // ignore: cast_nullable_to_non_nullable
              as Map<String, ProjectTab>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectImplCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$$ProjectImplCopyWith(
          _$ProjectImpl value, $Res Function(_$ProjectImpl) then) =
      __$$ProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int rows,
      int columns,
      Map<String, ProjectTab> tabs});
}

/// @nodoc
class __$$ProjectImplCopyWithImpl<$Res>
    extends _$ProjectCopyWithImpl<$Res, _$ProjectImpl>
    implements _$$ProjectImplCopyWith<$Res> {
  __$$ProjectImplCopyWithImpl(
      _$ProjectImpl _value, $Res Function(_$ProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rows = null,
    Object? columns = null,
    Object? tabs = null,
  }) {
    return _then(_$ProjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rows: null == rows
          ? _value.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
      columns: null == columns
          ? _value.columns
          : columns // ignore: cast_nullable_to_non_nullable
              as int,
      tabs: null == tabs
          ? _value._tabs
          : tabs // ignore: cast_nullable_to_non_nullable
              as Map<String, ProjectTab>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImpl implements _Project {
  const _$ProjectImpl(
      {required this.id,
      required this.name,
      required this.rows,
      required this.columns,
      required final Map<String, ProjectTab> tabs})
      : _tabs = tabs;

  factory _$ProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int rows;
  @override
  final int columns;
  final Map<String, ProjectTab> _tabs;
  @override
  Map<String, ProjectTab> get tabs {
    if (_tabs is EqualUnmodifiableMapView) return _tabs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tabs);
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, rows: $rows, columns: $columns, tabs: $tabs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rows, rows) || other.rows == rows) &&
            (identical(other.columns, columns) || other.columns == columns) &&
            const DeepCollectionEquality().equals(other._tabs, _tabs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, rows, columns,
      const DeepCollectionEquality().hash(_tabs));

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      __$$ProjectImplCopyWithImpl<_$ProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImplToJson(
      this,
    );
  }
}

abstract class _Project implements Project {
  const factory _Project(
      {required final String id,
      required final String name,
      required final int rows,
      required final int columns,
      required final Map<String, ProjectTab> tabs}) = _$ProjectImpl;

  factory _Project.fromJson(Map<String, dynamic> json) = _$ProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get rows;
  @override
  int get columns;
  @override
  Map<String, ProjectTab> get tabs;

  /// Create a copy of Project
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
