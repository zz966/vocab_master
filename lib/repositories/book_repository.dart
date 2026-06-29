import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/hive/hive_service.dart';
import '../models/word.dart';
import '../models/word_book.dart';
import '../utils/book_export.dart';
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

  double get learnedRate =>
      totalWords == 0 ? 0 : learnedWords / totalWords;

  bool get isCustom => book.category == 'custom';
}

class BookRepository {
  Future<List<WordBook>> getAllBooks() async {
    await HiveService.importTestBookIfNeeded();
    return HiveService.getAllBooks();
  }

  Future<WordBook?> getBook(String id) async {
    return HiveService.getBook(id);
  }

  Future<List<Word>> getWordsForBook(String bookId) async {
    final book = await getBook(bookId);
    if (book == null) {
      return [];
    }
    return book.words.map((word) {
      word.attachBookId(bookId);
      return word;
    }).toList();
  }

  Future<List<WordBook>> getBooksForWord(Word word) async {
    final books = <WordBook>[];
    for (final bookId in word.bookIds) {
      final book = await getBook(bookId);
      if (book != null) {
        books.add(book);
      }
    }
    if (books.isNotEmpty) {
      return books;
    }

    for (final book in await getAllBooks()) {
      if (book.words.any((item) => item.id == word.id)) {
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
    final book = Book(
      bookId: HiveService.nextId('book'),
      bookName: title,
      description: description ?? '',
      category: category,
      coverColor: coverColor ?? '#607D8B',
    );
    await HiveService.saveBook(book);
    return book;
  }

  Future<void> updateBook(WordBook book) async {
    await HiveService.saveBook(book);
  }

  Future<bool> deleteBook(String bookId) async {
    final book = await getBook(bookId);
    if (book == null || book.category != 'custom') {
      return false;
    }
    await HiveService.deleteBook(bookId);
    return true;
  }

  Future<void> addWordToBook({
    required String bookId,
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
    required String bookId,
    required WordImportData item,
    List<String>? peerWords,
  }) async {
    final book = await getBook(bookId);
    if (book == null) {
      return;
    }

    final existing = book.words
        .where(
          (word) =>
              word.english.toLowerCase() == item.english.trim().toLowerCase(),
        )
        .firstOrNull;

    if (existing != null) {
      return;
    }

    final peers = peerWords ?? book.words.map((word) => word.english).toList();
    final word = WordFactory.fromImport(
      item,
      bookId: bookId,
      wordIndex: book.words.length + 1,
      peerWords: peers,
    );
    book.words.add(word);
    await HiveService.saveBook(book);
  }

  Future<void> removeWordFromBook({
    required String bookId,
    required String wordId,
  }) async {
    final book = await getBook(bookId);
    if (book == null) {
      return;
    }

    book.words.removeWhere((word) => word.id == wordId);
    await HiveService.saveBook(book);
  }

  Future<String> exportBookJson(String bookId) async {
    final book = await getBook(bookId);
    if (book == null) {
      throw StateError('单词书不存在');
    }
    final words = await getWordsForBook(bookId);
    return BookExportCodec.encode(book, words);
  }

  Future<void> seedBuiltInBooks() {
    return HiveService.seedBuiltInBooks();
  }

  Future<void> ensureTestBook() {
    return HiveService.importTestBookIfNeeded();
  }

  Future<WordBook> importBookFromJson(String json) async {
    final data = BookExportCodec.decode(json);
    final book = Book(
      bookId: HiveService.nextId('book'),
      bookName: data.title,
      description: data.description ?? '',
      category: 'custom',
      coverColor: data.coverColor ?? '#607D8B',
    );

    final peerWords = data.words.map((item) => item.english).toList();
    for (var i = 0; i < data.words.length; i++) {
      book.words.add(
        WordFactory.fromImport(
          data.words[i],
          bookId: book.bookId,
          wordIndex: i + 1,
          peerWords: peerWords,
        ),
      );
    }

    await HiveService.saveBook(book);
    return book;
  }
}

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository();
});