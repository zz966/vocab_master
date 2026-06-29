import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/hive/hive_service.dart';
import '../models/learning_session.dart';
import '../models/review_record.dart';
import '../models/user_settings.dart';

class SettingsRepository {
  Future<UserSettings> getSettings() async {
    final existing = HiveService.getSettings();
    var changed = false;

    if (existing.defaultStudyMode == 'complete') {
      existing.defaultStudyMode = 'flashcard';
      changed = true;
    }

    if (changed) {
      await saveSettings(existing);
    } else if (HiveService.getAllBooks().isEmpty &&
        existing.defaultBookIds.isEmpty &&
        !existing.hasSeenOnboarding) {
      await saveSettings(existing);
    }

    return existing;
  }

  Future<void> saveSettings(UserSettings settings) async {
    await HiveService.saveSettings(settings);
  }

  Future<int> getTodayStudyCount() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return HiveService.getAllReviewRecords()
        .where((record) => record.reviewedAt.isAfter(startOfDay))
        .length;
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

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});