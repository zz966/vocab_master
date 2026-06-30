import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/reminder_message.dart';

void main() {
  test('formatDailyReport includes today count and streak', () {
    final message = formatDailyReport(
      todayCount: 12,
      studyStreak: 5,
    );

    expect(message, contains('每日学习提醒'));
    expect(message, contains('今日已学 12 词'));
    expect(message, contains('连续学习 5 天'));
    expect(message, isNot(contains('正确率')));
  });

  test('formatDailyReport shows empty state when no study today', () {
    final message = formatDailyReport(
      todayCount: 0,
      studyStreak: 3,
    );

    expect(message, contains('今日尚未学习'));
  });
}