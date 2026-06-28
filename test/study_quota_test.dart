import 'package:flutter_test/flutter_test.dart';

void main() {
  int clampRemaining(int dailyGoal, int todayCount) {
    return (dailyGoal - todayCount).clamp(0, dailyGoal);
  }

  List<int> limitWords(List<int> dueWordIds, int remaining) {
    if (remaining == 0) {
      return [];
    }
    return dueWordIds.take(remaining).toList();
  }

  test('daily quota remaining clamps at zero', () {
    expect(clampRemaining(20, 25), 0);
    expect(clampRemaining(20, 15), 5);
    expect(clampRemaining(20, 0), 20);
  });

  test('study words respect remaining daily quota', () {
    final due = List.generate(30, (index) => index);
    expect(limitWords(due, 5), [0, 1, 2, 3, 4]);
    expect(limitWords(due, 0), isEmpty);
    expect(limitWords(due, 40), due);
  });
}