import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/achievements.dart';

void main() {
  group('evaluateAchievements', () {
    test('unlocks streak and study achievements', () {
      const context = AchievementContext(
        currentStreak: 7,
        longestStreak: 10,
        masteredWords: 120,
        completedSessions: 5,
        totalWordsStudied: 600,
        favoritesCount: 12,
        sessionTypes: {
          'flashcard',
          'complete',
          'quiz',
          'spelling',
          'listening',
        },
      );

      final statuses = evaluateAchievements(context);
      final unlocked = statuses
          .where((status) => status.unlocked)
          .map((status) => status.achievement.id)
          .toSet();

      expect(
        unlocked,
        containsAll([
          'first_session',
          'streak_3',
          'streak_7',
          'master_50',
          'study_500',
          'favorites_10',
          'all_modes',
        ]),
      );
      expect(countUnlockedAchievements(statuses), 7);
    });

    test('returns zero unlocked for fresh user', () {
      const context = AchievementContext(
        currentStreak: 0,
        longestStreak: 0,
        masteredWords: 0,
        completedSessions: 0,
        totalWordsStudied: 0,
        favoritesCount: 0,
        sessionTypes: {},
      );

      expect(countUnlockedAchievements(evaluateAchievements(context)), 0);
    });
  });
}
