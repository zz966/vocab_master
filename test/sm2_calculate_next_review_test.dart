import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/sm2_algorithm.dart';

void main() {
  final now = DateTime(2026, 6, 16, 10);

  test('calculateNextReview advances familiarity on Good', () {
    final result = Sm2Algorithm.calculateNextReview(
      2,
      rating: 'Good',
      now: now,
    );

    expect(result['familiarity'], 3);
    expect(result['nextReview'], isA<DateTime>());
    expect((result['nextReview'] as DateTime).isAfter(now), isTrue);
    expect(result['interval'], greaterThan(0));
  });

  test('calculateNextReview schedules forgotten words soon', () {
    final result = Sm2Algorithm.calculateNextReview(
      4,
      rating: 'Forgot',
      now: now,
    );

    expect(result['familiarity'], 3);
    expect(result['repetitions'], 0);
    expect(result['interval'], 0);
    expect(result['nextReview'], now.add(const Duration(minutes: 10)));
  });

  test('calculateNextReview schedules unsure words later today', () {
    final result = Sm2Algorithm.calculateNextReview(4, rating: '模糊', now: now);

    expect(result['familiarity'], 4);
    expect(result['repetitions'], 0);
    expect(result['interval'], 0.25);
    expect(result['nextReview'], now.add(const Duration(hours: 6)));
  });

  test('calculateNextReview supports Easy with larger familiarity bump', () {
    final result = Sm2Algorithm.calculateNextReview(
      1,
      rating: 'Easy',
      now: now,
    );

    expect(result['familiarity'], 3);
    expect(result['quality'], 3);
  });

  test('calculateNextReview rejects unknown rating', () {
    expect(
      () => Sm2Algorithm.calculateNextReview(1, rating: 'Perfect'),
      throwsArgumentError,
    );
  });

  test('calculateNextReview is case-insensitive', () {
    final lower = Sm2Algorithm.calculateNextReview(2, rating: 'hard', now: now);
    final upper = Sm2Algorithm.calculateNextReview(2, rating: 'Hard', now: now);

    expect(lower['familiarity'], upper['familiarity']);
    expect(lower['quality'], 1);
  });

  test('calculateNextReview accepts Chinese feedback labels', () {
    final result = Sm2Algorithm.calculateNextReview(2, rating: '记住了', now: now);

    expect(result['quality'], 2);
    expect(result['familiarity'], 3);
  });
}
