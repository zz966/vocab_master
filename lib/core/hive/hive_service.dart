import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/built_in_books.dart';
import '../../models/book_model.dart';
import '../../models/learning_session.dart';
import '../../models/level_challenge_progress.dart';
import '../../models/point_transaction.dart';
import '../../models/review_record.dart';
import '../../models/user_settings.dart';
import '../../utils/kylebing_vocab_codec.dart';
import '../../utils/word_factory.dart';

class HiveService {
  HiveService._();

  static const booksBoxName = 'books';
  static const settingsBoxName = 'settings';
  static const settingsKey = 'default';
  static const sessionsBoxName = 'sessions';
  static const reviewRecordsBoxName = 'review_records';
  static const levelChallengesBoxName = 'level_challenges';
  static const pointTransactionsBoxName = 'point_transactions';

  static bool _initialized = false;

  static const _allBoxNames = [
    booksBoxName,
    settingsBoxName,
    sessionsBoxName,
    reviewRecordsBoxName,
    levelChallengesBoxName,
    pointTransactionsBoxName,
  ];

  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    await Hive.initFlutter();
    _registerAdapters();

    await _openBoxOrReset<Book>(booksBoxName);
    await _openBoxOrReset<UserSettings>(settingsBoxName);
    await _openBoxOrReset<LearningSession>(sessionsBoxName);
    await _openBoxOrReset<ReviewRecord>(reviewRecordsBoxName);
    await _openBoxOrReset<LevelChallengeProgress>(levelChallengesBoxName);
    await _openBoxOrReset<PointTransaction>(pointTransactionsBoxName);

