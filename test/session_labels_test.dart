import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/session_labels.dart';

void main() {
  test('session type labels are human readable', () {
    expect(sessionTypeLabel('flashcard'), '速刷学习');
    expect(sessionTypeLabel('complete'), '完整学习');
    expect(sessionTypeLabel('review_complete'), '复习 · 完整');
    expect(sessionTypeLabel('review_quiz'), '复习 · 选择题');
    expect(sessionTypeLabel('listening'), '听音选义');
    expect(sessionTypeLabel('review_listening'), '复习 · 听音选义');
    expect(sessionTypeLabel('wrong_book'), '错题本专项');
    expect(sessionTypeLabel('practice_spelling'), '专项 · 拼写练习');
  });
}
