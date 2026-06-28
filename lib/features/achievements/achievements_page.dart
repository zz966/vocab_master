import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/achievements_provider.dart';
import '../../utils/achievements_share.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习成就'),
        actions: [
          achievementsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (snapshot) => IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: '分享成就',
              onPressed: () => shareAchievements(snapshot),
            ),
          ),
        ],
      ),
      body: achievementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (snapshot) {
          final progress = snapshot.totalCount == 0
              ? 0.0
              : snapshot.unlockedCount / snapshot.totalCount;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(achievementsProvider);
              await ref.read(achievementsProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '${snapshot.unlockedCount} / ${snapshot.totalCount}',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        const Text('已解锁成就'),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...snapshot.statuses.map((status) {
                  final achievement = status.achievement;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: status.unlocked
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        child: Icon(
                          achievement.icon,
                          color: status.unlocked
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      title: Text(
                        achievement.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: status.unlocked
                              ? null
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      subtitle: Text(achievement.description),
                      trailing: status.unlocked
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : const Icon(Icons.lock_outline),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}