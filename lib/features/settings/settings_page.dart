import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/study_mode.dart';
import '../../models/user_settings.dart';
import '../onboarding/onboarding_page.dart';
import '../../providers/achievements_provider.dart';
import '../../providers/export_refresh_provider.dart';
import '../../providers/book_provider.dart';
import '../../providers/notification_preview_provider.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/settings_repository.dart';
import '../../repositories/stats_repository.dart';
import '../../providers/settings_provider.dart';
import '../../providers/study_provider.dart';
import '../../providers/word_provider.dart';
import '../../services/notification_service.dart';
import '../../utils/export_file.dart';
import '../../utils/stats_export.dart';
import 'widgets/export_files_section.dart';
import '../../utils/sync_reminder.dart';
import '../about/about_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late final TextEditingController _goalController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _goalController = TextEditingController();
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _save(UserSettings settings) async {
    setState(() => _saving = true);
    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    await ref.read(ttsServiceProvider).setSpeechRate(settings.speechRate);
    await ref.read(ttsServiceProvider).setAccent(settings.ttsAccent);
    await syncAllReminders(ref, settings);
    invalidateStudyData(ref);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('设置已保存')));
    }
  }

  Future<void> _exportStats({bool shareAfter = false}) async {
    setState(() => _saving = true);
    try {
      final settings = await ref.read(settingsRepositoryProvider).getSettings();
      final books = await ref.read(booksProvider.future);
      final summary7 = await ref
          .read(statsRepositoryProvider)
          .getSessionSummary(days: 7);
      final summary30 = await ref
          .read(statsRepositoryProvider)
          .getSessionSummary(days: 30);
      final sessions = await ref
          .read(sessionRepositoryProvider)
          .getRecentSessions();
      final totalWordsStudied = await ref
          .read(statsRepositoryProvider)
          .getTotalWordsStudied();
      final achievements = await ref.read(achievementsProvider.future);

      final json = StatsExportCodec.encode(
        settings: settings,
        books: books,
        summary7: summary7,
        summary30: summary30,
        recentSessions: sessions,
        totalWordsStudied: totalWordsStudied,
        achievements: achievements.statuses,
      );

      final fileName =
          'vocab_master_stats_${DateFormat('yyyyMMdd').format(DateTime.now())}.json';
      final path = await saveTextToDocuments(content: json, fileName: fileName);
      if (path != null) {
        bumpExportFilesRevision(ref);
      }

      if (!mounted) {
        return;
      }

      if (path != null && shareAfter) {
        final result = await shareFileAtPath(path, name: fileName);
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result == ShareExportResult.shared ? '已导出并打开分享' : '已导出，分享失败',
            ),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(path == null ? '导出失败' : '已导出到 $path'),
          action: path == null
              ? null
              : SnackBarAction(
                  label: '分享',
                  onPressed: () => shareFileAtPath(path, name: fileName),
                ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _resetProgress(UserSettings settings) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重置学习进度'),
        content: const Text('将清空所有单词的学习记录、复习计划和打卡数据，收藏夹会保留。此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('确认重置'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _saving = true);
    await ref.read(wordRepositoryProvider).resetAllLearningProgress();
    await ref.read(settingsRepositoryProvider).clearReviewRecords();
    await ref.read(sessionRepositoryProvider).clearAllSessions();
    await ref.read(settingsRepositoryProvider).resetStreak(settings);
    settings.unlockedAchievementIds = [];
    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    invalidateStudyData(ref);

    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('学习进度已重置')));
    }
  }

  Future<void> _pickReminderTime(UserSettings settings) async {
    final parts = (settings.reminderTime ?? '20:00').split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 20,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0,
    );
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      settings.reminderTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      await _save(settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final booksAsync = ref.watch(booksProvider);
    final previewAsync = ref.watch(notificationPreviewProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (settings) {
          if (_goalController.text.isEmpty) {
            _goalController.text = '${settings.dailyGoal}';
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('学习', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _goalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '每日学习目标（词）',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) {
                  final goal = int.tryParse(_goalController.text) ?? 20;
                  settings.dailyGoal = goal.clamp(5, 200);
                  _save(settings);
                },
              ),
              SwitchListTile(
                title: const Text('自动朗读'),
                subtitle: const Text('学习时自动朗读当前单词'),
                value: settings.autoReadEnabled,
                onChanged: (value) {
                  settings.autoReadEnabled = value;
                  _save(settings);
                },
              ),
              SwitchListTile(
                title: const Text('超额学习'),
                subtitle: const Text('完成每日目标后仍可继续学习新词'),
                value: settings.allowExtraStudy,
                onChanged: (value) {
                  settings.allowExtraStudy = value;
                  _save(settings);
                },
              ),
              Text('默认学习模式', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: StudyMode.values.map((mode) {
                  final selected = settings.defaultStudyMode == mode.name;
                  return FilterChip(
                    label: Text(mode.title),
                    selected: selected,
                    onSelected: (_) {
                      settings.defaultStudyMode = mode.name;
                      _save(settings);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('选择题默认方向'),
                subtitle: Text(settings.quizPickEnglish ? '看中文选英文' : '看英文选中文'),
                value: settings.quizPickEnglish,
                onChanged: (value) {
                  settings.quizPickEnglish = value;
                  _save(settings);
                },
              ),
              ListTile(
                title: const Text('朗读语速'),
                subtitle: Slider(
                  value: settings.speechRate.clamp(0.2, 1.0),
                  min: 0.2,
                  max: 1.0,
                  divisions: 8,
                  label: settings.speechRate.toStringAsFixed(2),
                  onChanged: (value) {
                    setState(() => settings.speechRate = value);
                  },
                  onChangeEnd: (value) {
                    settings.speechRate = value;
                    _save(settings);
                  },
                ),
              ),
              Text('发音口音', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'en-US', label: Text('美式')),
                  ButtonSegment(value: 'en-GB', label: Text('英式')),
                ],
                selected: {settings.ttsAccent},
                onSelectionChanged: (value) {
                  settings.ttsAccent = value.first;
                  _save(settings);
                },
              ),
              const SizedBox(height: 24),
              Text('外观', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'system', label: Text('跟随系统')),
                  ButtonSegment(value: 'light', label: Text('浅色')),
                  ButtonSegment(value: 'dark', label: Text('深色')),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (value) {
                  settings.themeMode = value.first;
                  _save(settings);
                },
              ),
              const SizedBox(height: 24),
              Text('默认单词书', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              booksAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('加载失败: $error'),
                data: (books) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: books.map((progress) {
                      final selected = settings.defaultBookIds.contains(
                        progress.book.id,
                      );
                      return FilterChip(
                        label: Text(progress.book.title),
                        selected: selected,
                        onSelected: (value) {
                          if (value) {
                            settings.defaultBookIds = [
                              ...settings.defaultBookIds,
                              progress.book.id,
                            ];
                          } else {
                            settings.defaultBookIds = settings.defaultBookIds
                                .where((id) => id != progress.book.id)
                                .toList();
                          }
                          _save(settings);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text('提醒', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('每日学习提醒'),
                subtitle: Text('每天 ${settings.reminderTime ?? '20:00'} 推送通知'),
                value: settings.reminderEnabled,
                onChanged: (value) async {
                  settings.reminderEnabled = value;
                  if (value) {
                    await NotificationService.instance
                        .requestPermissionIfNeeded();
                  }
                  await _save(settings);
                },
              ),
              ListTile(
                title: const Text('提醒时间'),
                trailing: Text(settings.reminderTime ?? '20:00'),
                onTap: () => _pickReminderTime(settings),
              ),
              SwitchListTile(
                title: const Text('每周学习周报'),
                subtitle: const Text('每周日推送本周学习总结'),
                value: settings.weeklyReportEnabled,
                onChanged: settings.reminderEnabled
                    ? (value) {
                        settings.weeklyReportEnabled = value;
                        _save(settings);
                      }
                    : null,
              ),
              const SizedBox(height: 12),
              previewAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (preview) => Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '通知文案预览',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '每日提醒',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          preview.daily,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (settings.weeklyReportEnabled) ...[
                          const SizedBox(height: 12),
                          Text(
                            '每周周报',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            preview.weekly,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('关于', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('关于 VocabMaster'),
                subtitle: const Text('版本 1.0.0'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const AboutPage()),
                  );
                },
              ),
              ListTile(
                title: const Text('重新查看新手引导'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const OnboardingPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text('数据', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saving ? null : _exportStats,
                      icon: const Icon(Icons.download),
                      label: const Text('导出学习数据'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saving
                          ? null
                          : () => _exportStats(shareAfter: true),
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('导出并分享'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const ExportFilesSection(),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _saving ? null : () => _resetProgress(settings),
                icon: const Icon(Icons.restart_alt),
                label: const Text('重置学习进度'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving
                    ? null
                    : () {
                        final goal = int.tryParse(_goalController.text) ?? 20;
                        settings.dailyGoal = goal.clamp(5, 200);
                        _save(settings);
                      },
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('保存设置'),
              ),
            ],
          );
        },
      ),
    );
  }
}
