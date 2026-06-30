import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/book_provider.dart';
import '../../providers/points_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/study_provider.dart';
import '../../providers/repository_providers.dart';
import '../settings/settings_page.dart';
import 'widgets/daily_check_in_card.dart';
import 'widgets/me_profile_header.dart';
import 'widgets/points_history_section.dart';

class MePage extends ConsumerStatefulWidget {
  const MePage({super.key});

  @override
  ConsumerState<MePage> createState() => _MePageState();
}

class _MePageState extends ConsumerState<MePage> {
  bool _checkingIn = false;

  Future<void> _refresh() async {
    invalidateStudyData(ref);
    ref.invalidate(pointsHistoryProvider);
    ref.invalidate(allPointsHistoryProvider);
    await ref.read(booksProvider.future);
  }

  Future<void> _handleCheckIn() async {
    if (_checkingIn) {
      return;
    }

    setState(() => _checkingIn = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result =
          await ref.read(pointsRepositoryProvider).performDailyCheckIn();
      if (!mounted) {
        return;
      }

      await ref.read(settingsProvider.notifier).reload();
      ref.invalidate(pointsHistoryProvider);
      ref.invalidate(allPointsHistoryProvider);

      if (!mounted) {
        return;
      }
      if (result.success) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              '签到成功！+${result.pointsEarned} 积分，连续 ${result.streak} 天',
            ),
          ),
        );
      } else if (result.alreadyCheckedIn) {
        messenger.showSnackBar(
          const SnackBar(content: Text('今日已签到')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _checkingIn = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final checkInStatus = ref.watch(checkInStatusProvider);
    final todayCountAsync = ref.watch(todayStudyCountProvider);
    final overviewStatsAsync = ref.watch(globalOverviewStatsProvider);
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
          final overview = overviewStatsAsync.valueOrNull;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                MeProfileHeader(status: checkInStatus),
                const SizedBox(height: 16),
                DailyCheckInCard(
                  status: checkInStatus,
                  isLoading: _checkingIn,
                  onCheckIn: _handleCheckIn,
                ),
                const SizedBox(height: 16),
                const PointsHistorySection(),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '整体统计',
                          style: Theme.of(context).textTheme.titleLarge,
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
                          label: '已学习的单词',
                          value: overview == null
                              ? '加载中…'
                              : '${overview.learnedWords} 词',
                        ),
                        _OverviewRow(
                          label: '总词汇量',
                          value: overview == null
                              ? '加载中…'
                              : '${overview.totalWords} 词',
                        ),
                        _OverviewRow(
                          label: '已掌握',
                          value: overview == null
                              ? '加载中…'
                              : overview.totalWords == 0
                                  ? '0%'
                                  : '${(overview.masteryRate * 100).round()}%',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('设置'),
                    subtitle: const Text('学习偏好、外观与提醒'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const SettingsPage(),
                        ),
                      );
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