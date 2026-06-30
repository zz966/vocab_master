import '../core/points_constants.dart';
import '../models/user_settings.dart';

String formatCheckInDate(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day';
}

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

bool isSameDay(DateTime left, DateTime right) {
  return dateOnly(left) == dateOnly(right);
}

bool hasCheckedInToday(UserSettings settings) {
  final lastCheckIn = settings.lastCheckInDate;
  if (lastCheckIn == null) {
    return false;
  }
  return isSameDay(lastCheckIn, DateTime.now());
}

int resolveUserLevel(int pointsBalance) {
  if (pointsBalance < 200) {
    return 1;
  }
  if (pointsBalance < 500) {
    return 2;
  }
  if (pointsBalance < 1000) {
    return 3;
  }
  if (pointsBalance < 2000) {
    return 4;
  }
  return 5 + ((pointsBalance - 2000) ~/ 1000);
}

List<DateTime> recentCalendarDays({
  int count = PointsConstants.checkInCalendarDays,
  DateTime? anchor,
}) {
  final today = dateOnly(anchor ?? DateTime.now());
  return List<DateTime>.generate(
    count,
    (index) => today.subtract(Duration(days: count - index - 1)),
  );
}

void trimCheckInHistory(UserSettings settings) {
  final uniqueDates = settings.checkInDates.toSet().toList()..sort();
  if (uniqueDates.length <= PointsConstants.maxCheckInHistoryDays) {
    settings.checkInDates = uniqueDates;
    return;
  }
  settings.checkInDates =
      uniqueDates.sublist(uniqueDates.length - PointsConstants.maxCheckInHistoryDays);
}

int calculateNextCheckInStreak({
  required DateTime today,
  DateTime? lastCheckIn,
  required int checkInStreak,
}) {
  if (lastCheckIn == null) {
    return 1;
  }

  final lastDay = dateOnly(lastCheckIn);
  if (isSameDay(lastDay, today)) {
    return checkInStreak;
  }

  final diff = today.difference(lastDay).inDays;
  if (diff == 1) {
    return checkInStreak + 1;
  }

  return 1;
}