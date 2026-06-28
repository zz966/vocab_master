import 'package:share_plus/share_plus.dart';

import 'reminder_message.dart';

Future<void> shareDailyReport({
  required int todayCount,
  required int dailyGoal,
  required int reviewCount,
  required int currentStreak,
  int? todayStudied,
  int? todayCorrect,
}) async {
  final text = formatDailyReport(
    todayCount: todayCount,
    dailyGoal: dailyGoal,
    reviewCount: reviewCount,
    currentStreak: currentStreak,
    todayStudied: todayStudied,
    todayCorrect: todayCorrect,
  );
  await Share.share(text, subject: 'VocabMaster 每日学习报告');
}