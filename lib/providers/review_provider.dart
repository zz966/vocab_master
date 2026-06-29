import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/word.dart';
import '../repositories/book_repository.dart';
import '../repositories/word_repository.dart';
import '../utils/review_filter.dart' as review_filter;

/// Today's review queue for the given [bookIds] (empty = all books, mixed).
final todayReviewWordsProvider =
    FutureProvider.family<List<Word>, List<String>>((ref, bookIds) async {
  return ReviewRepository(ref).getTodayReviewWords(bookIds: bookIds);
});

class ReviewRepository {
  ReviewRepository(this._ref);

  final Ref _ref;

  /// Loads words due for review where `nextReview <= today`.
  Future<List<Word>> getTodayReviewWords({
    List<String> bookIds = const [],
    DateTime? today,
  }) async {
    final wordRepo = _ref.read(wordRepositoryProvider);
    final bookRepo = _ref.read(bookRepositoryProvider);

    final ids = bookIds.isNotEmpty
        ? bookIds
        : (await bookRepo.getAllBooks()).map((book) => book.id).toList();

    if (ids.isEmpty) {
      return [];
    }

    final words = await wordRepo.getWordsForBooks(ids);
    return review_filter.getTodayReviewWords(words, today: today, bookIds: ids);
  }
}