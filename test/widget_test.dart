import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/study_progress.dart';
import 'package:vocab_master/utils/study_quality.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('StudyProgress schedules next review after good rating', () {
    final word = testWord(familiarity: 1);

    StudyProgress.applyRating(word, StudyQuality.good);

    expect(word.familiarity, 2);
    expect(word.reviewCount, 1);
    expect(StudyProgress.intervalDays(word), greaterThan(0));
    expect(word.nextReview, isNotNull);
  });

  test('StudyProgress resets streak after again rating', () {
    final word = testWord(familiarity: 3)
      ..correctStreak = 4;

    StudyProgress.applyRating(word, StudyQuality.again);

    expect(word.correctStreak, 0);
    expect(word.inWrongBook, isTrue);
    expect(StudyProgress.intervalDays(word), 0);
  });
}