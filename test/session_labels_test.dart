import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/session_labels.dart';

void main() {
  test('session type labels are human readable', () {
    expect(sessionTypeLabel('flashcard'), '选择题');
    expect(sessionTypeLabel('quiz'), '选择题');
    expect(sessionTypeLabel('complete'), 'complete');
    expect(sessionTypeLabel('review_complete'), 'review_complete');
    expect(sessionTypeLabel('review_quiz'), '复习 · 选择题');
    expect(sessionTypeLabel('listening'), '听音选义');
    expect(sessionTypeLabel('review_listening'), '复习 · 听音选义');
    expect(sessionTypeLabel('wrong_book'), '错题本专项');
    expect(sessionTypeLabel('practice_spelling'), '专项 · 拼写练习');
  });
}