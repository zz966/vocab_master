import 'package:flutter/material.dart';

import '../../../core/points_constants.dart';
import '../../../utils/check_in_utils.dart';

class CheckInCalendar extends StatelessWidget {
  const CheckInCalendar({
    super.key,
    required this.checkInDates,
  });

  final List<String> checkInDates;

  static const _weekdayLabels = ['一', '二', '三', '四', '五', '六', '日'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = recentCalendarDays(
      count: PointsConstants.checkInCalendarDays,
    );

    return Row(
      children: List.generate(days.length, (index) {
        final day = days[index];
        final checkedIn = checkInDates.contains(formatCheckInDate(day));
        final isToday = isSameDay(day, DateTime.now());

        return Expanded(
          child: Column(
            children: [
              Text(
                _weekdayLabels[day.weekday - 1],
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: checkedIn
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: isToday
                      ? Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: checkedIn
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: theme.colorScheme.onPrimary,
                      )
                    : Text(
                        '${day.day}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isToday
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }
}