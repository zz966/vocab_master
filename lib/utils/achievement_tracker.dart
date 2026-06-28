import '../core/achievements.dart';
import '../models/user_settings.dart';
import '../repositories/settings_repository.dart';

List<Achievement> collectNewAchievements({
  required AchievementSnapshot snapshot,
  required UserSettings settings,
}) {
  final newlyUnlocked = <Achievement>[];

  for (final status in snapshot.statuses) {
    if (!status.unlocked) {
      continue;
    }
    if (settings.unlockedAchievementIds.contains(status.achievement.id)) {
      continue;
    }
    settings.unlockedAchievementIds = [
      ...settings.unlockedAchievementIds,
      status.achievement.id,
    ];
    newlyUnlocked.add(status.achievement);
  }

  return newlyUnlocked;
}

Future<List<Achievement>> syncUnlockedAchievements({
  required SettingsRepository settingsRepository,
  required AchievementSnapshot snapshot,
  required UserSettings settings,
}) async {
  final newlyUnlocked = collectNewAchievements(
    snapshot: snapshot,
    settings: settings,
  );

  if (newlyUnlocked.isNotEmpty) {
    await settingsRepository.saveSettings(settings);
  }

  return newlyUnlocked;
}