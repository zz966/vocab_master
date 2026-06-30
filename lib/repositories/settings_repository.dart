import '../core/hive/hive_service.dart';
import '../models/answer_record.dart';
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
    return countTodayStudiedWords(HiveService.getAllAnswerRecords());
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
        settings.studyStreak += 1;
      } else {
        settings.studyStreak = 1;
      }
    } else {
      settings.studyStreak = 1;
    }

    if (settings.studyStreak > settings.longestStudyStreak) {
      settings.longestStudyStreak = settings.studyStreak;
    }
    settings.lastStudyDate = now;
    await saveSettings(settings);
  }

  Future<void> upsertTodayAnswerRecord({
    required String wordId,
    String? bookId,
  }) async {
    final now = DateTime.now();
    final existing = _findTodayAnswerForWord(wordId, now: now);

    if (existing != null) {
      existing.answeredAt = now;
      if (bookId != null) {
        existing.bookId = bookId;
      }
      await HiveService.saveAnswerRecord(existing);
      return;
    }

    await HiveService.saveAnswerRecord(
      AnswerRecord(
        id: HiveService.nextId('answer'),
        wordId: wordId,
        bookId: bookId,
        answeredAt: now,
      ),
    );
  }

  AnswerRecord? _findTodayAnswerForWord(
    String wordId, {
    required DateTime now,
  }) {
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    for (final record in HiveService.getAllAnswerRecords()) {
      if (record.wordId != wordId) {
        continue;
      }
      if (!record.answeredAt.isBefore(startOfDay) &&
          record.answeredAt.isBefore(endOfDay)) {
        return record;
      }
    }
    return null;
  }
}