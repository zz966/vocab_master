import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/reminder_message.dart';

void main() {
  test('formatDailyReport includes progress and accuracy', () {
    final message = formatDailyReport(
      todayCount: 12,
      currentStreak: 5,
      todayStudied: 12,
      todayCorrect: 10,
    );

    expect(message, contains('每日学习报告'));
    expect(message, contains('今日已学 12 词'));
    expect(message, contains('正确率 83%'));
    expect(message, contains('连续 5 天'));
  });

  test('formatDailyReport shows empty state when no study today', () {
    final message = formatDailyReport(
      todayCount: 0,
      currentStreak: 3,
    );

    expect(message, contains('今日尚未学习'));
  });
}