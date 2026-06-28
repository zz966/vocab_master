import 'package:flutter/material.dart';

import '../../../utils/study_session_share.dart';

enum StudyCompleteAction { finish, restart }

Future<StudyCompleteAction> showStudyCompleteDialog(
  BuildContext context, {
  required int totalWords,
  required int correctCount,
  String? sessionType,
  int? todayCount,
  int? dailyGoal,
  int? currentStreak,
}) async {
  final accuracy = totalWords == 0
      ? 0
      : (correctCount / totalWords * 100).round();
  final goalReached =
      todayCount != null && dailyGoal != null && todayCount >= dailyGoal;

  final action = await showDialog<StudyCompleteAction>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('学习完成'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('本次共学习 $totalWords 个单词'),
          const SizedBox(height: 8),
          Text('正确 $correctCount 个 · 正确率 $accuracy%'),
          if (todayCount != null && dailyGoal != null) ...[
            const SizedBox(height: 12),
            Text('今日进度：$todayCount / $dailyGoal 词'),
            if (goalReached)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '今日目标已达成！',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
          if (currentStreak != null && currentStreak > 0) ...[
            const SizedBox(height: 8),
            Text('连续打卡 $currentStreak 天'),
          ],
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => shareStudySessionResult(
            totalWords: totalWords,
            correctCount: correctCount,
            sessionType: sessionType,
            todayCount: todayCount,
            dailyGoal: dailyGoal,
            currentStreak: currentStreak,
          ),
          icon: const Icon(Icons.share_outlined),
          label: const Text('分享'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(StudyCompleteAction.finish),
          child: const Text('完成'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(StudyCompleteAction.restart),
          child: const Text('再来一轮'),
        ),
      ],
    ),
  );

  return action ?? StudyCompleteAction.finish;
}