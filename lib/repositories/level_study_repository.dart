import '../core/hive/hive_service.dart';
import '../models/level_study_progress.dart';
import '../utils/level_utils.dart';

class LevelStudyRepository {
  Future<LevelStudyProgress?> getProgress(
    String bookId,
    int levelIndex,
  ) async {
    return HiveService.getLevelStudyProgress(bookId, levelIndex);
  }

  Future<int> getMaxWordIndex(String bookId, int levelIndex) async {
    final progress = await getProgress(bookId, levelIndex);
    return progress?.maxWordIndex ?? -1;
  }

  Future<Map<int, int>> getProgressPercentsForBook({
    required String bookId,
    required List<BookLevel> levels,
  }) async {
    final saved = HiveService.getLevelStudyProgressForBook(bookId);
    return {
      for (final level in levels)
        level.index: levelBrowseProgressPercent(
          currentIndex: saved[level.index]?.maxWordIndex ?? -1,
          totalWords: level.wordCount,
        ),
    };
  }

  Future<void> saveMaxProgress({
    required String bookId,
    required int levelIndex,
    required int maxWordIndex,
  }) async {
    final existing = await getProgress(bookId, levelIndex);
    final currentMax = existing?.maxWordIndex ?? -1;
    if (maxWordIndex <= currentMax) {
      return;
    }

    await HiveService.saveLevelStudyProgress(
      LevelStudyProgress(
        bookId: bookId,
        levelIndex: levelIndex,
        maxWordIndex: maxWordIndex,
      ),
    );
  }
}