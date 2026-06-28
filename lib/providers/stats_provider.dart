import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/learning_session.dart';
import '../repositories/session_repository.dart';
import '../repositories/stats_repository.dart';

final last7DaysStatsProvider = FutureProvider<List<DailyStudyStat>>((ref) async {
  return ref.watch(statsRepositoryProvider).getLast7DaysStats();
});

final last30DaysStatsProvider = FutureProvider<List<DailyStudyStat>>((ref) async {
  return ref.watch(statsRepositoryProvider).getLast30DaysStats();
});

final sessionSummaryProvider = FutureProvider<SessionSummary>((ref) async {
  return ref.watch(statsRepositoryProvider).getSessionSummary();
});

final recentSessionsProvider = FutureProvider<List<LearningSession>>((ref) async {
  return ref.watch(sessionRepositoryProvider).getRecentSessions();
});

final todayStudyStatsProvider =
    FutureProvider<({int studied, int correct})>((ref) async {
  return ref.watch(statsRepositoryProvider).getTodayStudyStats();
});

final bookDailyStatsProvider =
    FutureProvider.family<List<DailyStudyStat>, int>((ref, bookId) async {
  return ref.watch(statsRepositoryProvider).getDailyStatsForBook(bookId);
});

final bookDailyAccuracyProvider =
    FutureProvider.family<List<DailyAccuracyStat>, int>((ref, bookId) async {
  return ref.watch(statsRepositoryProvider).getDailyAccuracyForBook(bookId);
});