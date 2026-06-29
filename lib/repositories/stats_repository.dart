import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/hive/hive_service.dart';

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
  Future<SessionSummary> getSessionSummary({int days = 7}) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final sessions = HiveService.getAllSessions()
        .where((session) => session.startedAt.isAfter(since))
        .toList();

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
      final count = HiveService.getAllReviewRecords()
          .where(
            (record) =>
                record.reviewedAt.isAfter(
                  day.subtract(const Duration(microseconds: 1)),
                ) &&
                record.reviewedAt.isBefore(nextDay),
          )
          .length;
      stats.add(DailyStudyStat(date: day, count: count));
    }

    return stats;
  }

  Future<List<DailyStudyStat>> getLast7DaysStats() => getDailyStats(days: 7);

  Future<List<DailyStudyStat>> getLast30DaysStats() => getDailyStats(days: 30);

  Future<int> getTotalWordsStudied() async {
    return HiveService.getAllReviewRecords().length;
  }

  Future<List<DailyStudyStat>> getDailyStatsForBook(
    String bookId, {
    int days = 30,
  }) async {
    final book = HiveService.getBook(bookId);
    final wordIds = book?.words.map((word) => word.id).toSet() ?? {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stats = <DailyStudyStat>[];

    for (var i = days - 1; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final nextDay = day.add(const Duration(days: 1));
      final records = HiveService.getAllReviewRecords()
          .where(
            (record) =>
                record.reviewedAt.isAfter(
                  day.subtract(const Duration(microseconds: 1)),
                ) &&
                record.reviewedAt.isBefore(nextDay),
          )
          .where(
            (record) =>
                record.bookId == bookId || wordIds.contains(record.wordId),
          )
          .toList();

      stats.add(DailyStudyStat(date: day, count: records.length));
    }

    return stats;
  }

  Future<List<DailyAccuracyStat>> getDailyAccuracyForBook(
    String bookId, {
    int days = 7,
  }) async {
    final book = HiveService.getBook(bookId);
    final wordIds = book?.words.map((word) => word.id).toSet() ?? {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stats = <DailyAccuracyStat>[];

    for (var i = days - 1; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final nextDay = day.add(const Duration(days: 1));
      final bookRecords = HiveService.getAllReviewRecords()
          .where(
            (record) =>
                record.reviewedAt.isAfter(
                  day.subtract(const Duration(microseconds: 1)),
                ) &&
                record.reviewedAt.isBefore(nextDay),
          )
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
    final records = HiveService.getAllReviewRecords()
        .where(
          (record) => record.reviewedAt.isAfter(
            startOfDay.subtract(const Duration(microseconds: 1)),
          ),
        )
        .toList();

    final correct = records.where((record) => record.quality >= 2).length;
    return (studied: records.length, correct: correct);
  }
}

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepository();
});