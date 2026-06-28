import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/review_record.dart';
import '../../../utils/study_quality.dart';

class WordReviewChart extends StatelessWidget {
  const WordReviewChart({
    super.key,
    required this.records,
  });

  final List<ReviewRecord> records;

  @override
  Widget build(BuildContext context) {
    if (records.length < 2) {
      return const SizedBox.shrink();
    }

    final recent = records.take(10).toList().reversed.toList();
    final barGroups = [
      for (var i = 0; i < recent.length; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: recent[i].quality.toDouble() + 1,
              color: _colorForQuality(recent[i].quality),
              width: 14,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          ],
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '复习质量趋势',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: BarChart(
                BarChartData(
                  maxY: 4,
                  minY: 0,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          final labels = {
                            1.0: '再来',
                            2.0: '困难',
                            3.0: '良好',
                            4.0: '简单',
                          };
                          return Text(
                            labels[value] ?? '',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: barGroups,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '最近 ${recent.length} 次复习（左旧右新）',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForQuality(int quality) {
    return StudyQuality.fromValue(quality)?.color ?? Colors.grey;
  }
}