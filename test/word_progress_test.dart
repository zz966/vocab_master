import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/word_progress.dart';

void main() {
  test('resetWordLearningState clears SM-2 fields', () {
    final word = Word()
      ..english = 'test'
      ..chinese = '测试'
      ..bookIds = [1]
      ..familiarity = 4
      ..reviewCount = 3
      ..correctStreak = 2
      ..easeFactor = 2.8
      ..sm2Interval = 10
      ..inWrongBook = true
      ..nextReview = DateTime(2026, 6, 20);

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