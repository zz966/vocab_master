import 'package:flutter/material.dart';

import '../../../core/achievements.dart';

Future<void> showAchievementUnlockDialog(
  BuildContext context,
  List<Achievement> achievements,
) {
  if (achievements.isEmpty) {
    return Future.value();
  }

  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '成就解锁',
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _AchievementUnlockDialog(achievements: achievements);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: curved,
          child: child,
        ),
      );
    },
  );
}

class _AchievementUnlockDialog extends StatelessWidget {
  const _AchievementUnlockDialog({required this.achievements});

  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: AlertDialog(
            title: Row(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: (1 - value) * 0.5,
                      child: Transform.scale(scale: value, child: child),
                    );
                  },
                  child: Icon(
                    Icons.emoji_events,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    achievements.length == 1
                        ? '成就解锁！'
                        : '解锁 ${achievements.length} 个成就！',
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < achievements.length; i++) ...[
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 400 + i * 120),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - value) * 16),
                          child: child,
                        ),
                      );
                    },
                    child: _AchievementTile(achievement: achievements[i]),
                  ),
                  if (i < achievements.length - 1) const Divider(),
                ],
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('太棒了'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          achievement.icon,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        achievement.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(achievement.description),
    );
  }
}