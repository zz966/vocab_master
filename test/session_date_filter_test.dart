import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/learning_session.dart';
import 'package:vocab_master/utils/session_date_filter.dart';

void main() {
  final now = DateTime(2026, 6, 16, 12);

  LearningSession sessionOn(DateTime date) {
    return LearningSession()..startedAt = date;
  }

  test('matchesSessionDateRange allows all dates for all range', () {
    final session = sessionOn(DateTime(2020, 1, 1));
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
        sessionOn(DateTime(2026, 6, 16)).startedAt,
        range: SessionDateRange.last7Days,
        now: now,
      ),
      isTrue,
    );
    expect(
      matchesSessionDateRange(
        sessionOn(DateTime(2026, 6, 10)).startedAt,
        range: SessionDateRange.last7Days,
        now: now,
      ),
      isTrue,
    );
    expect(
      matchesSessionDateRange(
        sessionOn(DateTime(2026, 6, 9)).startedAt,
        range: SessionDateRange.last7Days,
        now: now,
      ),
      isFalse,
    );
  });

  test('matchesSessionBookFilter matches sessions containing book id', () {
    final session = LearningSession()..bookIds = [1, 3];
    expect(matchesSessionBookFilter(session, null), isTrue);
    expect(matchesSessionBookFilter(session, 1), isTrue);
    expect(matchesSessionBookFilter(session, 2), isFalse);
  });

  test('matchesSessionDateRange filters custom range inclusively', () {
    final custom = DateTimeRange(
      start: DateTime(2026, 6, 1),
      end: DateTime(2026, 6, 10),
    );

    expect(
      matchesSessionDateRange(
        sessionOn(DateTime(2026, 6, 1)).startedAt,
        range: SessionDateRange.custom,
        customRange: custom,
        now: now,
      ),
      isTrue,
    );
    expect(
      matchesSessionDateRange(
        sessionOn(DateTime(2026, 6, 10, 23, 59)).startedAt,
        range: SessionDateRange.custom,
        customRange: custom,
        now: now,
      ),
      isTrue,
    );
    expect(
      matchesSessionDateRange(
        sessionOn(DateTime(2026, 5, 31)).startedAt,
        range: SessionDateRange.custom,
        customRange: custom,
        now: now,
      ),
      isFalse,
    );
  });
}