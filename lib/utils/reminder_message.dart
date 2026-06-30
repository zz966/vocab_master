import '../repositories/settings_repository.dart';

String formatDailyReport({
  required int todayCount,
  required int studyStreak,
}) {
  final parts = <String>['📚 每日学习提醒'];

  if (todayCount > 0) {
    parts.add('今日已学 $todayCount 词');
  } else {
    parts.add('今日尚未学习');
  }

  parts.add('🔥 连续学习 $studyStreak 天');
  return parts.join(' · ');
}

Future<String> buildDailyReminderMessage({
  required SettingsRepository settingsRepository,
}) async {
  final settings = await settingsRepository.getSettings();
  final todayCount = await settingsRepository.getTodayStudyCount();

  return formatDailyReport(
    todayCount: todayCount,
    studyStreak: settings.studyStreak,
  );
}