import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_settings.dart';
import '../providers/repository_providers.dart';
import '../services/notification_service.dart';
import 'reminder_message.dart';

Future<void> syncDailyReminder(WidgetRef ref, UserSettings settings) async {
  final body = await buildDailyReminderMessage(
    settingsRepository: ref.read(settingsRepositoryProvider),
  );
  await NotificationService.instance.syncReminder(settings, body: body);
}