import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/book_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/stats_repository.dart';
import '../repositories/word_repository.dart';
import '../utils/reminder_message.dart';

class NotificationPreview {
  const NotificationPreview({
    required this.daily,
    required this.weekly,
  });

  final String daily;
  final String weekly;
}

final notificationPreviewProvider =
    FutureProvider<NotificationPreview>((ref) async {
  final daily = await buildDailyReminderMessage(
    settingsRepository: ref.watch(settingsRepositoryProvider),
    wordRepository: ref.watch(wordRepositoryProvider),
    bookRepository: ref.watch(bookRepositoryProvider),
    statsRepository: ref.watch(statsRepositoryProvider),
  );
  final weekly = await buildWeeklyReportMessage(
    settingsRepository: ref.watch(settingsRepositoryProvider),
    statsRepository: ref.watch(statsRepositoryProvider),
    bookRepository: ref.watch(bookRepositoryProvider),
  );
  return NotificationPreview(daily: daily, weekly: weekly);
});