import 'package:flutter/material.dart';

import '../../../models/quiz_session_result.dart';

enum QuizCompleteAction { finish, restart }

Future<QuizCompleteAction> showQuizCompleteDialog(
  BuildContext context, {
  required QuizSessionResult result,
}) async {
  final action = await showDialog<QuizCompleteAction>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        title: const Text('测试完成'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '共 ${result.totalWords} 题 · 答对 ${result.correctCount} 题',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '正确率 ${result.accuracyPercent}%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (result.wrongAnswers.isEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '全部答对，太棒了！',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ] else ...[
                const SizedBox(height: 16),
                Text(
                  '错题（${result.wrongAnswers.length}）',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: result.wrongAnswers.length,
                    separatorBuilder: (_, _) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final item = result.wrongAnswers[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.word.english,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '你的答案：${item.selectedAnswer}',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                          Text('正确答案：${item.correctAnswer}'),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(QuizCompleteAction.finish),
            child: const Text('完成'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(QuizCompleteAction.restart),
            child: const Text('再来一轮'),
          ),
        ],
      );
    },
  );

  return action ?? QuizCompleteAction.finish;
}