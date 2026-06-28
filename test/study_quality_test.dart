import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/study_quality.dart';

void main() {
  test('StudyQuality.fromValue maps rating values', () {
    expect(StudyQuality.fromValue(0), StudyQuality.again);
    expect(StudyQuality.fromValue(1), StudyQuality.hard);
    expect(StudyQuality.fromValue(2), StudyQuality.good);
    expect(StudyQuality.fromValue(3), StudyQuality.easy);
    expect(StudyQuality.fromValue(9), isNull);
  });

  test('feedbackValues exposes three user-facing choices', () {
    expect(StudyQuality.feedbackValues, [
      StudyQuality.again,
      StudyQuality.hard,
      StudyQuality.good,
    ]);
    expect(StudyQuality.feedbackValues.map((item) => item.label), [
      '忘了',
      '模糊',
      '记住了',
    ]);
  });
}
