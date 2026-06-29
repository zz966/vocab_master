import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/word.dart';
import '../providers/settings_provider.dart';
import '../providers/study_provider.dart';

/// Speaks [word] when the user has enabled auto-read in settings.
///
/// Set [force] for modes where pronunciation is required (e.g. listening).
Future<void> autoSpeakWordIfEnabled(
  WidgetRef ref,
  Word word, {
  bool force = false,
}) async {
  if (!force) {
    final settings = ref.read(settingsProvider).value;
    if (settings != null) {
      if (!settings.autoReadEnabled) {
        return;
      }
    } else {
      final loaded = await ref.read(settingsProvider.future);
      if (!loaded.autoReadEnabled) {
        return;
      }
    }
  }

  final text = word.english.trim();
  if (text.isEmpty) {
    return;
  }

  await ref.read(ttsServiceProvider).speak(text);
}