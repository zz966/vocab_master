import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../data/built_in_books.dart';
import '../database/isar_service.dart';
import '../models/word.dart';
import '../models/word_book.dart';
import '../utils/book_export.dart';
import '../utils/kylebing_vocab_codec.dart';
import '../utils/word_factory.dart';

class BookProgress {
  const BookProgress({
    required this.book,
    required this.totalWords,
    required this.masteredWords,
    required this.learnedWords,
  });

  final WordBook book;
  final int totalWords;
  final int masteredWords;
  final int learnedWords;

  double get masteryRate =>
      totalWords == 0 ? 0 : masteredWords / totalWords;

  bool get isCustom => book.category == 'custom';
}

class BookRepository {
  BookRepository(this._isar);

  final Isar _isar;

  Future<List<WordBook>> getAllBooks() {
    return _isar.wordBooks.where().anyId().findAll();
  }

  Future<WordBook?> getBook(int id) {
    return _isar.wordBooks.get(id);
  }

  Future<List<Word>> getWordsForBook(int bookId) {
    return _isar.words.filter().bookIdsElementEqualTo(bookId).findAll();
  }

  Future<List<WordBook>> getBooksForWord(Word word) async {
    final books = <WordBook>[];
    for (final bookId in word.bookIds) {
      final book = await getBook(bookId);
      if (book != null) {
        books.add(book);
      }
    }
    return books;
  }

  Future<BookProgress> getBookProgress(WordBook book) async {
    final words = await getWordsForBook(book.id);
    final mastered =
        words.where((word) => word.familiarity >= 4).length;
    final learned = words.where((word) => word.familiarity > 0).length;
    return BookProgress(
      book: book,
      totalWords: book.totalWords > 0 ? book.totalWords : words.length,
      masteredWords: mastered,
      learnedWords: learned,
    );
  }

  Future<List<BookProgress>> getAllBookProgress() async {
    final books = await getAllBooks();
    final progressList = <BookProgress>[];
    for (final book in books) {
      progressList.add(await getBookProgress(book));
    }
    return progressList;
  }

  Future<WordBook> createBook({
    required String title,
    String? description,
    String category = 'custom',
    String? coverColor,
  }) async {
    final book = WordBook()
      ..title = title
      ..description = description
      ..category = category
      ..coverColor = coverColor ?? '#607D8B';

    await _isar.writeTxn(() async {
      await _isar.wordBooks.put(book);
    });
    return book;
  }

  Future<void> updateBook(WordBook book) async {
    await _isar.writeTxn(() async {
      await _isar.wordBooks.put(book);
    });
  }

  Future<bool> deleteBook(int bookId) async {
    final book = await getBook(bookId);
    if (book == null || book.category != 'custom') {
      return false;
    }

    await _isar.writeTxn(() async {
      final words = await getWordsForBook(bookId);
      for (final word in words) {
        word.bookIds.remove(bookId);
        if (word.bookIds.isEmpty) {
          await _isar.words.delete(word.id);
        } else {
          await _isar.words.put(word);
        }
      }
      await _isar.wordBooks.delete(bookId);
    });
    return true;
  }

  Future<void> addWordToBook({
    required int bookId,
    required String english,
    required String chinese,
    String? phonetic,
    String? partOfSpeech,
    List<String>? examples,
  }) async {
    final importData = WordImportData(
      english: english,
      chinese: chinese,
      phonetic: phonetic,
      partOfSpeech: partOfSpeech,
      examples: examples,
    );
    await _addImportDataToBook(bookId: bookId, item: importData);
  }

  Future<void> _addImportDataToBook({
    required int bookId,
    required WordImportData item,
    List<String>? peerWords,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.words
          .filter()
          .englishEqualTo(item.english, caseSensitive: false)
          .findFirst();

      if (existing != null) {
        if (!existing.bookIds.contains(bookId)) {
          existing.bookIds = [...existing.bookIds, bookId];
          await _isar.words.put(existing);
        }
      } else {
        final word = WordFactory.fromImport(
          item,
          bookIds: [bookId],
          peerWords: peerWords,
        );
        await _isar.words.put(word);
      }

      await _updateBookWordCount(bookId);
    });
  }

  Future<void> removeWordFromBook({
    required int bookId,
    required int wordId,
  }) async {
    await _isar.writeTxn(() async {
      final word = await _isar.words.get(wordId);
      if (word == null) {
        return;
      }

      word.bookIds.remove(bookId);
      if (word.bookIds.isEmpty) {
        await _isar.words.delete(wordId);
      } else {
        await _isar.words.put(word);
      }
      await _updateBookWordCount(bookId);
    });
  }

  Future<String> exportBookJson(int bookId) async {
    final book = await getBook(bookId);
    if (book == null) {
      throw StateError('单词书不存在');
    }
    final words = await getWordsForBook(bookId);
    return BookExportCodec.encode(book, words);
  }

  Future<void> seedBuiltInBooks() async {
    if (await _isar.wordBooks.count() > 0) {
      return;
    }

    for (final definition in BuiltInBooks.books) {
      final json = await rootBundle.loadString(definition.assetPath);
      await _importBuiltInBook(definition, json);
    }
  }

  Future<void> _importBuiltInBook(
    BuiltInBookDefinition definition,
    String json,
  ) async {
    final words = KyleBingVocabCodec.decode(json);
    final peerWords = words.map((item) => item.english).toList();

    await _isar.writeTxn(() async {
      final book = WordBook()
        ..title = definition.title
        ..description = definition.description
        ..category = definition.category
        ..coverColor = definition.coverColor;
      await _isar.wordBooks.put(book);

      for (final item in words) {
        final existing = await _isar.words
            .filter()
            .englishEqualTo(item.english, caseSensitive: false)
            .findFirst();

        if (existing != null) {
          if (!existing.bookIds.contains(book.id)) {
            existing.bookIds = [...existing.bookIds, book.id];
            await _isar.words.put(existing);
          }
        } else {
          final word = WordFactory.fromImport(
            item,
            bookIds: [book.id],
            peerWords: peerWords,
          );
          await _isar.words.put(word);
        }
      }

      await _updateBookWordCount(book.id);
    });
  }

  Future<WordBook> importBookFromJson(String json) async {
    final data = BookExportCodec.decode(json);

    return _isar.writeTxn(() async {
      final book = WordBook()
        ..title = data.title
        ..description = data.description
        ..category = 'custom'
        ..coverColor = data.coverColor;
      await _isar.wordBooks.put(book);

      final peerWords = data.words.map((item) => item.english).toList();
      for (final item in data.words) {
        final existing = await _isar.words
            .filter()
            .englishEqualTo(item.english, caseSensitive: false)
            .findFirst();

        if (existing != null) {
          if (!existing.bookIds.contains(book.id)) {
            existing.bookIds = [...existing.bookIds, book.id];
            await _isar.words.put(existing);
          }
        } else {
          final word = WordFactory.fromImport(
            item,
            bookIds: [book.id],
            peerWords: peerWords,
          );
          await _isar.words.put(word);
        }
      }

      await _updateBookWordCount(book.id);
      return book;
    });
  }

  Future<void> _updateBookWordCount(int bookId) async {
    final book = await _isar.wordBooks.get(bookId);
    if (book == null) {
      return;
    }
    final count =
        await _isar.words.filter().bookIdsElementEqualTo(bookId).count();
    book.totalWords = count;
    await _isar.wordBooks.put(book);
  }
}

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository(IsarService.instance);
});