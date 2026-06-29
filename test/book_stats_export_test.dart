import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/repositories/book_repository.dart';
import 'package:vocab_master/repositories/stats_repository.dart';
import 'package:vocab_master/utils/book_stats_export.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('BookStatsExportCodec produces valid JSON summary', () {
    final book = testBook(bookId: 'book_1', bookName: 'CET-4', category: 'exam');

    final progress = BookProgress(
      book: book,
      totalWords: 100,
      masteredWords: 40,
      learnedWords: 60,
    );

    final json = BookStatsExportCodec.encode(
      progress: progress,
      dailyStats: [
        DailyStudyStat(date: DateTime(2026, 6, 16), count: 12),
      ],
      accuracyStats: [
        DailyAccuracyStat(
          date: DateTime(2026, 6, 16),
          studied: 12,
          accuracy: 0.75,
        ),
      ],
      sessions: [
        testSession(
          sessionType: 'quiz',
          bookIds: ['book_1'],
          wordsStudied: 10,
          wordsCorrect: 8,
        ),
      ],
    );

    final data = jsonDecode(json) as Map<String, dynamic>;
    expect(data['version'], 1);
    expect(data['book']['title'], 'CET-4');
    expect(data['dailyStats'], hasLength(1));
    expect(data['dailyAccuracy'], hasLength(1));
    expect(data['recentSessions'], hasLength(1));
  });
}