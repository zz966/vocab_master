import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_settings.dart';
import '../repositories/settings_repository.dart';

/// Loads and caches [UserSettings] from Hive via [AsyncNotifier].
class SettingsNotifier extends AsyncNotifier<UserSettings> {
  @override
  Future<UserSettings> build() async {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  /// Persists settings and updates local state.
  Future<void> save(UserSettings settings) async {
    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    state = AsyncData(settings);
  }

  /// Reloads settings from storage (e.g. after external invalidation).
  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(
      await ref.read(settingsRepositoryProvider).getSettings(),
    );
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, UserSettings>(
  SettingsNotifier.new,
);

final todayStudyCountProvider = FutureProvider<int>((ref) async {
  return ref.watch(settingsRepositoryProvider).getTodayStudyCount();
});