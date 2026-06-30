import '../core/hive/hive_service.dart';
import '../models/word.dart';
import '../models/word_book.dart';
import '../utils/overview_stats.dart';

class BookProgress {
  const BookProgress({
    required this.book,
    required this.totalWords,
    required this.learnedWords,
  });

  final WordBook book;
  final int totalWords;
  final int learnedWords;

  double get learnedRate =>
      totalWords == 0 ? 0 : learnedWords / totalWords;
}

class BookRepository {
  Future<List<WordBook>> getAllBooks() async {
    await HiveService.importBundledBooksIfNeeded();
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
    final learned = words.where((word) => word.learned).length;
    return BookProgress(
      book: book,
      totalWords: book.totalWords > 0 ? book.totalWords : words.length,
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

  Future<OverviewStats> getGlobalOverviewStats() async {
    final books = await getAllBooks();
    final words = <Word>[];
    for (final book in books) {
      words.addAll(await getWordsForBook(book.id));
    }
    return computeOverviewStats(words);
  }

  Future<void> refreshBundledBooks() {
    return HiveService.importBundledBooksIfNeeded();
  }
}