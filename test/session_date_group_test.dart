import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/reminder_message.dart';
import 'package:vocab_master/utils/session_date_group.dart';

import 'helpers/model_fixtures.dart';

void main() {
  group('formatSessionDateLabel', () {
    test('returns 今天 for current date', () {
      final now = DateTime.now();
      expect(formatSessionDateLabel(now), '今天');
    });

    test('returns 昨天 for previous day', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(formatSessionDateLabel(yesterday), '昨天');
    });
  });

  group('groupSessionsByDate', () {
    test('groups sessions under same date label', () {
      final day = DateTime(2026, 6, 16, 10);
      final sessions = [
        testSession(sessionType: 'quiz', startedAt: day),
        testSession(
          id: 'session_2',
          sessionType: 'quiz',
          startedAt: day.add(const Duration(hours: 2)),
        ),
      ];

      final groups = groupSessionsByDate(sessions);
      expect(groups, hasLength(1));
      expect(groups.first.sessions, hasLength(2));
    });
  });

  test('formatWeeklyReport summarizes weekly stats', () {
    final message = formatWeeklyReport(
      totalSessions: 5,
      totalWordsStudied: 120,
      accuracy: 0.85,
      masteredWords: 40,
      currentStreak: 7,
    );

    expect(message, contains('本周学习周报'));
    expect(message, contains('5 次学习'));
    expect(message, contains('正确率 85%'));
    expect(message, contains('掌握 40 词'));
  });
}