import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/points_constants.dart';
import '../models/check_in_result.dart';
import '../models/point_transaction.dart';
import 'repository_providers.dart';
import 'settings_provider.dart';

part 'points_provider.g.dart';

@riverpod
CheckInStatus checkInStatus(Ref ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  if (settings == null) {
    return const CheckInStatus(
      checkedInToday: false,
      checkInStreak: 0,
      longestCheckInStreak: 0,
      pointsBalance: 0,
      todayReward: PointsConstants.dailyCheckInReward,
      recentCheckInDates: [],
      displayName: '学习者',
      userLevel: 1,
    );
  }
  return ref.watch(pointsRepositoryProvider).buildStatus(settings);
}

@riverpod
Future<List<PointTransaction>> pointsHistory(Ref ref) async {
  ref.watch(settingsProvider);
  return ref
      .read(pointsRepositoryProvider)
      .getRecentTransactions(limit: PointsConstants.pointsHistoryPreviewLimit);
}

@riverpod
Future<List<PointTransaction>> allPointsHistory(Ref ref) async {
  ref.watch(settingsProvider);
  return ref.read(pointsRepositoryProvider).getAllTransactions();
}