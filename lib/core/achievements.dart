import 'package:flutter/material.dart';

class AchievementContext {
  const AchievementContext({
    required this.currentStreak,
    required this.longestStreak,
    required this.masteredWords,
    required this.completedSessions,
    required this.totalWordsStudied,
    required this.favoritesCount,
    required this.sessionTypes,
  });

  final int currentStreak;
  final int longestStreak;
  final int masteredWords;
  final int completedSessions;
  final int totalWordsStudied;
  final int favoritesCount;
  final Set<String> sessionTypes;
}

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool Function(AchievementContext ctx) isUnlocked;
}

class AchievementStatus {
  const AchievementStatus({required this.achievement, required this.unlocked});

  final Achievement achievement;
  final bool unlocked;
}

class AchievementSnapshot {
  const AchievementSnapshot({
    required this.statuses,
    required this.unlockedCount,
    required this.totalCount,
  });

  final List<AchievementStatus> statuses;
  final int unlockedCount;
  final int totalCount;
}

const studyModeTypes = {
  'quiz',
  'spelling',
  'listening',
};

final allAchievements = <Achievement>[
  Achievement(
    id: 'first_session',
    title: '初次启程',
    description: '完成第一次学习',
    icon: Icons.flag,
    isUnlocked: (ctx) => ctx.completedSessions >= 1,
  ),
  Achievement(
    id: 'streak_3',
    title: '三日坚持',
    description: '连续打卡 3 天',
    icon: Icons.local_fire_department,
    isUnlocked: (ctx) => ctx.currentStreak >= 3 || ctx.longestStreak >= 3,
  ),
  Achievement(
    id: 'streak_7',
    title: '一周达人',
    description: '连续打卡 7 天',
    icon: Icons.whatshot,
    isUnlocked: (ctx) => ctx.currentStreak >= 7 || ctx.longestStreak >= 7,
  ),
  Achievement(
    id: 'streak_30',
    title: '月度学霸',
    description: '连续打卡 30 天',
    icon: Icons.emoji_events,
    isUnlocked: (ctx) => ctx.currentStreak >= 30 || ctx.longestStreak >= 30,
  ),
  Achievement(
    id: 'master_50',
    title: '词汇新手',
    description: '掌握 50 个单词',
    icon: Icons.school,
    isUnlocked: (ctx) => ctx.masteredWords >= 50,
  ),
  Achievement(
    id: 'master_200',
    title: '词汇能手',
    description: '掌握 200 个单词',
    icon: Icons.auto_stories,
    isUnlocked: (ctx) => ctx.masteredWords >= 200,
  ),
  Achievement(
    id: 'study_500',
    title: '勤学苦练',
    description: '累计学习 500 个词次',
    icon: Icons.fitness_center,
    isUnlocked: (ctx) => ctx.totalWordsStudied >= 500,
  ),
  Achievement(
    id: 'study_2000',
    title: '词汇狂人',
    description: '累计学习 2000 个词次',
    icon: Icons.bolt,
    isUnlocked: (ctx) => ctx.totalWordsStudied >= 2000,
  ),
  Achievement(
    id: 'favorites_10',
    title: '收藏达人',
    description: '收藏 10 个单词',
    icon: Icons.favorite,
    isUnlocked: (ctx) => ctx.favoritesCount >= 10,
  ),
  Achievement(
    id: 'all_modes',
    title: '全能选手',
    description: '体验全部 5 种学习模式',
    icon: Icons.grid_view,
    isUnlocked: (ctx) => studyModeTypes.every(ctx.sessionTypes.contains),
  ),
];

List<AchievementStatus> evaluateAchievements(AchievementContext context) {
  return allAchievements
      .map(
        (achievement) => AchievementStatus(
          achievement: achievement,
          unlocked: achievement.isUnlocked(context),
        ),
      )
      .toList();
}

int countUnlockedAchievements(List<AchievementStatus> statuses) {
  return statuses.where((status) => status.unlocked).length;
}

Achievement? findAchievement(String id) {
  for (final achievement in allAchievements) {
    if (achievement.id == id) {
      return achievement;
    }
  }
  return null;
}

List<Achievement> achievementsFromIds(List<String> ids) {
  return [
    for (final id in ids)
      if (findAchievement(id) != null) findAchievement(id)!,
  ];
}
