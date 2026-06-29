import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/word_progress.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('resetWordLearningState clears learning progress fields', () {
    final word = testWord(
      familiarity: 4,
      reviewCount: 3,
      nextReview: DateTime(2026, 6, 20),
    )
      ..correctStreak = 2
      ..easeFactor = 2.8
      ..sm2Interval = 10
      ..inWrongBook = true;

    resetWordLearningState(word);

    expect(word.familiarity, 0);
    expect(word.reviewCount, 0);
    expect(word.correctStreak, 0);
    expect(word.easeFactor, 2.5);
    expect(word.sm2Interval, 0);
    expect(word.inWrongBook, isFalse);
    expect(word.nextReview, isNull);
  });
}