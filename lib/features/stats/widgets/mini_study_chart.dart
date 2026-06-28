import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../repositories/stats_repository.dart';

class MiniStudyChart extends StatelessWidget {
  const MiniStudyChart({
    super.key,
    required this.stats,
    this.height = 56,
  });

  final List<DailyStudyStat> stats;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxCount = stats.fold<int>(
      0,
      (max, item) => item.count > max ? item.count : max,
    );
    final chartMaxY = (maxCount + 1).toDouble();
    final maxY = chartMaxY < 2 ? 2.0 : chartMaxY;
    final color = Theme.of(context).colorScheme.primary;

    final spots = [
      for (var i = 0; i < stats.length; i++)
        FlSpot(i.toDouble(), stats[i].count.toDouble()),
    ];

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (stats.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
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
                  return FlDotCirclePainter(
                    radius: 2.5,
                    color: color,
                    strokeWidth: 0,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}