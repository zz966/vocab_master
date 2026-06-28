import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/achievements.dart';
import '../repositories/session_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/stats_repository.dart';
import '../repositories/word_repository.dart';
import 'book_provider.dart';

final achievementsProvider = FutureProvider<AchievementSnapshot>((ref) async {
  final settings = await ref.watch(settingsRepositoryProvider).getSettings();
  final books = await ref.watch(booksProvider.future);
  final sessions = await ref.watch(sessionRepositoryProvider).getRecentSessions(
        limit: 500,
      );
  final favorites =
      await ref.watch(wordRepositoryProvider).getFavoriteWords();
  final totalWordsStudied =
      await ref.watch(statsRepositoryProvider).getTotalWordsStudied();

  final masteredWords =
      books.fold<int>(0, (sum, item) => sum + item.masteredWords);
  final completedSessions =
      sessions.where((session) => session.completedAt != null).length;
  final sessionTypes = sessions.map((session) {
    final type = session.sessionType;
    if (type.startsWith('review_')) {
      return type.replaceFirst('review_', '');
    }
    if (type.startsWith('practice_')) {
      return type.replaceFirst('practice_', '');
    }
    return type;
  }).toSet();

  final context = AchievementContext(
    currentStreak: settings.currentStreak,
    longestStreak: settings.longestStreak,
    masteredWords: masteredWords,
    completedSessions: completedSessions,
    totalWordsStudied: totalWordsStudied,
    favoritesCount: favorites.length,
    sessionTypes: sessionTypes,
  );

  final statuses = evaluateAchievements(context);
  return AchievementSnapshot(
    statuses: statuses,
    unlockedCount: countUnlockedAchievements(statuses),
    totalCount: statuses.length,
  );
});