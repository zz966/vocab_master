import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/hive/hive_service.dart';
import '../models/word.dart';
import '../utils/review_filter.dart';
import '../utils/word_progress.dart';

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

  Future<List<Word>> getDueWordsForBooks(List<String> bookIds) async {
    final now = DateTime.now();
    final words = await getWordsForBooks(bookIds);
    return words
        .where(
          (word) =>
              word.nextReview == null || !word.nextReview!.isAfter(now),
        )
        .toList();
  }

  Future<List<Word>> getReviewWordsForBooks(List<String> bookIds) async {
    final words = await getWordsForBooks(bookIds);
    return getTodayReviewWords(words, bookIds: bookIds);
  }

  Future<List<Word>> getFavoriteWords({List<String>? bookIds}) async {
    if (bookIds == null || bookIds.isEmpty) {
      return _allWords().where((word) => word.isFavorite).toList();
    }
    final words = await getWordsForBooks(bookIds);
    return words.where((word) => word.isFavorite).toList();
  }

  Future<List<Word>> getWrongBookWords({List<String>? bookIds}) async {
    if (bookIds == null || bookIds.isEmpty) {
      return _allWords().where((word) => word.inWrongBook).toList();
    }
    final words = await getWordsForBooks(bookIds);
    return words.where((word) => word.inWrongBook).toList();
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

  Future<void> toggleFavorite(Word word) async {
    word.isFavorite = !word.isFavorite;
    await saveWord(word);
  }

  Future<void> removeFromWrongBook(Word word) async {
    word.inWrongBook = false;
    await saveWord(word);
  }

  Future<void> toggleWrongBook(Word word) async {
    word.inWrongBook = !word.inWrongBook;
    await saveWord(word);
  }

  Future<void> addToWrongBook(Word word) async {
    if (!word.inWrongBook) {
      word.inWrongBook = true;
      await saveWord(word);
    }
  }

  Future<void> resetAllLearningProgress() async {
    for (final book in HiveService.getAllBooks()) {
      for (final word in book.words) {
        resetWordLearningState(word);
      }
      await HiveService.saveBook(book);
    }
  }

  Future<void> resetWordProgress(Word word) async {
    resetWordLearningState(word);
    await saveWord(word);
  }

  Future<void> resetBookProgress(String bookId) async {
    final book = HiveService.getBook(bookId);
    if (book == null) {
      return;
    }
    for (final word in book.words) {
      resetWordLearningState(word);
    }
    await HiveService.saveBook(book);
  }

  Future<void> updateWordFields(
    Word word, {
    required String english,
    required String chinese,
    String? phonetic,
    String? partOfSpeech,
    List<String>? examples,
  }) async {
    word
      ..english = english.trim()
      ..chinese = chinese.trim()
      ..phonetic = phonetic == null || phonetic.trim().isEmpty
          ? null
          : phonetic.trim()
      ..partOfSpeech = partOfSpeech == null || partOfSpeech.trim().isEmpty
          ? ''
          : partOfSpeech.trim()
      ..examples = examples;
    await saveWord(word);
  }

  Future<List<Word>> searchWords(
    String query, {
    String? bookId,
    bool favoritesOnly = false,
    bool wrongBookOnly = false,
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

    if (favoritesOnly) {
      results = results.where((word) => word.isFavorite).toList();
    }
    if (wrongBookOnly) {
      results = results.where((word) => word.inWrongBook).toList();
    }

    results.sort((a, b) => a.english.compareTo(b.english));
    return results;
  }

  List<Word> _allWords() {
    final words = <Word>[];
    for (final book in HiveService.getAllBooks()) {
      for (final word in book.words) {
        word.attachBookId(book.bookId);
        words.add(word);
      }
    }
    return words;
  }
}

final wordRepositoryProvider = Provider<WordRepository>((ref) {
  return WordRepository();
});