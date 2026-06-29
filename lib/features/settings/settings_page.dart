import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_settings.dart';
import '../../providers/settings_provider.dart';
import '../../providers/study_provider.dart';
import '../../repositories/settings_repository.dart';
import '../../services/notification_service.dart';
import '../../utils/sync_reminder.dart';
import '../about/about_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _saving = false;

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

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('学习', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('自动朗读'),
                subtitle: const Text('学习时自动朗读当前单词'),
                value: settings.autoReadEnabled,
                onChanged: _saving
                    ? null
                    : (value) {
                        settings.autoReadEnabled = value;
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
                  onChanged: _saving
                      ? null
                      : (value) {
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
                onSelectionChanged: _saving
                    ? null
                    : (value) {
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
                onSelectionChanged: _saving
                    ? null
                    : (value) {
                        settings.themeMode = value.first;
                        _save(settings);
                      },
              ),
              const SizedBox(height: 24),
              Text('提醒', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('每日学习提醒'),
                subtitle: Text('每天 ${settings.reminderTime ?? '20:00'} 推送通知'),
                value: settings.reminderEnabled,
                onChanged: _saving
                    ? null
                    : (value) async {
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
                onTap: _saving ? null : () => _pickReminderTime(settings),
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
            ],
          );
        },
      ),
    );
  }
}