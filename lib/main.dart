import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/hive/hive_service.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'features/shell/main_shell.dart';
import 'providers/repository_providers.dart';
import 'providers/settings_provider.dart';
import 'repositories/session_repository.dart';
import 'services/notification_service.dart';
import 'services/tts_service.dart';
import 'utils/reminder_message.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _bootstrapApp();
  runApp(const ProviderScope(child: VocabMasterApp()));
}

Future<void> _bootstrapApp() async {
  try {
    await _initializeServices();
  } on Object catch (error, stackTrace) {
    debugPrint('应用初始化失败，正在重置本地数据后重试: $error');
    debugPrint('$stackTrace');
    await HiveService.resetAllBoxes();
    await _initializeServices();
  }
}

Future<void> _initializeServices() async {
  await HiveService.init();
  await HiveService.importInitialBooks();
  await HiveService.seedDefaultSettingsIfNeeded();
  await SessionRepository().cleanupStaleSessions();
  await TtsService.instance.init();
  await NotificationService.instance.init();
}

class VocabMasterApp extends ConsumerStatefulWidget {
  const VocabMasterApp({super.key});

  @override
  ConsumerState<VocabMasterApp> createState() => _VocabMasterAppState();
}

class _VocabMasterAppState extends ConsumerState<VocabMasterApp> {
  bool _defaultsApplied = false;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    if (!_defaultsApplied && settingsAsync.hasValue) {
      _defaultsApplied = true;
      final settings = settingsAsync.value!;
      Future.microtask(() async {
        try {
          await TtsService.instance.setSpeechRate(settings.speechRate);
          await TtsService.instance.setAccent(settings.ttsAccent);
          await NotificationService.instance.requestPermissionIfNeeded();
          final body = await buildDailyReminderMessage(
            settingsRepository: ref.read(settingsRepositoryProvider),
            statsRepository: ref.read(statsRepositoryProvider),
          );
          await NotificationService.instance.syncReminder(settings, body: body);
          final weeklyBody = await buildWeeklyReportMessage(
            settingsRepository: ref.read(settingsRepositoryProvider),
            statsRepository: ref.read(statsRepositoryProvider),
            bookRepository: ref.read(bookRepositoryProvider),
          );
          await NotificationService.instance.syncWeeklyReport(
            settings,
            body: weeklyBody,
          );
        } on Object catch (error, stackTrace) {
          debugPrint('后台提醒同步失败: $error');
          debugPrint('$stackTrace');
        }
      });
    }

    return MaterialApp(
      title: 'VocabMaster',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      themeMode: themeModeFromString(settingsAsync.valueOrNull?.themeMode),
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainShell(),
    );
  }
}