import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocab_master/utils/session_date_filter.dart';
import 'package:vocab_master/utils/session_filter_prefs.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('SessionFilterPrefs saves and restores filter state', () async {
    final customRange = DateTimeRange(
      start: DateTime(2026, 6, 1),
      end: DateTime(2026, 6, 10),
    );

    await SessionFilterPrefs.save(
      typeFilter: SessionFilter.review,
      dateRange: SessionDateRange.custom,
      bookId: 'book_3',
      customRange: customRange,
    );

    final restored = await SessionFilterPrefs.load();
    expect(restored, isNotNull);
    expect(restored!.typeFilter, SessionFilter.review);
    expect(restored.dateRange, SessionDateRange.custom);
    expect(restored.bookId, 'book_3');
    expect(restored.customRange?.start, customRange.start);
    expect(restored.customRange?.end, customRange.end);
  });

  test('SessionFilterPrefs returns null when nothing saved', () async {
    final restored = await SessionFilterPrefs.load();
    expect(restored, isNull);
  });

  test('SessionFilterPrefs clear removes saved filters', () async {
    await SessionFilterPrefs.save(
      typeFilter: SessionFilter.study,
      dateRange: SessionDateRange.last7Days,
      bookId: 'book_2',
    );
    await SessionFilterPrefs.clear();
    final restored = await SessionFilterPrefs.load();
    expect(restored, isNull);
  });
}