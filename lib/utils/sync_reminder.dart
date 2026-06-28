import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_settings.dart';
import '../providers/word_provider.dart';
import '../repositories/book_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/stats_repository.dart';
import '../services/notification_service.dart';
import 'reminder_message.dart';

Future<void> syncDailyReminder(WidgetRef ref, UserSettings settings) async {
  final body = await buildDailyReminderMessage(
    settingsRepository: ref.read(settingsRepositoryProvider),
    wordRepository: ref.read(wordRepositoryProvider),
    bookRepository: ref.read(bookRepositoryProvider),
    statsRepository: ref.read(statsRepositoryProvider),
  );
  await NotificationService.instance.syncReminder(settings, body: body);
}

Future<void> syncWeeklyReport(WidgetRef ref, UserSettings settings) async {
  final body = await buildWeeklyReportMessage(
    settingsRepository: ref.read(settingsRepositoryProvider),
    statsRepository: ref.read(statsRepositoryProvider),
    bookRepository: ref.read(bookRepositoryProvider),
  );
  await NotificationService.instance.syncWeeklyReport(settings, body: body);
}

Future<void> syncAllReminders(WidgetRef ref, UserSettings settings) async {
  await syncDailyReminder(ref, settings);
  await syncWeeklyReport(ref, settings);
}