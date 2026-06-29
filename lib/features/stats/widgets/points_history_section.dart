import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/point_transaction.dart';
import '../../../providers/points_provider.dart';
import '../points_history_page.dart';

class PointsHistorySection extends ConsumerWidget {
  const PointsHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(pointsHistoryProvider);

    return Card(
      margin: EdgeInsets.zero,
      child: historyAsync.when(
        loading: () => const ListTile(
          title: Text('积分明细'),
          subtitle: Text('加载中…'),
        ),
        error: (_, _) => ListTile(
          title: const Text('积分明细'),
          subtitle: const Text('加载失败，请下拉刷新'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const PointsHistoryPage(),
              ),
            );
          },
        ),
        data: (transactions) => _PointsHistoryBody(transactions: transactions),
      ),
    );
  }
}

class _PointsHistoryBody extends StatefulWidget {
  const _PointsHistoryBody({required this.transactions});

  final List<PointTransaction> transactions;

  @override
  State<_PointsHistoryBody> createState() => _PointsHistoryBodyState();
}

class _PointsHistoryBodyState extends State<_PointsHistoryBody> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasRecords = widget.transactions.isNotEmpty;

    return Column(
      children: [
        ListTile(
          title: const Text('积分明细'),
          subtitle: Text(
            hasRecords ? '最近 ${widget.transactions.length} 条记录' : '暂无记录',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasRecords)
                IconButton(
                  icon: Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  tooltip: _expanded ? '收起' : '展开',
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const PointsHistoryPage(),
              ),
            );
          },
        ),
        if (_expanded && hasRecords) ...[
          const Divider(height: 1),
          ...widget.transactions.map((item) {
            final isEarned = item.amount > 0;
            final timeLabel =
                DateFormat('M/d HH:mm').format(item.createdAt);

            return ListTile(
              dense: true,
              title: Text(item.reason),
              subtitle: Text(timeLabel),
              trailing: Text(
                '${isEarned ? '+' : ''}${item.amount}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isEarned
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
                ),
              ),
            );
          }),
        ],
      ],
    );
  }
}