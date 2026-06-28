import 'package:flutter/material.dart';

enum ReviewCompleteAction { finish, restart }

Future<ReviewCompleteAction> showReviewCompleteDialog(
  BuildContext context, {
  required int totalWords,
  required int correctCount,
  required int masteryGained,
  required int currentStreak,
}) async {
  final accuracy =
      totalWords == 0 ? 0 : (correctCount / totalWords * 100).round();

  final action = await showDialog<ReviewCompleteAction>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('复习完成'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('本次复习 $totalWords 个单词'),
          const SizedBox(height: 8),
          Text('正确 $correctCount 个 · 正确率 $accuracy%'),
          const SizedBox(height: 12),
          if (masteryGained > 0)
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '掌握词数 +$masteryGained',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            const Text('继续复习可以进一步提升掌握率'),
          if (currentStreak > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 18,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Text('连续打卡 $currentStreak 天'),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(ReviewCompleteAction.finish),
          child: const Text('完成'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(ReviewCompleteAction.restart),
          child: const Text('继续复习'),
        ),
      ],
    ),
  );

  return action ?? ReviewCompleteAction.finish;
}