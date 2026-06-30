import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/book_model.dart';
import '../../models/learning_session.dart';
import '../../models/level_challenge_progress.dart';
import '../../models/level_study_progress.dart';
import '../../models/point_transaction.dart';
import '../../models/review_record.dart';
import '../../models/user_settings.dart';
import '../../utils/book_content_utils.dart';


class HiveService {
  HiveService._();

  static const booksBoxName = 'books';
  static const settingsBoxName = 'settings';
  static const settingsKey = 'default';
  static const sessionsBoxName = 'sessions';
  static const reviewRecordsBoxName = 'review_records';
  static const levelChallengesBoxName = 'level_challenges';
  static const levelStudyBoxName = 'level_study';
  static const pointTransactionsBoxName = 'point_transactions';

  static bool _initialized = false;

  static const _bookWordSchemaVersionKey = 'book_word_hive_schema';
  static const _currentBookWordSchemaVersion = 3;

  static const _allBoxNames = [
    booksBoxName,
    settingsBoxName,
    sessionsBoxName,
    reviewRecordsBoxName,
    levelChallengesBoxName,
    levelStudyBoxName,
    pointTransactionsBoxName,
  ];

  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    await Hive.initFlutter();
    _registerAdapters();

    await _resetBooksBoxIfSchemaChanged();
    await _openBoxOrReset<Book>(booksBoxName);
    await _openBoxOrReset<UserSettings>(settingsBoxName);
    await _openBoxOrReset<LearningSession>(sessionsBoxName);
    await _openBoxOrReset<ReviewRecord>(reviewRecordsBoxName);
    await _openBoxOrReset<LevelChallengeProgress>(levelChallengesBoxName);
    await _openBoxOrReset<LevelStudyProgress>(levelStudyBoxName);
    await _openBoxOrReset<PointTransaction>(pointTransactionsBoxName);

    _initialized = true;
  }

  static Future<void> _resetBooksBoxIfSchemaChanged() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getInt(_bookWordSchemaVersionKey) ?? 0;
    if (stored == _currentBookWordSchemaVersion) {
      return;
    }

    await _closeBoxIfOpen(booksBoxName);
    try {
      await Hive.deleteBoxFromDisk(booksBoxName);
    } on Object catch (error) {
      debugPrint('BookWord schema 升级，删除旧 books box 失败: $error');
    }
    await prefs.setInt(
      _bookWordSchemaVersionKey,
      _currentBookWordSchemaVersion,
    );
    debugPrint('📦 BookWord Hive schema 已升级到 v$_currentBookWordSchemaVersion');
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
      ..registerAdapter(LevelStudyProgressAdapter())
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

  static Box<LevelStudyProgress> get _levelStudy =>
      Hive.box<LevelStudyProgress>(levelStudyBoxName);

  static Box<PointTransaction> get _pointTransactions =>
      Hive.box<PointTransaction>(pointTransactionsBoxName);

  /// 内置词书资源，格式与 [test_40.json] 一致（富内容词库）。
  static const bundledBookAssets = <String>[
    'assets/books/test_40.json',
  ];

  /// 已移除的旧版词书，启动时从 Hive 清理，避免遗留简化结构数据。
  static const legacyBookIdsToRemove = <String>[
    'CET4_1',
  ];

  static Future<void> importInitialBooks() async {
    await _purgeLegacyBooks();
    await importBundledBooksIfNeeded();
  }

  /// 导入/更新 assets 中的富内容词书，并校验 Hive 中数据符合 test_40 结构。
  static Future<void> importBundledBooksIfNeeded() async {
    for (final assetPath in bundledBookAssets) {
      await _importBookAssetIfNeeded(assetPath);
    }
  }

  static Future<void> _purgeLegacyBooks() async {
    for (final bookId in legacyBookIdsToRemove) {
      if (!_books.containsKey(bookId)) {
        continue;
      }
      await deleteBook(bookId);
      debugPrint('🗑️ 已移除旧版词书 $bookId');
    }
  }

  static Future<void> _importBookAssetIfNeeded(String assetPath) async {
    try {
      final jsonStr = await rootBundle.loadString(assetPath);
      final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
      attachBookIds(book);

      final existing = _books.get(book.bookId);
      if (existing != null && !bookNeedsRichContentRefresh(existing)) {
        return;
      }

      if (existing != null) {
        preserveWordLearningState(from: existing, into: book);
      }

      await saveBook(book);
      debugPrint(
        existing == null
            ? '✅ 词书导入成功，共 ${book.words.length} 个单词（bookId: ${book.bookId}）'
            : '✅ 词书内容已更新为富内容格式，共 ${book.words.length} 个单词（bookId: ${book.bookId}）',
      );
    } catch (e, stackTrace) {
      debugPrint('❌ 导入 $assetPath 失败: $e');
      debugPrint('$stackTrace');
    }
  }

  static Future<void> seedDefaultSettingsIfNeeded() async {
    if (_settings.containsKey(settingsKey)) {
      return;
    }

    final settings = UserSettings();
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

  static LevelStudyProgress? getLevelStudyProgress(
    String bookId,
    int levelIndex,
  ) {
    return _levelStudy.get(levelStudyStorageKey(bookId, levelIndex));
  }

  static Map<int, LevelStudyProgress> getLevelStudyProgressForBook(
    String bookId,
  ) {
    return {
      for (final item in _levelStudy.values.where((entry) => entry.bookId == bookId))
        item.levelIndex: item,
    };
  }

  static Future<void> saveLevelStudyProgress(
    LevelStudyProgress progress,
  ) async {
    await _levelStudy.put(progress.storageKey, progress);
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