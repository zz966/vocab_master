// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookProgressHash() => r'4f07583341e2ca41a606fc832c1a827634403ed1';

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

/// See also [bookProgress].
@ProviderFor(bookProgress)
const bookProgressProvider = BookProgressFamily();

/// See also [bookProgress].
class BookProgressFamily extends Family<AsyncValue<BookProgress?>> {
  /// See also [bookProgress].
  const BookProgressFamily();

  /// See also [bookProgress].
  BookProgressProvider call(
    String bookId,
  ) {
    return BookProgressProvider(
      bookId,
    );
  }

  @override
  BookProgressProvider getProviderOverride(
    covariant BookProgressProvider provider,
  ) {
    return call(
      provider.bookId,
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
  String? get name => r'bookProgressProvider';
}

/// See also [bookProgress].
class BookProgressProvider extends AutoDisposeFutureProvider<BookProgress?> {
  /// See also [bookProgress].
  BookProgressProvider(
    String bookId,
  ) : this._internal(
          (ref) => bookProgress(
            ref as BookProgressRef,
            bookId,
          ),
          from: bookProgressProvider,
          name: r'bookProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookProgressHash,
          dependencies: BookProgressFamily._dependencies,
          allTransitiveDependencies:
              BookProgressFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  BookProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final String bookId;

  @override
  Override overrideWith(
    FutureOr<BookProgress?> Function(BookProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookProgressProvider._internal(
        (ref) => create(ref as BookProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BookProgress?> createElement() {
    return _BookProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookProgressProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookProgressRef on AutoDisposeFutureProviderRef<BookProgress?> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _BookProgressProviderElement
    extends AutoDisposeFutureProviderElement<BookProgress?>
    with BookProgressRef {
  _BookProgressProviderElement(super.provider);

  @override
  String get bookId => (origin as BookProgressProvider).bookId;
}

String _$globalOverviewStatsHash() =>
    r'e75a285031eb05fff9586a2e969b52295f6a8bc6';

/// See also [globalOverviewStats].
@ProviderFor(globalOverviewStats)
final globalOverviewStatsProvider =
    AutoDisposeFutureProvider<OverviewStats>.internal(
  globalOverviewStats,
  name: r'globalOverviewStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalOverviewStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GlobalOverviewStatsRef = AutoDisposeFutureProviderRef<OverviewStats>;
String _$levelChallengeStarsHash() =>
    r'2c50d736be84e5af816482b73c15fe1961115066';

/// See also [levelChallengeStars].
@ProviderFor(levelChallengeStars)
const levelChallengeStarsProvider = LevelChallengeStarsFamily();

/// See also [levelChallengeStars].
class LevelChallengeStarsFamily extends Family<AsyncValue<Map<int, int>>> {
  /// See also [levelChallengeStars].
  const LevelChallengeStarsFamily();

  /// See also [levelChallengeStars].
  LevelChallengeStarsProvider call(
    String bookId,
  ) {
    return LevelChallengeStarsProvider(
      bookId,
    );
  }

  @override
  LevelChallengeStarsProvider getProviderOverride(
    covariant LevelChallengeStarsProvider provider,
  ) {
    return call(
      provider.bookId,
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
  String? get name => r'levelChallengeStarsProvider';
}

/// See also [levelChallengeStars].
class LevelChallengeStarsProvider
    extends AutoDisposeFutureProvider<Map<int, int>> {
  /// See also [levelChallengeStars].
  LevelChallengeStarsProvider(
    String bookId,
  ) : this._internal(
          (ref) => levelChallengeStars(
            ref as LevelChallengeStarsRef,
            bookId,
          ),
          from: levelChallengeStarsProvider,
          name: r'levelChallengeStarsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$levelChallengeStarsHash,
          dependencies: LevelChallengeStarsFamily._dependencies,
          allTransitiveDependencies:
              LevelChallengeStarsFamily._allTransitiveDependencies,
          bookId: bookId,
        );

  LevelChallengeStarsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bookId,
  }) : super.internal();

  final String bookId;

  @override
  Override overrideWith(
    FutureOr<Map<int, int>> Function(LevelChallengeStarsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LevelChallengeStarsProvider._internal(
        (ref) => create(ref as LevelChallengeStarsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bookId: bookId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<int, int>> createElement() {
    return _LevelChallengeStarsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LevelChallengeStarsProvider && other.bookId == bookId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bookId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LevelChallengeStarsRef on AutoDisposeFutureProviderRef<Map<int, int>> {
  /// The parameter `bookId` of this provider.
  String get bookId;
}

class _LevelChallengeStarsProviderElement
    extends AutoDisposeFutureProviderElement<Map<int, int>>
    with LevelChallengeStarsRef {
  _LevelChallengeStarsProviderElement(super.provider);

  @override
  String get bookId => (origin as LevelChallengeStarsProvider).bookId;
}

String _$booksHash() => r'f07f4960eda645c3e8d6941c5fe87aaee59eceef';

/// See also [Books].
@ProviderFor(Books)
final booksProvider =
    AutoDisposeAsyncNotifierProvider<Books, List<BookProgress>>.internal(
  Books.new,
  name: r'booksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$booksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Books = AutoDisposeAsyncNotifier<List<BookProgress>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
