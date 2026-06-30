import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/session_labels.dart';

void main() {
  test('session type labels are human readable', () {
    expect(sessionTypeLabel('quiz'), '选择题');
    expect(sessionTypeLabel('spelling'), '拼写练习');
    expect(sessionTypeLabel('listening'), '听音选义');
    expect(
      sessionTypeLabel('level_TEST_40_0_challenge_quiz'),
      '关卡 1 · 选择题',
    );
    expect(sessionTypeLabel('unknown_type'), 'unknown_type');
  });
}