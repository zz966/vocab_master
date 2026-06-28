import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/stats_repository.dart';

class BookStudyBarChart extends StatelessWidget {
  const BookStudyBarChart({
    super.key,
    required this.stats,
    this.barColor,
  });

  final List<DailyStudyStat> stats;
  final Color? barColor;

  @override
  Widget build(BuildContext context) {
    if (stats.every((stat) => stat.count == 0)) {
      return const SizedBox.shrink();
    }

    final maxCount = stats.fold<int>(
      0,
      (max, item) => item.count > max ? item.count : max,
    );
    final chartMaxY = (maxCount + 2).toDouble();
    final color = barColor ?? Theme.of(context).colorScheme.primary;
    final totalWords = stats.fold<int>(0, (sum, stat) => sum + stat.count);

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
                    '近 30 日学习柱状图',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '共 $totalWords 词',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  maxY: chartMaxY < 4 ? 4 : chartMaxY,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 ||
                              index >= stats.length ||
                              index % 5 != 0) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              DateFormat('M/d').format(stats[index].date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < stats.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: stats[i].count.toDouble(),
                            color: color,
                            width: 6,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}