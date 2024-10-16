// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsHash() => r'b5d51b5203787598f4f11c7ca44629deb35232af';

/// See also [projects].
@ProviderFor(projects)
final projectsProvider = AutoDisposeStreamProvider<List<ProjectInfo>>.internal(
  projects,
  name: r'projectsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$projectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProjectsRef = AutoDisposeStreamProviderRef<List<ProjectInfo>>;
String _$projectHash() => r'4369056cdd0f161ef8b883de156a8a69c3712622';

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

/// See also [project].
@ProviderFor(project)
const projectProvider = ProjectFamily();

/// See also [project].
class ProjectFamily extends Family<AsyncValue<Project>> {
  /// See also [project].
  const ProjectFamily();

  /// See also [project].
  ProjectProvider call(
    String projectId,
  ) {
    return ProjectProvider(
      projectId,
    );
  }

  @override
  ProjectProvider getProviderOverride(
    covariant ProjectProvider provider,
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
  String? get name => r'projectProvider';
}

/// See also [project].
class ProjectProvider extends AutoDisposeStreamProvider<Project> {
  /// See also [project].
  ProjectProvider(
    String projectId,
  ) : this._internal(
          (ref) => project(
            ref as ProjectRef,
            projectId,
          ),
          from: projectProvider,
          name: r'projectProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectHash,
          dependencies: ProjectFamily._dependencies,
          allTransitiveDependencies: ProjectFamily._allTransitiveDependencies,
          projectId: projectId,
        );

  ProjectProvider._internal(
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
  Override overrideWith(
    Stream<Project> Function(ProjectRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProjectProvider._internal(
        (ref) => create(ref as ProjectRef),
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
  AutoDisposeStreamProviderElement<Project> createElement() {
    return _ProjectProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProjectRef on AutoDisposeStreamProviderRef<Project> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _ProjectProviderElement extends AutoDisposeStreamProviderElement<Project>
    with ProjectRef {
  _ProjectProviderElement(super.provider);

  @override
  String get projectId => (origin as ProjectProvider).projectId;
}

String _$audioFileHash() => r'4944cd3c2b52c338c235f0d7ae1a179e2547ce93';

/// See also [audioFile].
@ProviderFor(audioFile)
const audioFileProvider = AudioFileFamily();

/// See also [audioFile].
class AudioFileFamily extends Family<AudioFile?> {
  /// See also [audioFile].
  const AudioFileFamily();

  /// See also [audioFile].
  AudioFileProvider call(
    String projectId,
    int x,
    int y,
  ) {
    return AudioFileProvider(
      projectId,
      x,
      y,
    );
  }

  @override
  AudioFileProvider getProviderOverride(
    covariant AudioFileProvider provider,
  ) {
    return call(
      provider.projectId,
      provider.x,
      provider.y,
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
  String? get name => r'audioFileProvider';
}

/// See also [audioFile].
class AudioFileProvider extends AutoDisposeProvider<AudioFile?> {
  /// See also [audioFile].
  AudioFileProvider(
    String projectId,
    int x,
    int y,
  ) : this._internal(
          (ref) => audioFile(
            ref as AudioFileRef,
            projectId,
            x,
            y,
          ),
          from: audioFileProvider,
          name: r'audioFileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$audioFileHash,
          dependencies: AudioFileFamily._dependencies,
          allTransitiveDependencies: AudioFileFamily._allTransitiveDependencies,
          projectId: projectId,
          x: x,
          y: y,
        );

  AudioFileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
    required this.x,
    required this.y,
  }) : super.internal();

  final String projectId;
  final int x;
  final int y;

  @override
  Override overrideWith(
    AudioFile? Function(AudioFileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AudioFileProvider._internal(
        (ref) => create(ref as AudioFileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
        x: x,
        y: y,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AudioFile?> createElement() {
    return _AudioFileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AudioFileProvider &&
        other.projectId == projectId &&
        other.x == x &&
        other.y == y;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, x.hashCode);
    hash = _SystemHash.combine(hash, y.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AudioFileRef on AutoDisposeProviderRef<AudioFile?> {
  /// The parameter `projectId` of this provider.
  String get projectId;

  /// The parameter `x` of this provider.
  int get x;

  /// The parameter `y` of this provider.
  int get y;
}

class _AudioFileProviderElement extends AutoDisposeProviderElement<AudioFile?>
    with AudioFileRef {
  _AudioFileProviderElement(super.provider);

  @override
  String get projectId => (origin as AudioFileProvider).projectId;
  @override
  int get x => (origin as AudioFileProvider).x;
  @override
  int get y => (origin as AudioFileProvider).y;
}

String _$projectsRepositoryHash() =>
    r'db25eea7fc41d0f7cce4a2e1e0018004dce3343f';

/// See also [projectsRepository].
@ProviderFor(projectsRepository)
final projectsRepositoryProvider =
    AutoDisposeProvider<ProjectsRepository>.internal(
  projectsRepository,
  name: r'projectsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProjectsRepositoryRef = AutoDisposeProviderRef<ProjectsRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
