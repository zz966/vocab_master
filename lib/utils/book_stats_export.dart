import 'dart:convert';

import '../models/learning_session.dart';
import '../repositories/book_repository.dart';
import '../repositories/stats_repository.dart';

class BookStatsExportCodec {
  static String encode({
    required BookProgress progress,
    required List<DailyStudyStat> dailyStats,
    required List<DailyAccuracyStat> accuracyStats,
    required List<LearningSession> sessions,
  }) {
    final book = progress.book;
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'book': {
        'id': book.id,
        'title': book.title,
        'category': book.category,
        'totalWords': progress.totalWords,
        'learnedWords': progress.learnedWords,
        'masteredWords': progress.masteredWords,
        'masteryRate': progress.masteryRate,
      },
      'dailyStats': dailyStats
          .map(
            (stat) => {
              'date': stat.date.toIso8601String(),
              'wordsStudied': stat.count,
            },
          )
          .toList(),
      'dailyAccuracy': accuracyStats
          .map(
            (stat) => {
              'date': stat.date.toIso8601String(),
              'studied': stat.studied,
              'accuracy': stat.accuracy,
            },
          )
          .toList(),
      'recentSessions': sessions
          .map(
            (session) => {
              'type': session.sessionType,
              'wordsStudied': session.wordsStudied,
              'wordsCorrect': session.wordsCorrect,
              'startedAt': session.startedAt.toIso8601String(),
              'completedAt': session.completedAt?.toIso8601String(),
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }
}