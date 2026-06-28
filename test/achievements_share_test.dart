import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/achievements.dart';
import 'package:vocab_master/utils/achievements_share.dart';

Achievement sampleAchievement(String id, String title) {
  return Achievement(
    id: id,
    title: title,
    description: 'desc',
    icon: Icons.star,
    isUnlocked: (_) => true,
  );
}

void main() {
  AchievementStatus status(String id, String title, bool unlocked) {
    return AchievementStatus(
      achievement: Achievement(
        id: id,
        title: title,
        description: 'desc',
        icon: Icons.star,
        isUnlocked: (_) => unlocked,
      ),
      unlocked: unlocked,
    );
  }

  test('formatAchievementsShareText lists unlocked achievements', () {
    final snapshot = AchievementSnapshot(
      statuses: [
        status('a', '初次启程', true),
        status('b', '三日坚持', true),
        status('c', '一周达人', false),
      ],
      unlockedCount: 2,
      totalCount: 3,
    );

    final text = formatAchievementsShareText(snapshot);

    expect(text, contains('2/3'));
    expect(text, contains('初次启程'));
    expect(text, contains('三日坚持'));
    expect(text, isNot(contains('一周达人')));
  });

  test('formatRecentAchievementsShareText lists recent titles', () {
    final text = formatRecentAchievementsShareText([
      sampleAchievement('a', '初次启程'),
      sampleAchievement('b', '三日坚持'),
    ]);

    expect(text, contains('2 项'));
    expect(text, contains('初次启程'));
    expect(text, contains('三日坚持'));
  });

  test('formatAchievementsShareText handles zero unlocked', () {
    final snapshot = AchievementSnapshot(
      statuses: [status('a', '初次启程', false)],
      unlockedCount: 0,
      totalCount: 1,
    );

    final text = formatAchievementsShareText(snapshot);

    expect(text, contains('0/1'));
    expect(text, contains('继续努力'));
  });
}