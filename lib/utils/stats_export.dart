import 'dart:convert';

import '../core/achievements.dart';
import '../models/learning_session.dart';
import '../models/user_settings.dart';
import '../repositories/book_repository.dart';
import '../repositories/stats_repository.dart';

class StatsExportCodec {
  static String encode({
    required UserSettings settings,
    required List<BookProgress> books,
    required SessionSummary summary7,
    required SessionSummary summary30,
    required List<LearningSession> recentSessions,
    required int totalWordsStudied,
    required List<AchievementStatus> achievements,
  }) {
    final masteredWords =
        books.fold<int>(0, (sum, item) => sum + item.masteredWords);
    final learnedWords =
        books.fold<int>(0, (sum, item) => sum + item.learnedWords);

    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'profile': {
        'dailyGoal': settings.dailyGoal,
        'currentStreak': settings.currentStreak,
        'longestStreak': settings.longestStreak,
        'defaultStudyMode': settings.defaultStudyMode,
      },
      'overview': {
        'totalWords': books.fold<int>(0, (sum, item) => sum + item.totalWords),
        'learnedWords': learnedWords,
        'masteredWords': masteredWords,
        'totalWordsStudied': totalWordsStudied,
        'unlockedAchievements': settings.unlockedAchievementIds.length,
      },
      'last7Days': {
        'sessions': summary7.totalSessions,
        'wordsStudied': summary7.totalWordsStudied,
        'accuracy': summary7.accuracy,
      },
      'last30Days': {
        'sessions': summary30.totalSessions,
        'wordsStudied': summary30.totalWordsStudied,
        'accuracy': summary30.accuracy,
      },
      'books': books
          .map(
            (progress) => {
              'title': progress.book.title,
              'category': progress.book.category,
              'totalWords': progress.totalWords,
              'learnedWords': progress.learnedWords,
              'masteredWords': progress.masteredWords,
              'masteryRate': progress.masteryRate,
            },
          )
          .toList(),
      'achievements': achievements
          .map(
            (status) => {
              'id': status.achievement.id,
              'title': status.achievement.title,
              'unlocked': status.unlocked,
            },
          )
          .toList(),
      'recentSessions': recentSessions
          .take(20)
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