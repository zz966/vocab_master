import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_settings.dart';
import 'repository_providers.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<UserSettings> build() async {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  Future<void> save(UserSettings settings) async {
    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    state = AsyncData(settings);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(
      await ref.read(settingsRepositoryProvider).getSettings(),
    );
  }
}

@riverpod
Future<int> todayStudyCount(Ref ref) async {
  return ref.watch(settingsRepositoryProvider).getTodayStudyCount();
}