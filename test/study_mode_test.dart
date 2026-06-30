import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/study_mode.dart';

void main() {
  group('StudyMode.fromId', () {
    test('returns matching mode for valid id', () {
      expect(StudyMode.fromId('quiz'), StudyMode.quiz);
      expect(StudyMode.fromId('complete'), StudyMode.quiz);
      expect(StudyMode.fromId('listening'), StudyMode.listening);
    });

    test('falls back to quiz for unknown id', () {
      expect(StudyMode.fromId('flashcard'), StudyMode.quiz);
      expect(StudyMode.fromId('unknown'), StudyMode.quiz);
      expect(StudyMode.fromId(''), StudyMode.quiz);
    });
  });
}