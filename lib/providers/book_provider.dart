import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/word.dart';
import '../repositories/book_repository.dart';
import '../utils/overview_stats.dart';

/// All word books with per-book progress, backed by [AsyncNotifier].
class BooksNotifier extends AsyncNotifier<List<BookProgress>> {
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

final booksProvider = AsyncNotifierProvider<BooksNotifier, List<BookProgress>>(
  BooksNotifier.new,
);

final bookProgressProvider =
    FutureProvider.family<BookProgress?, String>((ref, bookId) async {
  final repository = ref.watch(bookRepositoryProvider);
  final book = await repository.getBook(bookId);
  if (book == null) {
    return null;
  }
  return repository.getBookProgress(book);
});

final bookWordsProvider =
    FutureProvider.family<List<Word>, String>((ref, bookId) async {
  return ref.watch(bookRepositoryProvider).getWordsForBook(bookId);
});

final globalOverviewStatsProvider = FutureProvider<OverviewStats>((ref) async {
  ref.watch(booksProvider);
  return ref.read(bookRepositoryProvider).getGlobalOverviewStats();
});