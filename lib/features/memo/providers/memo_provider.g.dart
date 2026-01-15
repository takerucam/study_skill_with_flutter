// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memoCountPodHash() => r'7586526e00f4251b63ad13de2c602213dce4e8d3';

/// See also [memoCountPod].
@ProviderFor(memoCountPod)
final memoCountPodProvider = AutoDisposeProvider<int>.internal(
  memoCountPod,
  name: r'memoCountPodProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$memoCountPodHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MemoCountPodRef = AutoDisposeProviderRef<int>;
String _$memoPodHash() => r'aa2b69c6a5e953918ae43007d438737a91c24705';

/// See also [MemoPod].
@ProviderFor(MemoPod)
final memoPodProvider =
    AutoDisposeNotifierProvider<MemoPod, List<Memo>>.internal(
      MemoPod.new,
      name: r'memoPodProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$memoPodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MemoPod = AutoDisposeNotifier<List<Memo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
