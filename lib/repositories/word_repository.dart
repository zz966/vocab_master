import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../database/isar_service.dart';
import '../models/word.dart';
import '../utils/review_filter.dart';
import '../utils/word_progress.dart';

class WordRepository {
  WordRepository(this._isar);

  final Isar _isar;

  Future<List<Word>> getWordsForBooks(List<int> bookIds) async {
    if (bookIds.isEmpty) {
      return [];
    }

    final seen = <int>{};
    final words = <Word>[];

    for (final bookId in bookIds) {
      final bookWords =
          await _isar.words.filter().bookIdsElementEqualTo(bookId).findAll();
      for (final word in bookWords) {
        if (seen.add(word.id)) {
          words.add(word);
        }
      }
    }

    words.sort((a, b) => a.english.compareTo(b.english));
    return words;
  }

  Future<List<Word>> getDueWordsForBooks(List<int> bookIds) async {
    final now = DateTime.now();
    final words = await getWordsForBooks(bookIds);
    return words
        .where(
          (word) =>
              word.nextReview == null || !word.nextReview!.isAfter(now),
        )
        .toList();
  }

  Future<List<Word>> getReviewWordsForBooks(List<int> bookIds) async {
    final words = await getWordsForBooks(bookIds);
    return getTodayReviewWords(words, bookIds: bookIds);
  }

  Future<List<Word>> getFavoriteWords({List<int>? bookIds}) async {
    if (bookIds == null || bookIds.isEmpty) {
      return _isar.words.filter().isFavoriteEqualTo(true).findAll();
    }
    final words = await getWordsForBooks(bookIds);
    return words.where((word) => word.isFavorite).toList();
  }

  Future<List<Word>> getWrongBookWords({List<int>? bookIds}) async {
    if (bookIds == null || bookIds.isEmpty) {
      return _isar.words.filter().inWrongBookEqualTo(true).findAll();
    }
    final words = await getWordsForBooks(bookIds);
    return words.where((word) => word.inWrongBook).toList();
  }

  Future<Word?> getWord(int id) {
    return _isar.words.get(id);
  }

  Future<void> saveWord(Word word) async {
    await _isar.writeTxn(() async {
      await _isar.words.put(word);
    });
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
    await _isar.writeTxn(() async {
      final words = await _isar.words.where().findAll();
      for (final word in words) {
        resetWordLearningState(word);
        await _isar.words.put(word);
      }
    });
  }

  Future<void> resetWordProgress(Word word) async {
    resetWordLearningState(word);
    await saveWord(word);
  }

  Future<void> resetBookProgress(int bookId) async {
    await _isar.writeTxn(() async {
      final words =
          await _isar.words.filter().bookIdsElementEqualTo(bookId).findAll();
      for (final word in words) {
        resetWordLearningState(word);
        await _isar.words.put(word);
      }
    });
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
          ? null
          : partOfSpeech.trim()
      ..examples = examples;
    await saveWord(word);
  }

  Future<List<Word>> searchWords(
    String query, {
    int? bookId,
    bool favoritesOnly = false,
    bool wrongBookOnly = false,
  }) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      return [];
    }

    List<Word> results;
    if (bookId != null) {
      final words =
          await _isar.words.filter().bookIdsElementEqualTo(bookId).findAll();
      results = words
          .where(
            (word) =>
                word.english
                    .toLowerCase()
                    .contains(trimmed.toLowerCase()) ||
                word.chinese.contains(trimmed),
          )
          .toList();
    } else {
      final englishMatches = await _isar.words
          .filter()
          .englishContains(trimmed, caseSensitive: false)
          .findAll();
      final chineseMatches =
          await _isar.words.filter().chineseContains(trimmed).findAll();

      final seen = <int>{};
      results = <Word>[];
      for (final word in [...englishMatches, ...chineseMatches]) {
        if (seen.add(word.id)) {
          results.add(word);
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
}

final wordRepositoryProvider = Provider<WordRepository>((ref) {
  return WordRepository(IsarService.instance);
});