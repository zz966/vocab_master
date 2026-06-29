import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/session_date_filter.dart';

import 'helpers/model_fixtures.dart';

void main() {
  final now = DateTime(2026, 6, 16, 12);

  test('matchesSessionDateRange allows all dates for all range', () {
    final session = testSession(startedAt: DateTime(2020, 1, 1));
    expect(
      matchesSessionDateRange(
        session.startedAt,
        range: SessionDateRange.all,
        now: now,
      ),
      isTrue,
    );
  });

  test('matchesSessionDateRange filters last 7 days', () {
    expect(
      matchesSessionDateRange(
        testSession(startedAt: DateTime(2026, 6, 16)).startedAt,
        range: SessionDateRange.last7Days,
        now: now,
      ),
      isTrue,
    );
    expect(
      matchesSessionDateRange(
        testSession(startedAt: DateTime(2026, 6, 10)).startedAt,
        range: SessionDateRange.last7Days,
        now: now,
      ),
      isTrue,
    );
    expect(
      matchesSessionDateRange(
        testSession(startedAt: DateTime(2026, 6, 9)).startedAt,
        range: SessionDateRange.last7Days,
        now: now,
      ),
      isFalse,
    );
  });

  test('matchesSessionBookFilter matches sessions containing book id', () {
    final session = testSession(bookIds: ['book_1', 'book_3']);
    expect(matchesSessionBookFilter(session, null), isTrue);
    expect(matchesSessionBookFilter(session, 'book_1'), isTrue);
    expect(matchesSessionBookFilter(session, 'book_2'), isFalse);
  });

  test('matchesSessionDateRange filters custom range inclusively', () {
    final custom = DateTimeRange(
      start: DateTime(2026, 6, 1),
      end: DateTime(2026, 6, 10),
    );

    expect(
      matchesSessionDateRange(
        testSession(startedAt: DateTime(2026, 6, 1)).startedAt,
        range: SessionDateRange.custom,
        customRange: custom,
        now: now,
      ),
      isTrue,
    );
    expect(
      matchesSessionDateRange(
        testSession(startedAt: DateTime(2026, 6, 10, 23, 59)).startedAt,
        range: SessionDateRange.custom,
        customRange: custom,
        now: now,
      ),
      isTrue,
    );
    expect(
      matchesSessionDateRange(
        testSession(startedAt: DateTime(2026, 5, 31)).startedAt,
        range: SessionDateRange.custom,
        customRange: custom,
        now: now,
      ),
      isFalse,
    );
  });
}