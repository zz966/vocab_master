import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'models/user_settings.dart';
import 'database/isar_service.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/shell/main_shell.dart';
import 'providers/settings_provider.dart';
import 'providers/study_provider.dart';
import 'providers/word_provider.dart';
import 'repositories/book_repository.dart';
import 'repositories/session_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/stats_repository.dart';
import 'services/notification_service.dart';
import 'services/tts_service.dart';
import 'utils/reminder_message.dart';
import 'widgets/async_value_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.init();
  await BookRepository(IsarService.instance).seedBuiltInBooks();
  await IsarService.seedDefaultSettingsIfNeeded();
  await SessionRepository(IsarService.instance).cleanupStaleSessions();
  await TtsService.instance.init();
  await NotificationService.instance.init();
  runApp(const ProviderScope(child: VocabMasterApp()));
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
      if (settings.defaultBookIds.isNotEmpty) {
        Future.microtask(() {
          ref
              .read(selectedBookIdsProvider.notifier)
              .setAll(settings.defaultBookIds);
        });
      }
      Future.microtask(() async {
        await TtsService.instance.setSpeechRate(settings.speechRate);
        await TtsService.instance.setAccent(settings.ttsAccent);
        await NotificationService.instance.requestPermissionIfNeeded();
        final body = await buildDailyReminderMessage(
          settingsRepository: ref.read(settingsRepositoryProvider),
          wordRepository: ref.read(wordRepositoryProvider),
          bookRepository: ref.read(bookRepositoryProvider),
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
      home: AsyncValueView<UserSettings>(
        value: settingsAsync,
        onRetry: () => ref.invalidate(settingsProvider),
        data: (settings) => settings.hasSeenOnboarding
            ? const MainShell()
            : const OnboardingPage(),
      ),
    );
  }
}