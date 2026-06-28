import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/reminder_message.dart';

void main() {
  test('formatDailyReport includes progress and accuracy', () {
    final message = formatDailyReport(
      todayCount: 12,
      dailyGoal: 20,
      reviewCount: 8,
      currentStreak: 5,
      todayStudied: 12,
      todayCorrect: 10,
    );

    expect(message, contains('每日学习报告'));
    expect(message, contains('12/20'));
    expect(message, contains('正确率 83%'));
    expect(message, contains('8 词待复习'));
    expect(message, contains('连续 5 天'));
  });

  test('formatDailyReport shows goal reached message', () {
    final message = formatDailyReport(
      todayCount: 25,
      dailyGoal: 20,
      reviewCount: 0,
      currentStreak: 3,
    );

    expect(message, contains('目标已达成'));
    expect(message, isNot(contains('待复习')));
  });
}