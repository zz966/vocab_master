import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/book_provider.dart';
import '../../providers/recent_achievements_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/study_provider.dart';
import '../../repositories/stats_repository.dart';
import '../../utils/session_date_filter.dart';
import '../../utils/word_share.dart';
import '../achievements/achievements_page.dart';
import '../books/book_selection_page.dart';
import '../review/review_page.dart';
import '../search/global_search_page.dart';
import '../stats/favorites_page.dart';
import '../stats/session_history_page.dart';
import '../stats/widgets/mini_study_chart.dart';
import '../stats/wrong_words_page.dart';
import '../study/word_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(booksProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final todayCountAsync = ref.watch(todayStudyCountProvider);
    final reviewCountAsync = ref.watch(reviewQueueCountProvider);
    final wrongCountAsync = ref.watch(wrongBookCountProvider);
    final favoritesCountAsync = ref.watch(favoritesCountProvider);
    final wordOfDayAsync = ref.watch(wordOfTheDayProvider);
    final recentAchievementsAsync = ref.watch(recentAchievementsProvider);
    final todayStatsAsync = ref.watch(todayStudyStatsProvider);
    final weekSummaryAsync = ref.watch(sessionSummaryProvider);
    final weekStatsAsync = ref.watch(last7DaysStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VocabMaster'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const GlobalSearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: '搜索单词',
          ),
        ],
      ),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (books) {
          final settings = settingsAsync.value;
          final todayCount = todayCountAsync.value ?? 0;
          final reviewCount = reviewCountAsync.value ?? 0;
          final wrongCount = wrongCountAsync.value ?? 0;
          final favoritesCount = favoritesCountAsync.value ?? 0;
          final todayStats = todayStatsAsync.value;
          final dailyGoal = settings?.dailyGoal ?? 20;
          final progress = dailyGoal == 0 ? 0.0 : todayCount / dailyGoal;
          final currentStreak = settings?.currentStreak ?? 0;
          final selectedBookIds = ref.watch(selectedBookIdsProvider);
          final activeBookIds = selectedBookIds.isNotEmpty
              ? selectedBookIds
              : settings?.defaultBookIds ?? const <int>[];
          final activeBooks = books
              .where((item) => activeBookIds.contains(item.book.id))
              .toList();
          final featuredBooks = activeBooks.isNotEmpty
              ? activeBooks
              : books.isNotEmpty
              ? [books.first]
              : const [];
          final activeBookLabel = featuredBooks.isEmpty
              ? '选择一本词书'
              : featuredBooks.length == 1
              ? featuredBooks.first.book.title
              : '${featuredBooks.first.book.title} 等 ${featuredBooks.length} 本';
          final todayAccuracy = todayStats == null || todayStats.studied == 0
              ? null
              : (todayStats.correct / todayStats.studied * 100).round();

          return RefreshIndicator(
            onRefresh: () async {
              invalidateStudyData(ref);
              await ref.read(booksProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _TodayTaskCard(
                  bookTitle: activeBookLabel,
                  todayCount: todayCount,
                  dailyGoal: dailyGoal,
                  reviewCount: reviewCount,
                  currentStreak: currentStreak,
                  todayAccuracy: todayAccuracy,
                  progress: progress,
                  estimatedMinutes: _estimateMinutes(
                    todayCount: todayCount,
                    dailyGoal: dailyGoal,
                    reviewCount: reviewCount,
                  ),
                  onStart: () {
                    if (reviewCount > 0) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ReviewPage(),
                        ),
                      );
                      return;
                    }
                    ref.read(navigationIndexProvider.notifier).state = 2;
                  },
                  onChooseBook: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const BookSelectionPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _ActionTile(
                        icon: Icons.replay,
                        label: '复习',
                        value: '$reviewCount 词',
                        highlighted: reviewCount > 0,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ReviewPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionTile(
                        icon: Icons.bookmark_outline,
                        label: '错题本',
                        value: '$wrongCount 词',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const WrongWordsPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ActionTile(
                        icon: Icons.favorite_outline,
                        label: '收藏',
                        value: '$favoritesCount 词',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const FavoritesPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                weekSummaryAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (summary) {
                    final weekStats = weekStatsAsync.value;
                    final hasActivity =
                        summary.totalSessions > 0 ||
                        (weekStats?.any((item) => item.count > 0) ?? false);
                    if (!hasActivity) {
                      return const SizedBox.shrink();
                    }
                    return _WeeklySnapshotCard(
                      totalSessions: summary.totalSessions,
                      totalWordsStudied: summary.totalWordsStudied,
                      accuracy: summary.accuracy,
                      weekStats: weekStats,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SessionHistoryPage(
                              initialDateRange: SessionDateRange.last7Days,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                wordOfDayAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (word) {
                    if (word == null) {
                      return const SizedBox.shrink();
                    }
                    return _WordOfDayCard(
                      english: word.english,
                      chinese: word.chinese,
                      onShare: () => shareWord(word),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => WordDetailPage(wordId: word.id),
                          ),
                        );
                      },
                    );
                  },
                ),
                recentAchievementsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (achievements) {
                    if (achievements.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _RecentAchievementCard(
                        title: achievements.first.title,
                        icon: achievements.first.icon,
                        count: achievements.length,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AchievementsPage(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _SectionHeader(
                  title: '正在学习',
                  actionLabel: '管理词书',
                  onAction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const BookSelectionPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ...featuredBooks
                    .take(3)
                    .map(
                      (progress) => _BookProgressTile(
                        title: progress.book.title,
                        totalWords: progress.totalWords,
                        masteredWords: progress.masteredWords,
                        masteryRate: progress.masteryRate,
                        onTap: () {
                          ref.read(selectedBookIdsProvider.notifier).setAll([
                            progress.book.id,
                          ]);
                          ref.read(navigationIndexProvider.notifier).state = 2;
                        },
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

int _estimateMinutes({
  required int todayCount,
  required int dailyGoal,
  required int reviewCount,
}) {
  final remainingNewWords = (dailyGoal - todayCount).clamp(0, dailyGoal);
  final seconds = reviewCount > 0 ? reviewCount * 10 : remainingNewWords * 18;
  return (seconds / 60).ceil().clamp(1, 99);
}

class _TodayTaskCard extends StatelessWidget {
  const _TodayTaskCard({
    required this.bookTitle,
    required this.todayCount,
    required this.dailyGoal,
    required this.reviewCount,
    required this.currentStreak,
    required this.todayAccuracy,
    required this.progress,
    required this.estimatedMinutes,
    required this.onStart,
    required this.onChooseBook,
  });

  final String bookTitle;
  final int todayCount;
  final int dailyGoal;
  final int reviewCount;
  final int currentStreak;
  final int? todayAccuracy;
  final double progress;
  final int estimatedMinutes;
  final VoidCallback onStart;
  final VoidCallback onChooseBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final goalReached = dailyGoal > 0 && todayCount >= dailyGoal;
    final mainLabel = reviewCount > 0 ? '开始今日复习' : '开始今日学习';
    final subtitle = reviewCount > 0
        ? '先巩固 $reviewCount 个到期单词'
        : goalReached
        ? '今日目标已完成，可以加练或复盘'
        : '还差 ${(dailyGoal - todayCount).clamp(0, dailyGoal)} 个新词达成目标';

    return Card(
      margin: EdgeInsets.zero,
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: onChooseBook,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book,
                                size: 16,
                                color: colorScheme.onPrimaryContainer,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  bookTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.expand_more,
                                size: 16,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        subtitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                _EstimateBadge(minutes: estimatedMinutes),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _PlanNumber(
                    label: '需新学',
                    value: '${(dailyGoal - todayCount).clamp(0, dailyGoal)}',
                  ),
                ),
                Expanded(
                  child: _PlanNumber(label: '需复习', value: '$reviewCount'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1).toDouble(),
                minHeight: 10,
                backgroundColor: colorScheme.surface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _TaskMetric(
                    label: '新词',
                    value: '$todayCount/$dailyGoal',
                  ),
                ),
                Expanded(
                  child: _TaskMetric(label: '待复习', value: '$reviewCount'),
                ),
                Expanded(
                  child: _TaskMetric(label: '连续', value: '$currentStreak 天'),
                ),
                if (todayAccuracy != null)
                  Expanded(
                    child: _TaskMetric(label: '正确率', value: '$todayAccuracy%'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.bolt),
              label: Text(mainLabel),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstimateBadge extends StatelessWidget {
  const _EstimateBadge({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.schedule, size: 16, color: color),
          const SizedBox(height: 2),
          Text(
            '$minutes 分钟',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanNumber extends StatelessWidget {
  const _PlanNumber({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimaryContainer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: color.withValues(alpha: 0.72)),
        ),
        const SizedBox(height: 2),
        Text(
          '$value 词',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TaskMetric extends StatelessWidget {
  const _TaskMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimaryContainer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: color.withValues(alpha: 0.72)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      color: highlighted ? colorScheme.secondaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: highlighted
                    ? colorScheme.onSecondaryContainer
                    : colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeeklySnapshotCard extends StatelessWidget {
  const _WeeklySnapshotCard({
    required this.totalSessions,
    required this.totalWordsStudied,
    required this.accuracy,
    required this.weekStats,
    required this.onTap,
  });

  final int totalSessions;
  final int totalWordsStudied;
  final double accuracy;
  final List<DailyStudyStat>? weekStats;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.insights,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '本周学习',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$totalSessions 次学习 · $totalWordsStudied 词 · 正确率 ${(accuracy * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (weekStats != null &&
                  weekStats!.any((dynamic item) => item.count > 0)) ...[
                const SizedBox(height: 12),
                MiniStudyChart(stats: weekStats!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WordOfDayCard extends StatelessWidget {
  const _WordOfDayCard({
    required this.english,
    required this.chinese,
    required this.onShare,
    required this.onTap,
  });

  final String english;
  final String chinese;
  final VoidCallback onShare;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          Icons.auto_stories,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('每日一词'),
        subtitle: Text('$english · $chinese'),
        trailing: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: '分享单词',
              onPressed: onShare,
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _RecentAchievementCard extends StatelessWidget {
  const _RecentAchievementCard({
    required this.title,
    required this.icon,
    required this.count,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(count > 1 ? '最近解锁 $count 个成就' : '最近解锁的成就'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }
}

class _BookProgressTile extends StatelessWidget {
  const _BookProgressTile({
    required this.title,
    required this.totalWords,
    required this.masteredWords,
    required this.masteryRate,
    required this.onTap,
  });

  final String title;
  final int totalWords;
  final int masteredWords;
  final double masteryRate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percent = (masteryRate * 100).round();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text('$percent%'),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: masteryRate.clamp(0, 1).toDouble(),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '已掌握 $masteredWords / $totalWords 词',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
