import '../core/hive/hive_service.dart';
import '../models/learning_session.dart';
import '../models/review_record.dart';
import '../models/user_settings.dart';
import '../utils/overview_stats.dart';

class SettingsRepository {
  Future<UserSettings> getSettings() async {
    return HiveService.getSettings();
  }

  Future<void> saveSettings(UserSettings settings) async {
    await HiveService.saveSettings(settings);
  }

  Future<int> getTodayStudyCount() async {
    return countTodayStudiedWords(HiveService.getAllReviewRecords());
  }

  Future<void> recordStudyDay(UserSettings settings) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastStudy = settings.lastStudyDate;

    if (lastStudy != null) {
      final lastDay =
          DateTime(lastStudy.year, lastStudy.month, lastStudy.day);
      if (lastDay == today) {
        return;
      }
      final diff = today.difference(lastDay).inDays;
      if (diff == 1) {
        settings.currentStreak += 1;
      } else {
        settings.currentStreak = 1;
      }
    } else {
      settings.currentStreak = 1;
    }

    if (settings.currentStreak > settings.longestStreak) {
      settings.longestStreak = settings.currentStreak;
    }
    settings.lastStudyDate = now;
    await saveSettings(settings);
  }

  Future<List<ReviewRecord>> getReviewRecordsForWord(
    String wordId, {
    int limit = 20,
  }) async {
    return HiveService.getAllReviewRecords()
        .where((record) => record.wordId == wordId)
        .take(limit)
        .toList();
  }

  Future<List<ReviewRecord>> getReviewRecordsForSession(
    LearningSession session,
  ) async {
    final end = session.completedAt ?? DateTime.now();
    return HiveService.getAllReviewRecords()
        .where(
          (record) =>
              record.reviewedAt.isAfter(
                session.startedAt.subtract(const Duration(microseconds: 1)),
              ) &&
              record.reviewedAt.isBefore(end.add(const Duration(seconds: 1))),
        )
        .toList()
      ..sort((a, b) => a.reviewedAt.compareTo(b.reviewedAt));
  }

  Future<void> addReviewRecord(ReviewRecord record) async {
    await HiveService.saveReviewRecord(record);
  }

  Future<void> clearReviewRecords() async {
    await HiveService.clearReviewRecords();
  }

  Future<void> resetStreak(UserSettings settings) async {
    settings
      ..currentStreak = 0
      ..longestStreak = 0
      ..lastStudyDate = null;
    await saveSettings(settings);
  }
}