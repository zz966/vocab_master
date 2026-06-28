import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/sm2_algorithm.dart';

void main() {
  test('SM-2 algorithm returns next review date', () {
    final result = Sm2Algorithm.calculate(
      quality: 3,
      repetitions: 1,
      easeFactor: 2.5,
      interval: 6,
      now: DateTime(2026, 6, 16),
    );

    expect(result.repetitions, 2);
    expect(result.interval, greaterThan(0));
    expect(result.nextReview.isAfter(DateTime(2026, 6, 16)), isTrue);
  });

  test('calculateNextReview returns map with nextReview and familiarity', () {
    final result = Sm2Algorithm.calculateNextReview(
      0,
      rating: 'Good',
      now: DateTime(2026, 6, 16),
    );

    expect(result['familiarity'], 1);
    expect(result['nextReview'], isA<DateTime>());
  });
}