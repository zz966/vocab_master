import 'package:share_plus/share_plus.dart';

import '../core/session_labels.dart';

String formatStudySessionShareText({
  required int totalWords,
  required int correctCount,
  String? sessionType,
  int? todayCount,
  int? dailyGoal,
  int? currentStreak,
}) {
  final accuracy =
      totalWords == 0 ? 0 : (correctCount / totalWords * 100).round();
  final parts = <String>['✅ VocabMaster 学习完成'];

  if (sessionType != null) {
    parts.add(sessionTypeLabel(sessionType));
  }

  parts.add('$totalWords 词 · 正确率 $accuracy%');

  if (todayCount != null && dailyGoal != null) {
    parts.add('今日 $todayCount/$dailyGoal 词');
  }

  if (currentStreak != null && currentStreak > 0) {
    parts.add('连续 $currentStreak 天');
  }

  return parts.join(' · ');
}

Future<void> shareStudySessionResult({
  required int totalWords,
  required int correctCount,
  String? sessionType,
  int? todayCount,
  int? dailyGoal,
  int? currentStreak,
}) async {
  final text = formatStudySessionShareText(
    totalWords: totalWords,
    correctCount: correctCount,
    sessionType: sessionType,
    todayCount: todayCount,
    dailyGoal: dailyGoal,
    currentStreak: currentStreak,
  );
  await Share.share(text, subject: 'VocabMaster 学习完成');
}