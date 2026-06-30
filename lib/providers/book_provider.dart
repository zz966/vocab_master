import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/book_repository.dart';
import '../utils/overview_stats.dart';
import 'repository_providers.dart';

part 'book_provider.g.dart';

@riverpod
class Books extends _$Books {
  @override
  Future<List<BookProgress>> build() async {
    return ref.watch(bookRepositoryProvider).getAllBookProgress();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(
      await ref.read(bookRepositoryProvider).getAllBookProgress(),
    );
  }
}

@riverpod
Future<BookProgress?> bookProgress(Ref ref, String bookId) async {
  final repository = ref.watch(bookRepositoryProvider);
  final book = await repository.getBook(bookId);
  if (book == null) {
    return null;
  }
  return repository.getBookProgress(book);
}

@riverpod
Future<OverviewStats> globalOverviewStats(Ref ref) async {
  ref.watch(booksProvider);
  return ref.read(bookRepositoryProvider).getGlobalOverviewStats();
}

@riverpod
Future<Map<int, int>> levelChallengeStars(Ref ref, String bookId) async {
  return ref
      .read(levelChallengeRepositoryProvider)
      .getStarCountsForBook(bookId);
}