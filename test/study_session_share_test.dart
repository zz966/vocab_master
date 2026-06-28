import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/study_session_share.dart';

void main() {
  test('formatStudySessionShareText summarizes session result', () {
    final text = formatStudySessionShareText(
      totalWords: 20,
      correctCount: 16,
      sessionType: 'flashcard',
      todayCount: 25,
      dailyGoal: 20,
      currentStreak: 5,
    );

    expect(text, contains('学习完成'));
    expect(text, contains('速刷学习'));
    expect(text, contains('20 词'));
    expect(text, contains('80%'));
    expect(text, contains('25/20'));
    expect(text, contains('连续 5 天'));
  });
}
