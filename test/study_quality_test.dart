import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/study_quality.dart';

void main() {
  test('StudyQuality.fromValue maps rating values', () {
    expect(StudyQuality.fromValue(0), StudyQuality.again);
    expect(StudyQuality.fromValue(1), isNull);
    expect(StudyQuality.fromValue(2), StudyQuality.good);
    expect(StudyQuality.fromValue(3), StudyQuality.good);
    expect(StudyQuality.fromValue(9), StudyQuality.good);
  });

  test('StudyQuality exposes again and good choices', () {
    expect(StudyQuality.values, [StudyQuality.again, StudyQuality.good]);
    expect(StudyQuality.again.label, '答错');
    expect(StudyQuality.good.label, '答对');
  });
}