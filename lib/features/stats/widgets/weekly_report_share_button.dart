import 'package:flutter/material.dart';

import '../../../repositories/stats_repository.dart';
import '../../../utils/weekly_report_share.dart';

class WeeklyReportShareButton extends StatelessWidget {
  const WeeklyReportShareButton({
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
    return IconButton(
      icon: const Icon(Icons.share_outlined),
      tooltip: '分享周报',
      onPressed: () => showWeeklyReportShareSheet(
        context: context,
        summary: summary,
        masteredWords: masteredWords,
        currentStreak: currentStreak,
        weekStats: weekStats,
      ),
    );
  }
}