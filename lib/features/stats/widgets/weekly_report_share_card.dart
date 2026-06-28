import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/stats_repository.dart';
import 'weekly_report_mini_chart.dart';

class WeeklyReportShareCard extends StatelessWidget {
  const WeeklyReportShareCard({
    super.key,
    required this.summary,
    required this.masteredWords,
    required this.currentStreak,
    this.weekStats,
  });

  final SessionSummary summary;
  final int masteredWords;
  final int currentStreak;
  final List<DailyStudyStat>? weekStats;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final hasChart =
        weekStats != null && weekStats!.any((stat) => stat.count > 0);

    return Material(
      color: const Color(0xFF1B5E20),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.school, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'VocabMaster',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '本周学习周报 · $dateLabel',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _StatBlock(
              label: '学习次数',
              value: '${summary.totalSessions} 次',
            ),
            const SizedBox(height: 12),
            _StatBlock(
              label: '学习词数',
              value: '${summary.totalWordsStudied} 词',
            ),
            const SizedBox(height: 12),
            _StatBlock(
              label: '平均正确率',
              value: '${(summary.accuracy * 100).round()}%',
            ),
            const SizedBox(height: 12),
            _StatBlock(
              label: '已掌握 / 连续打卡',
              value: '$masteredWords 词 · $currentStreak 天',
            ),
            if (hasChart) ...[
              const SizedBox(height: 20),
              WeeklyReportMiniChart(stats: weekStats!),
            ],
            const SizedBox(height: 20),
            Text(
              summary.totalSessions == 0
                  ? '本周尚未学习，继续加油！'
                  : '坚持学习，词汇量稳步提升 📚',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}