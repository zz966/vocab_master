import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/achievements.dart';
import 'package:vocab_master/models/user_settings.dart';
import 'package:vocab_master/repositories/book_repository.dart';
import 'package:vocab_master/repositories/stats_repository.dart';
import 'package:vocab_master/utils/stats_export.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('StatsExportCodec produces valid JSON summary', () {
    final settings = UserSettings(
      dailyGoal: 30,
      currentStreak: 5,
      longestStreak: 10,
      defaultStudyMode: 'quiz',
      unlockedAchievementIds: ['first_session'],
    );

    final book = testBook(
      bookName: 'CET-4',
      category: 'exam',
    )
      ..totalWords = 100;

    final books = [
      BookProgress(
        book: book,
        totalWords: 100,
        masteredWords: 40,
        learnedWords: 60,
      ),
    ];

    const summary7 = SessionSummary(
      totalSessions: 3,
      totalWordsStudied: 45,
      totalWordsCorrect: 40,
    );

    final json = StatsExportCodec.encode(
      settings: settings,
      books: books,
      summary7: summary7,
      summary30: summary7,
      recentSessions: [
        testSession(
          sessionType: 'flashcard',
          wordsStudied: 10,
          wordsCorrect: 8,
        ),
      ],
      totalWordsStudied: 200,
      achievements: evaluateAchievements(
        const AchievementContext(
          currentStreak: 5,
          longestStreak: 10,
          masteredWords: 40,
          completedSessions: 3,
          totalWordsStudied: 200,
          favoritesCount: 2,
          sessionTypes: {'flashcard'},
        ),
      ),
    );

    final data = jsonDecode(json) as Map<String, dynamic>;
    expect(data['version'], 1);
    expect(data['profile']['dailyGoal'], 30);
    expect(data['overview']['masteredWords'], 40);
    expect(data['books'], hasLength(1));
    expect(data['achievements'], isA<List<dynamic>>());
  });
}