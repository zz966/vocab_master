// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ttsServiceHash() => r'ce3b41e410f0be1fbbbd8883364e64e1baa0db4b';

/// See also [ttsService].
@ProviderFor(ttsService)
final ttsServiceProvider = Provider<TtsService>.internal(
  ttsService,
  name: r'ttsServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ttsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TtsServiceRef = ProviderRef<TtsService>;
String _$studyServiceHash() => r'3493f9557bb0bb5a5a0b2bd6cf18790034fb9af8';

/// See also [studyService].
@ProviderFor(studyService)
final studyServiceProvider = AutoDisposeProvider<StudyService>.internal(
  studyService,
  name: r'studyServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$studyServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StudyServiceRef = AutoDisposeProviderRef<StudyService>;
String _$navigationIndexHash() => r'd414893e1ca6a80fb2253812d81d3fbffa99ea74';

/// See also [NavigationIndex].
@ProviderFor(NavigationIndex)
final navigationIndexProvider =
    AutoDisposeNotifierProvider<NavigationIndex, int>.internal(
  NavigationIndex.new,
  name: r'navigationIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$navigationIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NavigationIndex = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
