import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/points_constants.dart';
import 'package:vocab_master/models/user_settings.dart';
import 'package:vocab_master/utils/check_in_utils.dart';

void main() {
  group('formatCheckInDate', () {
    test('formats date as yyyy-MM-dd', () {
      expect(
        formatCheckInDate(DateTime(2026, 3, 5)),
        '2026-03-05',
      );
    });
  });

  group('hasCheckedInToday', () {
    test('returns false when never checked in', () {
      final settings = UserSettings();
      expect(hasCheckedInToday(settings), isFalse);
    });

    test('returns true when last check-in is today', () {
      final settings = UserSettings(lastCheckInDate: DateTime.now());
      expect(hasCheckedInToday(settings), isTrue);
    });

    test('returns false when last check-in was yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final settings = UserSettings(lastCheckInDate: yesterday);
      expect(hasCheckedInToday(settings), isFalse);
    });
  });

  group('calculateNextCheckInStreak', () {
    test('starts at 1 when no previous check-in', () {
      final today = DateTime(2026, 6, 29);
      expect(
        calculateNextCheckInStreak(
          today: today,
          lastCheckIn: null,
          currentStreak: 0,
        ),
        1,
      );
    });

    test('increments when checked in yesterday', () {
      final today = DateTime(2026, 6, 29);
      final yesterday = DateTime(2026, 6, 28);
      expect(
        calculateNextCheckInStreak(
          today: today,
          lastCheckIn: yesterday,
          currentStreak: 3,
        ),
        4,
      );
    });

    test('resets to 1 when gap is more than one day', () {
      final today = DateTime(2026, 6, 29);
      final last = DateTime(2026, 6, 26);
      expect(
        calculateNextCheckInStreak(
          today: today,
          lastCheckIn: last,
          currentStreak: 5,
        ),
        1,
      );
    });

    test('keeps streak when already checked in today', () {
      final today = DateTime(2026, 6, 29);
      expect(
        calculateNextCheckInStreak(
          today: today,
          lastCheckIn: today,
          currentStreak: 7,
        ),
        7,
      );
    });
  });

  group('resolveUserLevel', () {
    test('maps points to levels', () {
      expect(resolveUserLevel(0), 1);
      expect(resolveUserLevel(199), 1);
      expect(resolveUserLevel(200), 2);
      expect(resolveUserLevel(499), 2);
      expect(resolveUserLevel(500), 3);
      expect(resolveUserLevel(2000), 5);
      expect(resolveUserLevel(3500), 6);
    });
  });

  group('trimCheckInHistory', () {
    test('keeps at most maxCheckInHistoryDays entries', () {
      final settings = UserSettings(
        checkInDates: List.generate(
          35,
          (index) => formatCheckInDate(
            DateTime(2026, 1, 1).add(Duration(days: index)),
          ),
        ),
      );

      trimCheckInHistory(settings);

      expect(
        settings.checkInDates.length,
        PointsConstants.maxCheckInHistoryDays,
      );
      expect(settings.checkInDates.first, '2026-01-06');
      expect(settings.checkInDates.last, '2026-02-04');
    });
  });

  group('recentCalendarDays', () {
    test('returns consecutive days ending at anchor', () {
      final anchor = DateTime(2026, 6, 29);
      final days = recentCalendarDays(count: 3, anchor: anchor);

      expect(days.length, 3);
      expect(days.first, DateTime(2026, 6, 27));
      expect(days.last, DateTime(2026, 6, 29));
    });
  });
}