    _initialized = true;
  }

  static Future<void> resetAllBoxes() async {
    for (final name in _allBoxNames) {
      await _closeBoxIfOpen(name);
      try {
        await Hive.deleteBoxFromDisk(name);
      } on Object catch (error) {
        debugPrint('删除 Hive box "$name" 失败: $error');
      }
    }
    _initialized = false;
  }

  static Future<void> _openBoxOrReset<T>(String name) async {
    try {
      await _closeBoxIfOpen(name);
      await Hive.openBox<T>(name);
    } on Object catch (error, stackTrace) {
      debugPrint('Hive box "$name" 打开失败，正在重置: $error');
      debugPrint('$stackTrace');
      await _closeBoxIfOpen(name);
      try {
        await Hive.deleteBoxFromDisk(name);
      } on Object catch (deleteError) {
        debugPrint('删除 Hive box "$name" 失败: $deleteError');
      }
      await Hive.openBox<T>(name);
    }
  }

  static Future<void> _closeBoxIfOpen(String name) async {
    if (Hive.isBoxOpen(name)) {
      await Hive.box(name).close();
    }
  }

  static void _registerAdapters() {
    if (Hive.isAdapterRegistered(0)) {
      return;
    }

    Hive
      ..registerAdapter(BookAdapter())
      ..registerAdapter(BookWordAdapter())
      ..registerAdapter(BookWordExampleAdapter())
      ..registerAdapter(MemoryTipsAdapter())
      ..registerAdapter(WordDefinitionAdapter())
      ..registerAdapter(WordExampleAdapter())
      ..registerAdapter(WordPhraseAdapter())
      ..registerAdapter(ConfusableWordAdapter())
      ..registerAdapter(UserSettingsAdapter())
      ..registerAdapter(LearningSessionAdapter())
      ..registerAdapter(ReviewRecordAdapter())
      ..registerAdapter(LevelChallengeProgressAdapter())
      ..registerAdapter(PointTransactionAdapter());
  }

  static Box<Book> get _books => Hive.box<Book>(booksBoxName);

  static Box<UserSettings> get _settings => Hive.box<UserSettings>(settingsBoxName);

  static Box<LearningSession> get _sessions =>
      Hive.box<LearningSession>(sessionsBoxName);

  static Box<ReviewRecord> get _reviewRecords =>
      Hive.box<ReviewRecord>(reviewRecordsBoxName);

  static Box<LevelChallengeProgress> get _levelChallenges =>
      Hive.box<LevelChallengeProgress>(levelChallengesBoxName);

  static Box<PointTransaction> get _pointTransactions =>
      Hive.box<PointTransaction>(pointTransactionsBoxName);

  static Future<void> importInitialBooks() async {
    if (_books.isEmpty) {
      await seedBuiltInBooks();

      try {
        final jsonStr =
            await rootBundle.loadString('assets/books/cet4_1.json');
        final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
        _attachBookIds(book);
        await saveBook(book);
        debugPrint(
          '✅ CET4 单词书导入成功，共 ${book.words.length} 个单词（bookId: ${book.bookId}）',
        );
      } catch (e, stackTrace) {
        debugPrint('❌ 导入 cet4_1.json 失败: $e');
        debugPrint('$stackTrace');
      }
    }

    await importTestBookIfNeeded();
  }

  static const testBookId = 'TEST_40';

  /// 导入 40 词测试词库（第 1 关 30 词 + 第 2 关 10 词），便于流程验证。
  static Future<void> importTestBookIfNeeded() async {
    try {
      final jsonStr =
          await rootBundle.loadString('assets/books/test_40.json');
      final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
      _attachBookIds(book);

      final existing = _books.get(testBookId);
      if (existing != null) {
        if (!_needsTestBookContentRefresh(existing)) {
          return;
        }
        _preserveWordLearningState(from: existing, into: book);
      }

      await saveBook(book);
      debugPrint(
        existing == null
            ? '✅ 测试词库导入成功，共 ${book.words.length} 个单词（bookId: ${book.bookId}）'
            : '✅ 测试词库内容已更新，共 ${book.words.length} 个单词（bookId: ${book.bookId}）',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 导入 test_40.json 失败: $e');
      debugPrint('$stackTrace');
    }
  }

  static bool _collocationsMissingExamples(BookWord word) {
    final phrases = word.collocations;
    if (phrases == null || phrases.isEmpty) {
      return false;
    }
    return phrases.any(
      (phrase) => (phrase.exampleEnglish ?? '').trim().isEmpty,
    );
  }

  static bool _needsTestBookContentRefresh(Book book) {
    if (!book.description.contains('content-v7')) {
      return true;
    }
    return book.words.any(
      (word) =>
          word.sentenceExamples.length < 3 ||
          word.definitions == null ||
          word.englishDefinitions == null ||
          word.synonymDetails == null ||
          word.synonymDetails!.any((item) => item.explanation.trim().isEmpty) ||
          _collocationsMissingExamples(word) ||
          word.phoneticUk.trim().isEmpty,
    );
  }

  static void _preserveWordLearningState({
    required Book from,
    required Book into,
  }) {
    final previousWords = {for (final word in from.words) word.id: word};
    for (final word in into.words) {
      final previous = previousWords[word.id];
      if (previous == null) {
        continue;
      }
      word
        ..masteryLevel = previous.masteryLevel
        ..lastReviewTime = previous.lastReviewTime
        ..reviewCount = previous.reviewCount
        ..correctStreak = previous.correctStreak
        ..easeFactor = previous.easeFactor
        ..sm2Interval = previous.sm2Interval
        ..isFavorite = previous.isFavorite
        ..inWrongBook = previous.inWrongBook;
    }
  }

  static Future<void> seedBuiltInBooks() async {
    if (_books.isNotEmpty) {
      return;
    }

    for (final definition in BuiltInBooks.books) {
      final json = await rootBundle.loadString(definition.assetPath);
      final bookId = _bookIdFromAsset(definition.assetPath);
      final items = KyleBingVocabCodec.decode(json);
      final peerWords = items.map((item) => item.english).toList();
      final words = <BookWord>[];

      for (var i = 0; i < items.length; i++) {
        words.add(
          WordFactory.fromImport(
            items[i],
            bookId: bookId,
            wordIndex: i + 1,
            peerWords: peerWords,
          ),
        );
      }

      final book = Book(
        bookId: bookId,
        bookName: definition.title,
        description: definition.description,
        category: definition.category,
        coverColor: definition.coverColor,
        totalWords: words.length,
        words: words,
      );
      _attachBookIds(book);
      await saveBook(book);
    }
  }

  static String _bookIdFromAsset(String assetPath) {
    final fileName = assetPath.split('/').last;
    return fileName.replaceAll('.json', '').toLowerCase();
  }

  static void _attachBookIds(Book book) {
    for (final word in book.words) {
      word.bookIds = [book.bookId];
    }
  }

  static Future<void> seedDefaultSettingsIfNeeded() async {
    if (_settings.containsKey(settingsKey)) {
      return;
    }

    final firstBook = _books.values.isEmpty ? null : _books.values.first;
    final settings = UserSettings(
      defaultBookIds: firstBook != null ? [firstBook.bookId] : [],
    );
    await _settings.put(settingsKey, settings);
  }

  static Future<void> saveBook(Book book) async {
    book.totalWords = book.words.length;
    await _books.put(book.bookId, book);
  }

  static List<Book> getAllBooks() {
    return _books.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  static Book? getBook(String bookId) => _books.get(bookId);

  static Future<void> deleteBook(String bookId) async {
    await _books.delete(bookId);
  }

  static UserSettings getSettings() {
    return _settings.get(settingsKey) ?? UserSettings();
  }

  static Future<void> saveSettings(UserSettings settings) async {
    settings.updatedAt = DateTime.now();
    await _settings.put(settingsKey, settings);
  }

  static Future<void> saveSession(LearningSession session) async {
    await _sessions.put(session.id, session);
  }

  static LearningSession? getSession(String id) => _sessions.get(id);

  static List<LearningSession> getAllSessions() {
    return _sessions.values.toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  static Future<void> deleteSession(String id) async {
    await _sessions.delete(id);
  }

  static Future<void> clearSessions() async {
    await _sessions.clear();
  }

  static Future<void> saveReviewRecord(ReviewRecord record) async {
    await _reviewRecords.put(record.id, record);
  }

  static List<ReviewRecord> getAllReviewRecords() {
    return _reviewRecords.values.toList()
      ..sort((a, b) => b.reviewedAt.compareTo(a.reviewedAt));
  }

  static Future<void> clearReviewRecords() async {
    await _reviewRecords.clear();
  }

  static LevelChallengeProgress? getLevelChallengeProgress(
    String bookId,
    int levelIndex,
  ) {
    return _levelChallenges.get(levelChallengeStorageKey(bookId, levelIndex));
  }

  static Map<String, LevelChallengeProgress> getLevelChallengeProgressForBook(
    String bookId,
  ) {
    final prefix = '${bookId}_';
    return Map.fromEntries(
      _levelChallenges.values
          .where((item) => item.bookId == bookId)
          .map((item) => MapEntry(item.storageKey, item)),
    );
  }

  static Future<void> saveLevelChallengeProgress(
    LevelChallengeProgress progress,
  ) async {
    await _levelChallenges.put(progress.storageKey, progress);
  }

  static String nextId(String prefix) =>
      '${prefix}_${DateTime.now().microsecondsSinceEpoch}';

  static Future<void> savePointTransaction(PointTransaction transaction) async {
    await _pointTransactions.put(transaction.id, transaction);
  }

  static List<PointTransaction> getPointTransactions() {
    return _pointTransactions.values.toList();
  }

  static Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}