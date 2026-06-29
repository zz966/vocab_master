import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/points_provider.dart';

class PointsHistoryPage extends ConsumerWidget {
  const PointsHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(allPointsHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('积分明细'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text('暂无积分记录，签到即可获得积分'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = transactions[index];
              final isEarned = item.amount > 0;
              final timeLabel =
                  DateFormat('yyyy-MM-dd HH:mm').format(item.createdAt);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: isEarned
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.errorContainer,
                  child: Icon(
                    isEarned ? Icons.add : Icons.remove,
                    color: isEarned
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                title: Text(item.reason),
                subtitle: Text(timeLabel),
                trailing: Text(
                  '${isEarned ? '+' : ''}${item.amount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isEarned
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}