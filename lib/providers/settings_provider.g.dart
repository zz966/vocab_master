// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayStudyCountHash() => r'daa546e63c0d49c486548c5093bbcdfc93e96597';

/// See also [todayStudyCount].
@ProviderFor(todayStudyCount)
final todayStudyCountProvider = AutoDisposeFutureProvider<int>.internal(
  todayStudyCount,
  name: r'todayStudyCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayStudyCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodayStudyCountRef = AutoDisposeFutureProviderRef<int>;
String _$settingsHash() => r'5787c0b9c04c4f7a47d0946e9fd600a41eecb21c';

/// See also [Settings].
@ProviderFor(Settings)
final settingsProvider =
    AutoDisposeAsyncNotifierProvider<Settings, UserSettings>.internal(
  Settings.new,
  name: r'settingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Settings = AutoDisposeAsyncNotifier<UserSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
