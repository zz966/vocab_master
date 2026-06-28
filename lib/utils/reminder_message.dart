import '../repositories/book_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/stats_repository.dart';
import '../repositories/word_repository.dart';

String formatWeeklyReport({
  required int totalSessions,
  required int totalWordsStudied,
  required double accuracy,
  required int masteredWords,
  required int currentStreak,
}) {
  final parts = <String>['📊 本周学习周报'];

  if (totalSessions == 0) {
    parts.add('本周尚未学习，现在开始吧');
  } else {
    parts.add('$totalSessions 次学习');
    parts.add('$totalWordsStudied 词');
    parts.add('正确率 ${(accuracy * 100).round()}%');
  }

  parts.add('掌握 $masteredWords 词');
  parts.add('连续 $currentStreak 天');
  return parts.join(' · ');
}

Future<String> buildWeeklyReportMessage({
  required SettingsRepository settingsRepository,
  required StatsRepository statsRepository,
  required BookRepository bookRepository,
}) async {
  final settings = await settingsRepository.getSettings();
  final summary = await statsRepository.getSessionSummary(days: 7);
  final books = await bookRepository.getAllBookProgress();
  final masteredWords =
      books.fold<int>(0, (sum, item) => sum + item.masteredWords);

  return formatWeeklyReport(
    totalSessions: summary.totalSessions,
    totalWordsStudied: summary.totalWordsStudied,
    accuracy: summary.accuracy,
    masteredWords: masteredWords,
    currentStreak: settings.currentStreak,
  );
}

String formatDailyReport({
  required int todayCount,
  required int dailyGoal,
  required int reviewCount,
  required int currentStreak,
  int? todayStudied,
  int? todayCorrect,
}) {
  final remaining = (dailyGoal - todayCount).clamp(0, dailyGoal);
  final parts = <String>['📚 每日学习报告'];

  if (remaining > 0) {
    parts.add('今日 $todayCount/$dailyGoal 词');
    parts.add('还差 $remaining 词达标');
  } else {
    parts.add('今日目标已达成 ($todayCount 词)');
  }

  if (todayStudied != null &&
      todayCorrect != null &&
      todayStudied > 0) {
    final accuracy = (todayCorrect / todayStudied * 100).round();
    parts.add('正确率 $accuracy%');
  }

  if (reviewCount > 0) {
    parts.add('$reviewCount 词待复习');
  }

  parts.add('🔥 连续 $currentStreak 天');
  return parts.join(' · ');
}

Future<String> buildDailyReminderMessage({
  required SettingsRepository settingsRepository,
  required WordRepository wordRepository,
  required BookRepository bookRepository,
  StatsRepository? statsRepository,
}) async {
  final settings = await settingsRepository.getSettings();
  final todayCount = await settingsRepository.getTodayStudyCount();

  final bookIds =
      (await bookRepository.getAllBooks()).map((book) => book.id).toList();
  final reviewCount = bookIds.isEmpty
      ? 0
      : (await wordRepository.getReviewWordsForBooks(bookIds)).length;

  int? todayStudied;
  int? todayCorrect;
  if (statsRepository != null) {
    final todayStats = await statsRepository.getTodayStudyStats();
    todayStudied = todayStats.studied;
    todayCorrect = todayStats.correct;
  }

  return formatDailyReport(
    todayCount: todayCount,
    dailyGoal: settings.dailyGoal,
    reviewCount: reviewCount,
    currentStreak: settings.currentStreak,
    todayStudied: todayStudied,
    todayCorrect: todayCorrect,
  );
}