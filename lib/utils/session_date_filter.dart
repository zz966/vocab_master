import 'package:flutter/material.dart';

import '../models/learning_session.dart';

enum SessionDateRange {
  all,
  last7Days,
  last30Days,
  custom,
}

extension SessionDateRangeLabel on SessionDateRange {
  String get label => switch (this) {
        SessionDateRange.all => '全部时间',
        SessionDateRange.last7Days => '近 7 天',
        SessionDateRange.last30Days => '近 30 天',
        SessionDateRange.custom => '自定义',
      };
}

bool matchesSessionDateRange(
  DateTime startedAt, {
  required SessionDateRange range,
  DateTimeRange? customRange,
  DateTime? now,
}) {
  if (range == SessionDateRange.all) {
    return true;
  }

  final reference = now ?? DateTime.now();
  final today = DateTime(reference.year, reference.month, reference.day);
  final sessionDay = DateTime(
    startedAt.year,
    startedAt.month,
    startedAt.day,
  );

  return switch (range) {
    SessionDateRange.all => true,
    SessionDateRange.last7Days =>
      !sessionDay.isBefore(today.subtract(const Duration(days: 6))),
    SessionDateRange.last30Days =>
      !sessionDay.isBefore(today.subtract(const Duration(days: 29))),
    SessionDateRange.custom => customRange == null
        ? true
        : !sessionDay.isBefore(_dayStart(customRange.start)) &&
            !sessionDay.isAfter(_dayStart(customRange.end)),
  };
}

DateTime _dayStart(DateTime date) =>
    DateTime(date.year, date.month, date.day);

bool matchesSessionBookFilter(LearningSession session, String? bookId) {
  if (bookId == null) {
    return true;
  }
  return session.bookIds.contains(bookId);
}

bool matchesSessionFilters(
  LearningSession session, {
  required bool Function(LearningSession session) typeFilter,
  required SessionDateRange dateRange,
  DateTimeRange? customRange,
  String? bookId,
  DateTime? now,
}) {
  return typeFilter(session) &&
      matchesSessionDateRange(
        session.startedAt,
        range: dateRange,
        customRange: customRange,
        now: now,
      ) &&
      matchesSessionBookFilter(session, bookId);
}