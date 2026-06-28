import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/stats_repository.dart';

class StudyHeatmap extends StatelessWidget {
  const StudyHeatmap({
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
    if (stats.isEmpty) {
      return const SizedBox.shrink();
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
              '近 30 日打卡热力',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: stats.map((stat) {
                final intensity =
                    maxCount == 0 ? 0.0 : stat.count / maxCount;
                final color = _cellColor(context, intensity, stat.count);

                final cell = Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                    border: stat.count == 0
                        ? Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant
                                .withValues(alpha: 0.5),
                          )
                        : null,
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
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '少',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 6),
                ...List.generate(4, (index) {
                  final intensity = index / 3;
                  return Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _cellColor(
                          context,
                          intensity,
                          intensity == 0 ? 0 : 1,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 6),
                Text(
                  '多',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}