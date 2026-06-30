// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkInStatusHash() => r'ab1ff5a2b0a01684f9fd54ee9e4ebea2bdd60c24';

/// See also [checkInStatus].
@ProviderFor(checkInStatus)
final checkInStatusProvider = AutoDisposeProvider<CheckInStatus>.internal(
  checkInStatus,
  name: r'checkInStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkInStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CheckInStatusRef = AutoDisposeProviderRef<CheckInStatus>;
String _$pointsHistoryHash() => r'f3825f80f8526765d49788da43303309db5433dc';

/// See also [pointsHistory].
@ProviderFor(pointsHistory)
final pointsHistoryProvider =
    AutoDisposeFutureProvider<List<PointTransaction>>.internal(
  pointsHistory,
  name: r'pointsHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pointsHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PointsHistoryRef = AutoDisposeFutureProviderRef<List<PointTransaction>>;
String _$allPointsHistoryHash() => r'91af1ee548f3b0ef2dc1828ee48053e4d8ab4650';

/// See also [allPointsHistory].
@ProviderFor(allPointsHistory)
final allPointsHistoryProvider =
    AutoDisposeFutureProvider<List<PointTransaction>>.internal(
  allPointsHistory,
  name: r'allPointsHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allPointsHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllPointsHistoryRef
    = AutoDisposeFutureProviderRef<List<PointTransaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
