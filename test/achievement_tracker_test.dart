import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/achievements.dart';
import 'package:vocab_master/models/user_settings.dart';
import 'package:vocab_master/utils/achievement_tracker.dart';

void main() {
  test('collectNewAchievements records only unseen achievements', () {
    final settings = UserSettings()..unlockedAchievementIds = ['first_session'];

    final snapshot = AchievementSnapshot(
      statuses: [
        AchievementStatus(
          achievement: allAchievements.first,
          unlocked: true,
        ),
        AchievementStatus(
          achievement: allAchievements[1],
          unlocked: true,
        ),
      ],
      unlockedCount: 2,
      totalCount: 2,
    );

    final newlyUnlocked = collectNewAchievements(
      snapshot: snapshot,
      settings: settings,
    );

    expect(newlyUnlocked, hasLength(1));
    expect(newlyUnlocked.first.id, 'streak_3');
    expect(settings.unlockedAchievementIds, ['first_session', 'streak_3']);
  });
}