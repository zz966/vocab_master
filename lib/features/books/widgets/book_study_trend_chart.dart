import 'package:flutter/material.dart';

import '../../../repositories/stats_repository.dart';
import '../../stats/widgets/mini_study_chart.dart';

class BookStudyTrendChart extends StatelessWidget {
  const BookStudyTrendChart({
    super.key,
    required this.stats,
  });

  final List<DailyStudyStat> stats;

  List<DailyStudyStat> get _weekStats {
    if (stats.length <= 7) {
      return stats;
    }
    return stats.sublist(stats.length - 7);
  }

  @override
  Widget build(BuildContext context) {
    final weekStats = _weekStats;
    if (weekStats.every((stat) => stat.count == 0)) {
      return const SizedBox.shrink();
    }

    final totalWords =
        weekStats.fold<int>(0, (sum, stat) => sum + stat.count);
    final activeDays =
        weekStats.where((stat) => stat.count > 0).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '近 7 日学习曲线',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '$totalWords 词 · $activeDays 天',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MiniStudyChart(stats: weekStats, height: 72),
          ],
        ),
      ),
    );
  }
}