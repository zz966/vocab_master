import 'package:flutter/material.dart';

import '../../../models/check_in_result.dart';
import 'check_in_calendar.dart';

class DailyCheckInCard extends StatelessWidget {
  const DailyCheckInCard({
    super.key,
    required this.status,
    required this.isLoading,
    required this.onCheckIn,
  });

  final CheckInStatus status;
  final bool isLoading;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '每日签到',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              status.checkedInToday
                  ? '已签到 ✓ · 连续 ${status.streak} 天'
                  : '签到领取积分，连续签到天数会累计',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            CheckInCalendar(checkInDates: status.recentCheckInDates),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: status.checkedInToday || isLoading ? null : onCheckIn,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      status.checkedInToday
                          ? Icons.check_circle_outline
                          : Icons.event_available_outlined,
                    ),
              label: Text(
                status.checkedInToday ? '已签到 ✓' : '立即签到',
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
            if (status.longestStreak > 0) ...[
              const SizedBox(height: 12),
              Text(
                '最长连续签到 ${status.longestStreak} 天',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}