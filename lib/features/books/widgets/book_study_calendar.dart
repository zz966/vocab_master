import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/stats_repository.dart';

class BookStudyCalendar extends StatelessWidget {
  const BookStudyCalendar({
    super.key,
    required this.stats,
    this.onDayTap,
  });

  final List<DailyStudyStat> stats;
  final ValueChanged<DailyStudyStat>? onDayTap;

  Color _cellColor(BuildContext context, double intensity, int count) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (count == 0) {
      return isDark
          ? scheme.surfaceContainerHigh
          : scheme.surfaceContainerHighest;
    }

    if (isDark) {
      return Color.lerp(
        scheme.primary.withValues(alpha: 0.25),
        scheme.primary.withValues(alpha: 0.95),
        intensity,
      )!;
    }

    return Color.lerp(
      scheme.surfaceContainerHighest,
      scheme.primary,
      intensity,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    if (stats.every((stat) => stat.count == 0)) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '近 30 日暂无学习记录',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final maxCount = stats.fold<int>(
      0,
      (max, item) => item.count > max ? item.count : max,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '近 30 日学习日历',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: stats.map((stat) {
                final intensity =
                    maxCount == 0 ? 0.0 : stat.count / maxCount;
                final cell = Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _cellColor(context, intensity, stat.count),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );

                return Tooltip(
                  message: stat.count == 0
                      ? '${DateFormat('M/d').format(stat.date)}: 未学习'
                      : '${DateFormat('M/d').format(stat.date)}: ${stat.count} 词 · 点击查看记录',
                  child: onDayTap != null && stat.count > 0
                      ? InkWell(
                          onTap: () => onDayTap!(stat),
                          borderRadius: BorderRadius.circular(3),
                          child: cell,
                        )
                      : cell,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}