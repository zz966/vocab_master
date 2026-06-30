import 'package:flutter/material.dart';

enum BookStudyMode {
  quickBrowse,
  normal,
  challenge,
}

Future<BookStudyMode?> showBookModePicker(
  BuildContext context, {
  required String bookTitle,
}) {
  return showDialog<BookStudyMode>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        title: Text(
          bookTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '选择学习模式',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            _BookModeOptionTile(
              icon: Icons.fast_forward_outlined,
              title: '速刷模式',
              subtitle: '快速浏览词书单词列表',
              onTap: () => Navigator.of(context).pop(BookStudyMode.quickBrowse),
            ),
            const SizedBox(height: 8),
            _BookModeOptionTile(
              icon: Icons.menu_book_outlined,
              title: '正常模式',
              subtitle: '按关卡逐词学习',
              onTap: () => Navigator.of(context).pop(BookStudyMode.normal),
            ),
            const SizedBox(height: 8),
            _BookModeOptionTile(
              icon: Icons.emoji_events_outlined,
              title: '挑战模式',
              subtitle: '闯关测试，赢取星星',
              onTap: () => Navigator.of(context).pop(BookStudyMode.challenge),
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

class _BookModeOptionTile extends StatelessWidget {
  const _BookModeOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
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
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
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