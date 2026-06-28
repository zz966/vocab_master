import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/stats_repository.dart';

class BookAccuracyTrendChart extends StatelessWidget {
  const BookAccuracyTrendChart({
    super.key,
    required this.stats,
    this.lineColor,
  });

  final List<DailyAccuracyStat> stats;
  final Color? lineColor;

  @override
  Widget build(BuildContext context) {
    if (stats.every((stat) => stat.studied == 0)) {
      return const SizedBox.shrink();
    }

    final color = lineColor ?? Theme.of(context).colorScheme.secondary;
    final studiedDays = stats.where((stat) => stat.studied > 0).length;
    final avgAccuracy = stats
            .where((stat) => stat.studied > 0)
            .fold<double>(0, (sum, stat) => sum + stat.accuracy) /
        studiedDays;

    final spots = [
      for (var i = 0; i < stats.length; i++)
        FlSpot(i.toDouble(), stats[i].accuracy * 100),
    ];

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
                    '近 7 日正确率趋势',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '均值 ${(avgAccuracy * 100).round()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (stats.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          if (value % 50 != 0) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
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
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= stats.length) {
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
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          final studied = stats[index].studied;
                          return FlDotCirclePainter(
                            radius: studied == 0 ? 0 : 3,
                            color: color,
                            strokeWidth: 0,
                          );
                        },
                      ),
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