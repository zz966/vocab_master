import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/achievements_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/study_provider.dart';
import '../../utils/achievements_share.dart';
import '../achievements/achievements_page.dart';
import '../review/review_page.dart';
import 'favorites_page.dart';
import 'wrong_words_page.dart';
import '../../repositories/book_repository.dart';
import '../../utils/color_utils.dart';
import '../../utils/session_date_filter.dart';
import 'widgets/mini_study_chart.dart';
import 'session_history_page.dart';
import 'widgets/study_heatmap.dart';
import 'widgets/weekly_report_share_button.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(last7DaysStatsProvider);
    final stats30Async = ref.watch(last30DaysStatsProvider);
    final summaryAsync = ref.watch(sessionSummaryProvider);
    final booksAsync = ref.watch(booksProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    final reviewCountAsync = ref.watch(reviewQueueCountProvider);
    final wrongCountAsync = ref.watch(wrongBookCountProvider);
    final favoritesCountAsync = ref.watch(favoritesCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习统计'),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (stats) {
          final maxCount = stats.fold<int>(
            0,
            (max, item) => item.count > max ? item.count : max,
          );
          final chartMaxY = (maxCount + 2).toDouble();

          return RefreshIndicator(
            onRefresh: () async {
              invalidateStudyData(ref);
              ref.invalidate(last7DaysStatsProvider);
              ref.invalidate(last30DaysStatsProvider);
              ref.invalidate(sessionSummaryProvider);
              await ref.read(last7DaysStatsProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                booksAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (books) {
                    final settings = settingsAsync.valueOrNull;
                    final totalWords = books.fold<int>(
                      0,
                      (sum, item) => sum + item.totalWords,
                    );
                    final masteredWords = books.fold<int>(
                      0,
                      (sum, item) => sum + item.masteredWords,
                    );
                    final masteryPercent = totalWords == 0
                        ? 0
                        : (masteredWords / totalWords * 100).round();

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '整体掌握',
                              style:
                                  Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatChip(
                                    label: '掌握率',
                                    value: '$masteryPercent%',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _StatChip(
                                    label: '总词汇',
                                    value: '$totalWords',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _StatChip(
                                    label: '连续打卡',
                                    value:
                                        '${settings?.currentStreak ?? 0} 天',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                summaryAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (summary) {
                    final settings = settingsAsync.valueOrNull;
                    final masteredWords = booksAsync.valueOrNull?.fold<int>(
                          0,
                          (sum, item) => sum + item.masteredWords,
                        ) ??
                        0;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '近 7 日学习概览',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                WeeklyReportShareButton(
                                  summary: summary,
                                  masteredWords: masteredWords,
                                  currentStreak:
                                      settings?.currentStreak ?? 0,
                                  weekStats: statsAsync.valueOrNull,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatChip(
                                    label: '学习次数',
                                    value: '${summary.totalSessions}',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _StatChip(
                                    label: '学习词数',
                                    value: '${summary.totalWordsStudied}',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _StatChip(
                                    label: '正确率',
                                    value:
                                        '${(summary.accuracy * 100).round()}%',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text('学习记录'),
                        subtitle: const Text('查看每次学习的详细记录'),
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
                      const Divider(height: 1),
                      achievementsAsync.when(
                        loading: () => const ListTile(
                          leading: Icon(Icons.emoji_events),
                          title: Text('学习成就'),
                          subtitle: Text('加载中…'),
                        ),
                        error: (_, _) => ListTile(
                          leading: const Icon(Icons.emoji_events),
                          title: const Text('学习成就'),
                          subtitle: const Text('查看已解锁的成就徽章'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const AchievementsPage(),
                              ),
                            );
                          },
                        ),
                        data: (snapshot) => ListTile(
                          leading: const Icon(Icons.emoji_events),
                          title: const Text('学习成就'),
                          subtitle: Text(
                            '已解锁 ${snapshot.unlockedCount}/${snapshot.totalCount}',
                          ),
                          trailing: Row(
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
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const AchievementsPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
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
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '近 7 日学习曲线',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: BarChart(
                        BarChartData(
                          maxY: chartMaxY < 4 ? 4 : chartMaxY,
                          gridData: const FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= stats.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      DateFormat('M/d')
                                          .format(stats[index].date),
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: [
                            for (var i = 0; i < stats.length; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: stats[i].count.toDouble(),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 18,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                stats30Async.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (stats30) => StudyHeatmap(
                    stats: stats30,
                    onDayTap: (stat) {
                      final day = DateTime(
                        stat.date.year,
                        stat.date.month,
                        stat.date.day,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SessionHistoryPage(
                            initialDateRange: SessionDateRange.custom,
                            initialCustomRange: DateTimeRange(
                              start: day,
                              end: day,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '近 30 日趋势',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                stats30Async.when(
                  loading: () => const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => Text('加载失败: $error'),
                  data: (stats30) {
                    final maxCount = stats30.fold<int>(
                      0,
                      (max, item) => item.count > max ? item.count : max,
                    );
                    final chartMaxY = (maxCount + 2).toDouble();
                    final spots = [
                      for (var i = 0; i < stats30.length; i++)
                        FlSpot(i.toDouble(), stats30[i].count.toDouble()),
                    ];

                    return SizedBox(
                      height: 200,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: LineChart(
                            LineChartData(
                              maxY: chartMaxY < 4 ? 4 : chartMaxY,
                              gridData: const FlGridData(show: true),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: true),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index < 0 ||
                                          index >= stats30.length ||
                                          index % 5 != 0) {
                                        return const SizedBox.shrink();
                                      }
                                      return Text(
                                        DateFormat('M/d')
                                            .format(stats30[index].date),
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: true,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  '各单词书掌握率',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                booksAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('加载失败: $error'),
                  data: (books) {
                    if (books.isEmpty) {
                      return const Text('暂无数据');
                    }
                    return Column(
                      children: books
                          .map(
                            (progress) => _BookMasteryCard(progress: progress),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BookMasteryCard extends ConsumerWidget {
  const _BookMasteryCard({required this.progress});

  final BookProgress progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync =
        ref.watch(bookDailyStatsProvider(progress.book.id));
    final color = parseHexColor(progress.book.coverColor);
    final masteryPercent = (progress.masteryRate * 100).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color,
                  child: Text(
                    progress.book.title.isNotEmpty
                        ? progress.book.title[0]
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.book.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${progress.learnedWords}/${progress.totalWords} 词已学',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  '$masteryPercent%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.masteryRate,
              color: color,
              backgroundColor: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            statsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (stats) {
                final weekStats = stats.length <= 7
                    ? stats
                    : stats.sublist(stats.length - 7);
                if (weekStats.every((item) => item.count == 0)) {
                  return const SizedBox.shrink();
                }
                final totalWords = weekStats.fold<int>(
                  0,
                  (sum, item) => sum + item.count,
                );
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '近 7 日 · $totalWords 词',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      MiniStudyChart(stats: weekStats, height: 72),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}