import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'session_date_filter.dart';
import 'session_filter_prefs.dart';

enum SessionFilterChipKind { type, date, book }

class ActiveSessionFilterChip {
  const ActiveSessionFilterChip({
    required this.kind,
    required this.label,
  });

  final SessionFilterChipKind kind;
  final String label;
}

List<ActiveSessionFilterChip> buildActiveSessionFilterChips({
  required SessionFilter typeFilter,
  required SessionDateRange dateRange,
  DateTimeRange? customRange,
  String? bookTitle,
}) {
  final chips = <ActiveSessionFilterChip>[];

  if (typeFilter != SessionFilter.all) {
    chips.add(
      ActiveSessionFilterChip(
        kind: SessionFilterChipKind.type,
        label: typeFilter.label,
      ),
    );
  }

  if (dateRange != SessionDateRange.all) {
    final dateLabel = switch (dateRange) {
      SessionDateRange.last7Days => '近 7 天',
      SessionDateRange.last30Days => '近 30 天',
      SessionDateRange.custom when customRange != null =>
        '${DateFormat('M/d').format(customRange.start)}-'
            '${DateFormat('M/d').format(customRange.end)}',
      SessionDateRange.custom => '自定义时间',
      SessionDateRange.all => '全部时间',
    };
    chips.add(
      ActiveSessionFilterChip(
        kind: SessionFilterChipKind.date,
        label: dateLabel,
      ),
    );
  }

  if (bookTitle != null) {
    chips.add(
      ActiveSessionFilterChip(
        kind: SessionFilterChipKind.book,
        label: bookTitle,
      ),
    );
  }

  return chips;
}

String buildSessionFilterSummary({
  required SessionFilter typeFilter,
  required SessionDateRange dateRange,
  DateTimeRange? customRange,
  String? bookTitle,
  required int filteredCount,
  required int totalCount,
}) {
  final parts = <String>[];

  if (typeFilter != SessionFilter.all) {
    parts.add(typeFilter.label);
  }

  parts.add(switch (dateRange) {
    SessionDateRange.all => '全部时间',
    SessionDateRange.last7Days => '近 7 天',
    SessionDateRange.last30Days => '近 30 天',
    SessionDateRange.custom when customRange != null =>
      '${DateFormat('M/d').format(customRange.start)}-'
          '${DateFormat('M/d').format(customRange.end)}',
    SessionDateRange.custom => '自定义时间',
  });

  if (bookTitle != null) {
    parts.add(bookTitle);
  }

  final filters = parts.join(' · ');
  return '筛选：$filters · 显示 $filteredCount/$totalCount 条';
}

Future<void> shareSessionFilterSummary({
  required SessionFilter typeFilter,
  required SessionDateRange dateRange,
  DateTimeRange? customRange,
  String? bookTitle,
  required int filteredCount,
  required int totalCount,
}) async {
  final text = buildSessionFilterSummary(
    typeFilter: typeFilter,
    dateRange: dateRange,
    customRange: customRange,
    bookTitle: bookTitle,
    filteredCount: filteredCount,
    totalCount: totalCount,
  );
  await Share.share(text, subject: 'VocabMaster 学习记录筛选');
}

bool hasActiveSessionFilters({
  required SessionFilter typeFilter,
  required SessionDateRange dateRange,
  int? bookId,
}) {
  return typeFilter != SessionFilter.all ||
      dateRange != SessionDateRange.all ||
      bookId != null;
}