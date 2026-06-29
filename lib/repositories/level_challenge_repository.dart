import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/hive/hive_service.dart';
import '../core/study_mode.dart';
import '../models/level_challenge_progress.dart';
import '../utils/level_challenge.dart';

class LevelChallengeRepository {
  Future<LevelChallengeProgress?> getProgress(
    String bookId,
    int levelIndex,
  ) async {
    return HiveService.getLevelChallengeProgress(bookId, levelIndex);
  }

  Future<int> getStarCount(String bookId, int levelIndex) async {
    final progress = await getProgress(bookId, levelIndex);
    if (progress == null) {
      return 0;
    }
    return calculateChallengeStars(progress.completedModes);
  }

  Future<Map<int, int>> getStarCountsForBook(String bookId) async {
    final all = HiveService.getLevelChallengeProgressForBook(bookId);
    return {
      for (final entry in all.entries)
        entry.value.levelIndex:
            calculateChallengeStars(entry.value.completedModes),
    };
  }

  Future<bool> recordPerfectCompletion({
    required String bookId,
    required int levelIndex,
    required String modeName,
  }) async {
    if (!levelChallengeModes.any((mode) => mode.name == modeName)) {
      return false;
    }

    final progress = await getProgress(bookId, levelIndex);
    final existing = progress?.completedModes ?? [];
    if (existing.contains(modeName)) {
      return false;
    }

    final updated = LevelChallengeProgress(
      bookId: bookId,
      levelIndex: levelIndex,
      completedModes: [...existing, modeName],
    );
    await HiveService.saveLevelChallengeProgress(updated);
    return true;
  }
}

final levelChallengeRepositoryProvider = Provider<LevelChallengeRepository>(
  (ref) => LevelChallengeRepository(),
);