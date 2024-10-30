// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectPageControllerHash() =>
    r'0039265590dfe70c40740e2a457c13ac1bb9ade8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ProjectPageController
    extends BuildlessAutoDisposeNotifier<ProjectControllerModel> {
  late final String projectId;

  ProjectControllerModel build(
    String projectId,
  );
}

/// See also [ProjectPageController].
@ProviderFor(ProjectPageController)
const projectPageControllerProvider = ProjectPageControllerFamily();

/// See also [ProjectPageController].
class ProjectPageControllerFamily extends Family<ProjectControllerModel> {
  /// See also [ProjectPageController].
  const ProjectPageControllerFamily();

  /// See also [ProjectPageController].
  ProjectPageControllerProvider call(
    String projectId,
  ) {
    return ProjectPageControllerProvider(
      projectId,
    );
  }

  @override
  ProjectPageControllerProvider getProviderOverride(
    covariant ProjectPageControllerProvider provider,
  ) {
    return call(
      provider.projectId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'projectPageControllerProvider';
}

/// See also [ProjectPageController].
class ProjectPageControllerProvider extends AutoDisposeNotifierProviderImpl<
    ProjectPageController, ProjectControllerModel> {
  /// See also [ProjectPageController].
  ProjectPageControllerProvider(
    String projectId,
  ) : this._internal(
          () => ProjectPageController()..projectId = projectId,
          from: projectPageControllerProvider,
          name: r'projectPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectPageControllerHash,
          dependencies: ProjectPageControllerFamily._dependencies,
          allTransitiveDependencies:
              ProjectPageControllerFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectPageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  ProjectControllerModel runNotifierBuild(
    covariant ProjectPageController notifier,
  ) {
    return notifier.build(
      projectId,
    );
  }

  @override
  Override overrideWith(ProjectPageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProjectPageControllerProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ProjectPageController,
      ProjectControllerModel> createElement() {
    return _ProjectPageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectPageControllerProvider &&
        other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProjectPageControllerRef
    on AutoDisposeNotifierProviderRef<ProjectControllerModel> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectPageControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ProjectPageController,
        ProjectControllerModel> with ProjectPageControllerRef {
  _ProjectPageControllerProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectPageControllerProvider).projectId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
