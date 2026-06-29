import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/sm2_algorithm.dart';
import 'package:vocab_master/utils/study_quality.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('SM-2 Good rating increases familiarity and schedules next review', () {
    final word = testWord(
      id: 'w1',
      english: 'hello',
      chinese: '你好',
      familiarity: 0,
    );

    final sm2 = Sm2Algorithm.calculate(
      quality: StudyQuality.good.value,
      repetitions: word.reviewCount,
      easeFactor: word.easeFactor,
      interval: word.sm2Interval,
      now: DateTime(2026, 6, 16),
    );

    word.reviewCount = sm2.repetitions;
    word.easeFactor = sm2.easeFactor;
    word.sm2Interval = sm2.interval;
    word.nextReview = sm2.nextReview;
    word.familiarity = Sm2Algorithm.nextFamiliarity(
      word.familiarity,
      StudyQuality.good.value,
    );

    expect(word.familiarity, 1);
    expect(word.reviewCount, 1);
    expect(word.sm2Interval, 1);
    expect(word.nextReview, DateTime(2026, 6, 17));
  });

  test('SM-2 forgotten rating resets repetitions and reviews soon', () {
    final word = testWord(
      id: 'w2',
      english: 'world',
      chinese: '世界',
      familiarity: 3,
      reviewCount: 2,
    )
      ..easeFactor = 2.5
      ..sm2Interval = 6;

    final sm2 = Sm2Algorithm.calculate(
      quality: StudyQuality.again.value,
      repetitions: word.reviewCount,
      easeFactor: word.easeFactor,
      interval: word.sm2Interval,
      now: DateTime(2026, 6, 16),
    );

    word.reviewCount = sm2.repetitions;
    word.sm2Interval = sm2.interval;
    word.nextReview = sm2.nextReview;
    word.familiarity = Sm2Algorithm.nextFamiliarity(
      word.familiarity,
      StudyQuality.again.value,
    );

    expect(word.familiarity, 2);
    expect(word.reviewCount, 0);
    expect(word.sm2Interval, 0);
    expect(word.nextReview, DateTime(2026, 6, 16, 0, 10));
  });

  test('calculateNextReview string API matches quality scale', () {
    final easy = Sm2Algorithm.calculateNextReview(
      1,
      rating: 'Easy',
      now: DateTime(2026, 6, 16),
    );
    final good = Sm2Algorithm.calculateNextReview(
      1,
      rating: 'Good',
      now: DateTime(2026, 6, 16),
    );

    expect(easy['familiarity'], greaterThan(good['familiarity'] as int));
    expect(easy['nextReview'], isA<DateTime>());
  });
}