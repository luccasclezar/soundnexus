// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProjectControllerModel {
  Project? get project => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  double get volume => throw _privateConstructorUsedError;

  /// Create a copy of ProjectControllerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectControllerModelCopyWith<ProjectControllerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectControllerModelCopyWith<$Res> {
  factory $ProjectControllerModelCopyWith(ProjectControllerModel value,
          $Res Function(ProjectControllerModel) then) =
      _$ProjectControllerModelCopyWithImpl<$Res, ProjectControllerModel>;
  @useResult
  $Res call({Project? project, bool isPlaying, double volume});

  $ProjectCopyWith<$Res>? get project;
}

/// @nodoc
class _$ProjectControllerModelCopyWithImpl<$Res,
        $Val extends ProjectControllerModel>
    implements $ProjectControllerModelCopyWith<$Res> {
  _$ProjectControllerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectControllerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? project = freezed,
    Object? isPlaying = null,
    Object? volume = null,
  }) {
    return _then(_value.copyWith(
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as Project?,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of ProjectControllerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectCopyWith<$Res>? get project {
    if (_value.project == null) {
      return null;
    }

    return $ProjectCopyWith<$Res>(_value.project!, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProjectControllerModelImplCopyWith<$Res>
    implements $ProjectControllerModelCopyWith<$Res> {
  factory _$$ProjectControllerModelImplCopyWith(
          _$ProjectControllerModelImpl value,
          $Res Function(_$ProjectControllerModelImpl) then) =
      __$$ProjectControllerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Project? project, bool isPlaying, double volume});

  @override
  $ProjectCopyWith<$Res>? get project;
}

/// @nodoc
class __$$ProjectControllerModelImplCopyWithImpl<$Res>
    extends _$ProjectControllerModelCopyWithImpl<$Res,
        _$ProjectControllerModelImpl>
    implements _$$ProjectControllerModelImplCopyWith<$Res> {
  __$$ProjectControllerModelImplCopyWithImpl(
      _$ProjectControllerModelImpl _value,
      $Res Function(_$ProjectControllerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectControllerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? project = freezed,
    Object? isPlaying = null,
    Object? volume = null,
  }) {
    return _then(_$ProjectControllerModelImpl(
      project: freezed == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as Project?,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ProjectControllerModelImpl implements _ProjectControllerModel {
  const _$ProjectControllerModelImpl(
      {required this.project, this.isPlaying = false, this.volume = 1.0});

  @override
  final Project? project;
  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final double volume;

  @override
  String toString() {
    return 'ProjectControllerModel(project: $project, isPlaying: $isPlaying, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectControllerModelImpl &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @override
  int get hashCode => Object.hash(runtimeType, project, isPlaying, volume);

  /// Create a copy of ProjectControllerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectControllerModelImplCopyWith<_$ProjectControllerModelImpl>
      get copyWith => __$$ProjectControllerModelImplCopyWithImpl<
          _$ProjectControllerModelImpl>(this, _$identity);
}

abstract class _ProjectControllerModel implements ProjectControllerModel {
  const factory _ProjectControllerModel(
      {required final Project? project,
      final bool isPlaying,
      final double volume}) = _$ProjectControllerModelImpl;

  @override
  Project? get project;
  @override
  bool get isPlaying;
  @override
  double get volume;

  /// Create a copy of ProjectControllerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectControllerModelImplCopyWith<_$ProjectControllerModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
