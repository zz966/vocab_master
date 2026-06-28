import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/study_mode.dart';

void main() {
  group('StudyMode.fromId', () {
    test('returns matching mode for valid id', () {
      expect(StudyMode.fromId('quiz'), StudyMode.quiz);
      expect(StudyMode.fromId('complete'), StudyMode.complete);
      expect(StudyMode.fromId('listening'), StudyMode.listening);
    });

    test('falls back to flashcard for unknown id', () {
      expect(StudyMode.fromId('unknown'), StudyMode.flashcard);
      expect(StudyMode.fromId(''), StudyMode.flashcard);
    });
  });
}
