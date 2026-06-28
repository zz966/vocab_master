import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/category_labels.dart';
import '../../providers/book_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/study_provider.dart';
import '../../utils/color_utils.dart';
import '../achievements/achievements_page.dart';
import '../books/book_detail_page.dart';
import '../review/review_page.dart';
import '../me/settings_page.dart';
import '../../providers/achievements_provider.dart';
import '../../providers/stats_provider.dart';
import '../../utils/achievements_share.dart';
import '../../utils/daily_report_share.dart';
import '../../utils/session_date_filter.dart';
import 'session_history_page.dart';
import 'stats_page.dart';
import 'widgets/mini_study_chart.dart';
import 'widgets/weekly_report_share_button.dart';
import 'favorites_page.dart';
import 'wrong_words_page.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(booksProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final todayCountAsync = ref.watch(todayStudyCountProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final weekSummaryAsync = ref.watch(sessionSummaryProvider);
    final weekStatsAsync = ref.watch(last7DaysStatsProvider);
    final todayStatsAsync = ref.watch(todayStudyStatsProvider);
    final reviewCountAsync = ref.watch(reviewQueueCountProvider);
    final wrongCountAsync = ref.watch(wrongBookCountProvider);
    final favoritesCountAsync = ref.watch(favoritesCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (books) {
          final settings = settingsAsync.value;
          final todayCount = todayCountAsync.value ?? 0;
          final todayStats = todayStatsAsync.value;
          final reviewCount = reviewCountAsync.value ?? 0;
          final dailyGoal = settings?.dailyGoal ?? 20;
          final totalWords =
              books.fold<int>(0, (sum, item) => sum + item.totalWords);
          final masteredWords =
              books.fold<int>(0, (sum, item) => sum + item.masteredWords);

          return RefreshIndicator(
            onRefresh: () async {
              invalidateStudyData(ref);
              await ref.read(booksProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '整体统计',
                                style:
                                    Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share_outlined),
                              tooltip: '分享今日报告',
                              visualDensity: VisualDensity.compact,
                              onPressed: () => shareDailyReport(
                                todayCount: todayCount,
                                dailyGoal: dailyGoal,
                                reviewCount: reviewCount,
                                currentStreak:
                                    settings?.currentStreak ?? 0,
                                todayStudied: todayStats?.studied,
                                todayCorrect: todayStats?.correct,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _OverviewRow(
                          label: '今日学习',
                          value: '$todayCount 词',
                        ),
                        _OverviewRow(
                          label: '连续打卡',
                          value: '${settings?.currentStreak ?? 0} 天',
                        ),
                        _OverviewRow(
                          label: '最长连续',
                          value: '${settings?.longestStreak ?? 0} 天',
                        ),
                        _OverviewRow(
                          label: '总词汇量',
                          value: '$totalWords 词',
                        ),
                        _OverviewRow(
                          label: '已掌握',
                          value: totalWords == 0
                              ? '0%'
                              : '${(masteredWords / totalWords * 100).round()}%',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                weekSummaryAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (summary) {
                    final weekStats = weekStatsAsync.value;
                    final hasActivity = summary.totalSessions > 0 ||
                        (weekStats?.any((item) => item.count > 0) ?? false);
                    if (!hasActivity) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const StatsPage(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.insights,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '本周学习简报',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              summary.totalSessions > 0
                                                  ? '${summary.totalSessions} 次学习 · '
                                                      '${summary.totalWordsStudied} 词 · '
                                                      '正确率 ${(summary.accuracy * 100).round()}%'
                                                  : '近 7 日学习趋势',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      WeeklyReportShareButton(
                                        summary: summary,
                                        masteredWords: masteredWords,
                                        currentStreak:
                                            settings?.currentStreak ?? 0,
                                        weekStats: weekStats,
                                      ),
                                      const Icon(Icons.chevron_right),
                                    ],
                                  ),
                                  if (weekStats != null &&
                                      weekStats
                                          .any((item) => item.count > 0)) ...[
                                    const SizedBox(height: 12),
                                    MiniStudyChart(stats: weekStats),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.emoji_events),
                        title: const Text('学习成就'),
                        subtitle: achievementsAsync.when(
                          loading: () => const Text('加载中…'),
                          error: (_, _) => const Text('查看已解锁的成就徽章'),
                          data: (snapshot) => Text(
                            '已解锁 ${snapshot.unlockedCount}/${snapshot.totalCount}',
                          ),
                        ),
                        trailing: achievementsAsync.when(
                          loading: () => const Icon(Icons.chevron_right),
                          error: (_, _) => const Icon(Icons.chevron_right),
                          data: (snapshot) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.share_outlined),
                                tooltip: '分享成就',
                                visualDensity: VisualDensity.compact,
                                onPressed: () => shareAchievements(snapshot),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const AchievementsPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.bar_chart),
                        title: const Text('学习统计'),
                        subtitle: const Text('近 7 日曲线 + 各书掌握率'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const StatsPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text('学习记录'),
                        subtitle: const Text('每次学习的词数与正确率'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SessionHistoryPage(
                                initialDateRange:
                                    SessionDateRange.last7Days,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '各单词书进度',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...books.map((progress) {
                  final book = progress.book;
                  final color = parseHexColor(book.coverColor);
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color,
                        child: Text(
                          book.title.isNotEmpty ? book.title[0] : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(book.title),
                      subtitle: Text(
                        '${categoryLabel(book.category)} · '
                        '${progress.learnedWords}/${progress.totalWords} 已学',
                      ),
                      trailing: Text(
                        '${(progress.masteryRate * 100).round()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                BookDetailPage(bookId: book.id),
                          ),
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.replay),
                        title: const Text('今日复习'),
                        subtitle: Text(
                          '${reviewCountAsync.valueOrNull ?? 0} 词待复习',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ReviewPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.bookmark_outline),
                        title: const Text('错题本'),
                        subtitle: Text(
                          '${wrongCountAsync.valueOrNull ?? 0} 词',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const WrongWordsPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.favorite_outline),
                        title: const Text('收藏夹'),
                        subtitle: Text(
                          '${favoritesCountAsync.valueOrNull ?? 0} 词',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const FavoritesPage(),
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.settings_outlined),
                        title: const Text('设置'),
                        subtitle: Text(
                          '每日目标 ${settings?.dailyGoal ?? 20} 词',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SettingsPage(),
                            ),
                          );
                        },
                      ),
                    ],
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

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}