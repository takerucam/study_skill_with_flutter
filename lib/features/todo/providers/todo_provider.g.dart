// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredTodosPodHash() => r'141df464c6044da08786597a967cb669371e5996';

/// See also [filteredTodosPod].
@ProviderFor(filteredTodosPod)
final filteredTodosPodProvider = AutoDisposeProvider<List<Todo>>.internal(
  filteredTodosPod,
  name: r'filteredTodosPodProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTodosPodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredTodosPodRef = AutoDisposeProviderRef<List<Todo>>;
String _$uncompletedTodosCountPodHash() =>
    r'789d3ac309a358f5af933dd2171fa98fb77cf5e2';

/// See also [uncompletedTodosCountPod].
@ProviderFor(uncompletedTodosCountPod)
final uncompletedTodosCountPodProvider = AutoDisposeProvider<int>.internal(
  uncompletedTodosCountPod,
  name: r'uncompletedTodosCountPodProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uncompletedTodosCountPodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UncompletedTodosCountPodRef = AutoDisposeProviderRef<int>;
String _$todoPodHash() => r'0466a9e1982c0cb61d27de3831a8884369921f90';

/// See also [TodoPod].
@ProviderFor(TodoPod)
final todoPodProvider =
    AutoDisposeNotifierProvider<TodoPod, List<Todo>>.internal(
      TodoPod.new,
      name: r'todoPodProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoPodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoPod = AutoDisposeNotifier<List<Todo>>;
String _$todoFilterPodHash() => r'fc707e7f88e086562c398c7419fa14af497eebe5';

/// See also [TodoFilterPod].
@ProviderFor(TodoFilterPod)
final todoFilterPodProvider =
    AutoDisposeNotifierProvider<TodoFilterPod, TodoFilter>.internal(
      TodoFilterPod.new,
      name: r'todoFilterPodProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoFilterPodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoFilterPod = AutoDisposeNotifier<TodoFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
