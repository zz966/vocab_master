import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/study_mode.dart';
import '../models/learning_session.dart';
import '../models/word.dart';
import '../repositories/book_repository.dart';
import '../repositories/session_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/word_repository.dart';
import '../services/study_service.dart';
import '../services/tts_service.dart';
import '../utils/study_queue.dart';
import 'achievements_provider.dart';
import 'book_provider.dart' show booksProvider, globalOverviewStatsProvider;
import 'points_provider.dart';
import 'review_provider.dart' show todayReviewWordsProvider;
import 'settings_provider.dart';
import 'stats_provider.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  ref.keepAlive();
  return TtsService.instance;
});

final studyServiceProvider = Provider<StudyService>((ref) {
  return StudyService(
    wordRepository: ref.watch(wordRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
    sessionRepository: ref.watch(sessionRepositoryProvider),
  );
});

/// Selected WordBook IDs for the current study session (multi-select).
class SelectedBookIdsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void toggle(String bookId) {
    if (state.contains(bookId)) {
      state = state.where((id) => id != bookId).toList();
    } else {
      state = [...state, bookId];
    }
  }

  void setAll(List<String> bookIds) {
    state = bookIds;
  }

  void clear() {
    state = [];
  }
}

final selectedBookIdsProvider =
    NotifierProvider<SelectedBookIdsNotifier, List<String>>(
  SelectedBookIdsNotifier.new,
);

/// How words are ordered in the study queue.
final studyQueueOrderProvider = StateProvider<StudyQueueOrder>(
  (ref) => StudyQueueOrder.familiarity,
);

/// In-session study progress (current index / total).
class StudySessionProgress {
  const StudySessionProgress({
    required this.currentIndex,
    required this.totalWords,
  });

  final int currentIndex;
  final int totalWords;

  double get fraction =>
      totalWords == 0 ? 0 : (currentIndex + 1) / totalWords;

  bool get isComplete => totalWords > 0 && currentIndex >= totalWords - 1;
}

final studySessionProgressProvider =
    StateProvider<StudySessionProgress?>((ref) => null);

final dailyQuotaRemainingProvider = FutureProvider<int>((ref) async {
  final settings = await ref.watch(settingsRepositoryProvider).getSettings();
  final todayCount =
      await ref.watch(settingsRepositoryProvider).getTodayStudyCount();
  return (settings.dailyGoal - todayCount).clamp(0, settings.dailyGoal);
});

final dueWordsCountProvider =
    FutureProvider.family<int, List<String>>((ref, bookIds) async {
  if (bookIds.isEmpty) {
    return 0;
  }
  final words =
      await ref.watch(wordRepositoryProvider).getDueWordsForBooks(bookIds);
  return words.length;
});

Future<List<Word>> _loadStudyWords(Ref ref, List<String> bookIds) async {
  if (bookIds.isEmpty) {
    return [];
  }

  final dueWords =
      await ref.watch(wordRepositoryProvider).getDueWordsForBooks(bookIds);
  final settings = await ref.watch(settingsRepositoryProvider).getSettings();

  List<Word> capped;
  if (settings.allowExtraStudy) {
    capped = dueWords;
  } else {
    final remaining = await ref.watch(dailyQuotaRemainingProvider.future);
    if (remaining == 0) {
      return [];
    }
    capped = dueWords.take(remaining).toList();
  }

  final order = ref.watch(studyQueueOrderProvider);
  return buildStudyQueue(capped, order);
}

/// Word queue for selected books (due words, quota-capped, ordered).
final studyWordsProvider =
    FutureProvider.family<List<Word>, List<String>>((ref, bookIds) {
  return _loadStudyWords(ref, bookIds);
});

/// Current study queue bound to [selectedBookIdsProvider].
final activeStudyQueueProvider = FutureProvider<List<Word>>((ref) async {
  final bookIds = ref.watch(selectedBookIdsProvider);
  return ref.watch(studyWordsProvider(bookIds).future);
});

/// Backward-compatible alias for [todayReviewWordsProvider].
final reviewWordsProvider = todayReviewWordsProvider;

/// Active [LearningSession] while [StudySessionPage] is open.
final currentStudySessionProvider =
    StateProvider<LearningSession?>((ref) => null);

final navigationIndexProvider = StateProvider<int>((ref) => 0);

final studySessionModeProvider = StateProvider<StudyMode>((ref) {
  return StudyMode.quiz;
});

void invalidateStudyData(WidgetRef ref) {
  ref.invalidate(booksProvider);
  ref.invalidate(globalOverviewStatsProvider);
  ref.invalidate(settingsProvider);
  ref.invalidate(todayStudyCountProvider);
  ref.invalidate(dailyQuotaRemainingProvider);
  ref.invalidate(dueWordsCountProvider);
  ref.invalidate(activeStudyQueueProvider);
  ref.invalidate(todayReviewWordsProvider);
  ref.invalidate(studyWordsProvider);
  ref.invalidate(recentSessionsProvider);
  ref.invalidate(sessionSummaryProvider);
  ref.invalidate(achievementsProvider);
  ref.invalidate(pointsHistoryProvider);
  ref.invalidate(allPointsHistoryProvider);
}