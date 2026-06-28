import 'package:flutter/material.dart';

import '../../../repositories/stats_repository.dart';

class WeeklyReportMiniChart extends StatelessWidget {
  const WeeklyReportMiniChart({
    super.key,
    required this.stats,
    this.barColor = Colors.white,
  });

  final List<DailyStudyStat> stats;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty || stats.every((stat) => stat.count == 0)) {
      return const SizedBox.shrink();
    }

    final maxCount = stats.fold<int>(
      0,
      (max, item) => item.count > max ? item.count : max,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '近 7 日学习趋势',
          style: TextStyle(
            color: barColor.withValues(alpha: 0.75),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final stat in stats)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      height: maxCount == 0
                          ? 4
                          : (stat.count / maxCount) * 44 + 4,
                      decoration: BoxDecoration(
                        color: barColor.withValues(
                          alpha: stat.count == 0 ? 0.2 : 0.9,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}