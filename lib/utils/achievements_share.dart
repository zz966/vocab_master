import 'package:share_plus/share_plus.dart';

import '../core/achievements.dart';

String formatRecentAchievementsShareText(List<Achievement> achievements) {
  final parts = <String>[
    '🏆 VocabMaster 最近成就',
    '${achievements.length} 项',
  ];

  if (achievements.isEmpty) {
    parts.add('继续努力，解锁更多成就吧');
  } else {
    parts.add(achievements.map((item) => item.title).join('、'));
  }

  return parts.join(' · ');
}

Future<void> shareRecentAchievements(List<Achievement> achievements) async {
  final text = formatRecentAchievementsShareText(achievements);
  await Share.share(text, subject: 'VocabMaster 最近成就');
}

String formatAchievementsShareText(AchievementSnapshot snapshot) {
  final parts = <String>[
    '🏆 VocabMaster 学习成就',
    '已解锁 ${snapshot.unlockedCount}/${snapshot.totalCount}',
  ];

  final unlockedTitles = snapshot.statuses
      .where((status) => status.unlocked)
      .map((status) => status.achievement.title)
      .toList();

  if (unlockedTitles.isNotEmpty) {
    parts.add(unlockedTitles.join('、'));
  } else {
    parts.add('继续努力，解锁更多成就吧');
  }

  return parts.join(' · ');
}

Future<void> shareAchievements(AchievementSnapshot snapshot) async {
  final text = formatAchievementsShareText(snapshot);
  await Share.share(text, subject: 'VocabMaster 学习成就');
}