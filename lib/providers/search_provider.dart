import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/word.dart';
import '../repositories/word_repository.dart';

class WordSearchFilter {
  const WordSearchFilter({
    this.bookId,
    this.favoritesOnly = false,
    this.wrongBookOnly = false,
  });

  final int? bookId;
  final bool favoritesOnly;
  final bool wrongBookOnly;

  static const none = WordSearchFilter();

  WordSearchFilter copyWith({
    int? bookId,
    bool clearBookId = false,
    bool? favoritesOnly,
    bool? wrongBookOnly,
  }) {
    return WordSearchFilter(
      bookId: clearBookId ? null : (bookId ?? this.bookId),
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      wrongBookOnly: wrongBookOnly ?? this.wrongBookOnly,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WordSearchFilter &&
            bookId == other.bookId &&
            favoritesOnly == other.favoritesOnly &&
            wrongBookOnly == other.wrongBookOnly;
  }

  @override
  int get hashCode => Object.hash(bookId, favoritesOnly, wrongBookOnly);
}

typedef WordSearchParams = ({String query, WordSearchFilter filter});

final wordSearchProvider =
    FutureProvider.family<List<Word>, WordSearchParams>((ref, params) async {
  return ref.watch(wordRepositoryProvider).searchWords(
        params.query,
        bookId: params.filter.bookId,
        favoritesOnly: params.filter.favoritesOnly,
        wrongBookOnly: params.filter.wrongBookOnly,
      );
});