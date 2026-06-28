import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../database/isar_service.dart';
import '../models/learning_session.dart';
import '../models/review_record.dart';
import '../models/word.dart';

class DailyStudyStat {
  const DailyStudyStat({required this.date, required this.count});

  final DateTime date;
  final int count;
}

class DailyAccuracyStat {
  const DailyAccuracyStat({
    required this.date,
    required this.studied,
    required this.accuracy,
  });

  final DateTime date;
  final int studied;
  final double accuracy;
}

class BookMasteryStat {
  const BookMasteryStat({
    required this.bookTitle,
    required this.masteryRate,
    required this.colorHex,
  });

  final String bookTitle;
  final double masteryRate;
  final String? colorHex;
}

class SessionSummary {
  const SessionSummary({
    required this.totalSessions,
    required this.totalWordsStudied,
    required this.totalWordsCorrect,
  });

  final int totalSessions;
  final int totalWordsStudied;
  final int totalWordsCorrect;

  double get accuracy =>
      totalWordsStudied == 0 ? 0 : totalWordsCorrect / totalWordsStudied;
}

class StatsRepository {
  StatsRepository(this._isar);

  final Isar _isar;

  Future<SessionSummary> getSessionSummary({int days = 7}) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final sessions = await _isar.learningSessions
        .filter()
        .startedAtGreaterThan(since)
        .findAll();

    var studied = 0;
    var correct = 0;
    for (final session in sessions) {
      studied += session.wordsStudied;
      correct += session.wordsCorrect;
    }

    return SessionSummary(
      totalSessions: sessions.length,
      totalWordsStudied: studied,
      totalWordsCorrect: correct,
    );
  }

  Future<List<DailyStudyStat>> getDailyStats({int days = 7}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stats = <DailyStudyStat>[];

    for (var i = days - 1; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final nextDay = day.add(const Duration(days: 1));
      final count = await _isar.reviewRecords
          .filter()
          .reviewedAtGreaterThan(day.subtract(const Duration(microseconds: 1)))
          .reviewedAtLessThan(nextDay)
          .count();
      stats.add(DailyStudyStat(date: day, count: count));
    }

    return stats;
  }

  Future<List<DailyStudyStat>> getLast7DaysStats() => getDailyStats(days: 7);

  Future<List<DailyStudyStat>> getLast30DaysStats() => getDailyStats(days: 30);

  Future<int> getTotalWordsStudied() async {
    return _isar.reviewRecords.count();
  }

  Future<List<DailyStudyStat>> getDailyStatsForBook(
    int bookId, {
    int days = 30,
  }) async {
    final words = await _isar.words
        .filter()
        .bookIdsElementEqualTo(bookId)
        .findAll();
    final wordIds = words.map((word) => word.id).toSet();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stats = <DailyStudyStat>[];

    for (var i = days - 1; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final nextDay = day.add(const Duration(days: 1));
      final records = await _isar.reviewRecords
          .filter()
          .reviewedAtGreaterThan(day.subtract(const Duration(microseconds: 1)))
          .reviewedAtLessThan(nextDay)
          .findAll();

      final count = records
          .where(
            (record) =>
                record.bookId == bookId || wordIds.contains(record.wordId),
          )
          .length;
      stats.add(DailyStudyStat(date: day, count: count));
    }

    return stats;
  }

  Future<List<DailyAccuracyStat>> getDailyAccuracyForBook(
    int bookId, {
    int days = 7,
  }) async {
    final words = await _isar.words
        .filter()
        .bookIdsElementEqualTo(bookId)
        .findAll();
    final wordIds = words.map((word) => word.id).toSet();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stats = <DailyAccuracyStat>[];

    for (var i = days - 1; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final nextDay = day.add(const Duration(days: 1));
      final records = await _isar.reviewRecords
          .filter()
          .reviewedAtGreaterThan(day.subtract(const Duration(microseconds: 1)))
          .reviewedAtLessThan(nextDay)
          .findAll();

      final bookRecords = records
          .where(
            (record) =>
                record.bookId == bookId || wordIds.contains(record.wordId),
          )
          .toList();
      final studied = bookRecords.length;
      final correct =
          bookRecords.where((record) => record.quality >= 2).length;

      stats.add(
        DailyAccuracyStat(
          date: day,
          studied: studied,
          accuracy: studied == 0 ? 0 : correct / studied,
        ),
      );
    }

    return stats;
  }

  Future<({int studied, int correct})> getTodayStudyStats() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final records = await _isar.reviewRecords
        .filter()
        .reviewedAtGreaterThan(startOfDay.subtract(const Duration(microseconds: 1)))
        .findAll();

    final correct = records.where((record) => record.quality >= 2).length;
    return (studied: records.length, correct: correct);
  }
}

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(IsarService.instance);
});