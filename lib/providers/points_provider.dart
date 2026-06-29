import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/points_constants.dart';
import '../models/check_in_result.dart';
import '../models/point_transaction.dart';
import '../providers/settings_provider.dart';
import '../repositories/points_repository.dart';

final checkInStatusProvider = Provider<CheckInStatus>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  if (settings == null) {
    return const CheckInStatus(
      checkedInToday: false,
      streak: 0,
      longestStreak: 0,
      pointsBalance: 0,
      todayReward: PointsConstants.dailyCheckInReward,
      recentCheckInDates: [],
      displayName: '学习者',
      userLevel: 1,
    );
  }
  return ref.watch(pointsRepositoryProvider).buildStatus(settings);
});

final pointsHistoryProvider =
    FutureProvider<List<PointTransaction>>((ref) async {
  ref.watch(settingsProvider);
  return ref
      .read(pointsRepositoryProvider)
      .getRecentTransactions(limit: PointsConstants.pointsHistoryPreviewLimit);
});

final allPointsHistoryProvider =
    FutureProvider<List<PointTransaction>>((ref) async {
  ref.watch(settingsProvider);
  return ref.read(pointsRepositoryProvider).getAllTransactions();
});