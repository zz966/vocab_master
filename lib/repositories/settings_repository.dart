import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../database/isar_service.dart';
import '../models/learning_session.dart';
import '../models/review_record.dart';
import '../models/user_settings.dart';

class SettingsRepository {
  SettingsRepository(this._isar);

  final Isar _isar;

  Future<UserSettings> getSettings() async {
    final existing = await _isar.userSettings.where().anyId().findFirst();
    if (existing != null) {
      return existing;
    }

    final settings = UserSettings();
    await _isar.writeTxn(() async {
      await _isar.userSettings.put(settings);
    });
    return settings;
  }

  Future<void> saveSettings(UserSettings settings) async {
    settings.updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.userSettings.put(settings);
    });
  }

  Future<int> getTodayStudyCount() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return _isar.reviewRecords
        .filter()
        .reviewedAtGreaterThan(startOfDay)
        .count();
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
    int wordId, {
    int limit = 20,
  }) {
    return _isar.reviewRecords
        .filter()
        .wordIdEqualTo(wordId)
        .sortByReviewedAtDesc()
        .limit(limit)
        .findAll();
  }

  Future<List<ReviewRecord>> getReviewRecordsForSession(
    LearningSession session,
  ) async {
    final end = session.completedAt ?? DateTime.now();
    return _isar.reviewRecords
        .filter()
        .reviewedAtGreaterThan(
          session.startedAt.subtract(const Duration(microseconds: 1)),
        )
        .reviewedAtLessThan(end.add(const Duration(seconds: 1)))
        .sortByReviewedAt()
        .findAll();
  }

  Future<void> addReviewRecord(ReviewRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.reviewRecords.put(record);
    });
  }

  Future<void> clearReviewRecords() async {
    await _isar.writeTxn(() async {
      await _isar.reviewRecords.clear();
    });
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
  return SettingsRepository(IsarService.instance);
});