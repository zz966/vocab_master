import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/session_date_filter.dart';
import 'package:vocab_master/utils/session_filter_prefs.dart';
import 'package:vocab_master/utils/session_filter_summary.dart';

void main() {
  test('buildSessionFilterSummary describes active filters', () {
    final summary = buildSessionFilterSummary(
      typeFilter: SessionFilter.review,
      dateRange: SessionDateRange.last7Days,
      bookTitle: 'CET-4',
      filteredCount: 5,
      totalCount: 20,
    );

    expect(summary, contains('复习'));
    expect(summary, contains('近 7 天'));
    expect(summary, contains('CET-4'));
    expect(summary, contains('5/20'));
  });

  test('hasActiveSessionFilters detects non-default state', () {
    expect(
      hasActiveSessionFilters(
        typeFilter: SessionFilter.all,
        dateRange: SessionDateRange.all,
      ),
      isFalse,
    );
    expect(
      hasActiveSessionFilters(
        typeFilter: SessionFilter.all,
        dateRange: SessionDateRange.last7Days,
        bookId: 'book_1',
      ),
      isTrue,
    );
  });

  test('buildActiveSessionFilterChips lists only active filters', () {
    final chips = buildActiveSessionFilterChips(
      typeFilter: SessionFilter.review,
      dateRange: SessionDateRange.last30Days,
      bookTitle: 'CET-6',
    );

    expect(chips, hasLength(3));
    expect(chips[0].kind, SessionFilterChipKind.type);
    expect(chips[0].label, '复习');
    expect(chips[1].kind, SessionFilterChipKind.date);
    expect(chips[1].label, '近 30 天');
    expect(chips[2].kind, SessionFilterChipKind.book);
    expect(chips[2].label, 'CET-6');
  });

  test('buildActiveSessionFilterChips omits defaults', () {
    final chips = buildActiveSessionFilterChips(
      typeFilter: SessionFilter.all,
      dateRange: SessionDateRange.all,
    );

    expect(chips, isEmpty);
  });

  test('buildSessionFilterSummary formats custom date range', () {
    final summary = buildSessionFilterSummary(
      typeFilter: SessionFilter.all,
      dateRange: SessionDateRange.custom,
      customRange: DateTimeRange(
        start: DateTime(2026, 6, 1),
        end: DateTime(2026, 6, 10),
      ),
      filteredCount: 3,
      totalCount: 10,
    );

    expect(summary, contains('6/1-6/10'));
  });
}