import 'package:flutter/material.dart';

import '../../../core/study_mode.dart';

Future<StudyMode?> showChallengeModePicker(BuildContext context) {
  return showDialog<StudyMode>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        title: const Text('选择测试模式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '通关1种模式,奖励 1 个星星',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...levelChallengeModes.map(
              (mode) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ModeOptionTile(
                  mode: mode,
                  onTap: () => Navigator.of(context).pop(mode),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      );
    },
  );
}

class _ModeOptionTile extends StatelessWidget {
  const _ModeOptionTile({
    required this.mode,
    required this.onTap,
  });

  final StudyMode mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(
                _iconForMode(mode),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mode.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _iconForMode(StudyMode mode) {
  return switch (mode) {
    StudyMode.quiz => Icons.quiz_outlined,
    StudyMode.spelling => Icons.spellcheck_outlined,
    StudyMode.listening => Icons.hearing_outlined,
    _ => Icons.school_outlined,
  };
}