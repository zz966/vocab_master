import '../core/hive/hive_service.dart';
import '../models/word.dart';

class WordRepository {
  Future<List<Word>> getWordsForBooks(List<String> bookIds) async {
    if (bookIds.isEmpty) {
      return [];
    }

    final seen = <String>{};
    final words = <Word>[];

    for (final bookId in bookIds) {
      final book = HiveService.getBook(bookId);
      if (book == null) {
        continue;
      }
      for (final word in book.words) {
        if (seen.add(word.id)) {
          word.attachBookId(bookId);
          words.add(word);
        }
      }
    }

    words.sort((a, b) => a.english.compareTo(b.english));
    return words;
  }

  Future<Word?> getWord(String id, {String? bookId}) async {
    if (bookId != null) {
      final book = HiveService.getBook(bookId);
      final word = book?.words.where((item) => item.id == id).firstOrNull;
      if (word != null) {
        word.attachBookId(bookId);
        return word;
      }
    }

    for (final book in HiveService.getAllBooks()) {
      for (final word in book.words) {
        if (word.id == id) {
          word.attachBookId(book.bookId);
          return word;
        }
      }
    }
    return null;
  }

  Future<void> saveWord(Word word, {String? bookId}) async {
    final targetBookId =
        bookId ?? (word.bookIds.isNotEmpty ? word.bookIds.first : null);
    if (targetBookId == null) {
      for (final book in HiveService.getAllBooks()) {
        final index = book.words.indexWhere((item) => item.id == word.id);
        if (index >= 0) {
          book.words[index] = word;
          await HiveService.saveBook(book);
          return;
        }
      }
      return;
    }

    final book = HiveService.getBook(targetBookId);
    if (book == null) {
      return;
    }

    final index = book.words.indexWhere((item) => item.id == word.id);
    if (index >= 0) {
      word.attachBookId(targetBookId);
      book.words[index] = word;
      await HiveService.saveBook(book);
    }
  }

  Future<List<Word>> searchWords(
    String query, {
    String? bookId,
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      return [];
    }

    List<Word> results;
    if (bookId != null) {
      final book = HiveService.getBook(bookId);
      final words = book?.words ?? const <Word>[];
      results = words
          .where(
            (word) =>
                word.english
                    .toLowerCase()
                    .contains(trimmed.toLowerCase()) ||
                word.chinese.contains(trimmed),
          )
          .map((word) {
            word.attachBookId(bookId);
            return word;
          })
          .toList();
    } else {
      final seen = <String>{};
      results = <Word>[];
      for (final book in HiveService.getAllBooks()) {
        for (final word in book.words) {
          final matches = word.english
                  .toLowerCase()
                  .contains(trimmed.toLowerCase()) ||
              word.chinese.contains(trimmed);
          if (matches && seen.add(word.id)) {
            word.attachBookId(book.bookId);
            results.add(word);
          }
        }
      }
    }

    results.sort((a, b) => a.english.compareTo(b.english));
    return results;
  }
}