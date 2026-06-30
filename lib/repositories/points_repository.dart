

import '../core/hive/hive_service.dart';
import '../core/points_constants.dart';
import '../models/check_in_result.dart';
import '../models/point_transaction.dart';
import '../models/user_settings.dart';
import '../repositories/settings_repository.dart';
import '../utils/check_in_utils.dart';

class PointsRepository {
  PointsRepository(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  CheckInStatus buildStatus(UserSettings settings) {
    return CheckInStatus(
      checkedInToday: hasCheckedInToday(settings),
      streak: settings.checkInStreak,
      longestStreak: settings.longestCheckInStreak,
      pointsBalance: settings.pointsBalance,
      todayReward: PointsConstants.dailyCheckInReward,
      recentCheckInDates: settings.checkInDates,
      displayName: settings.displayName,
      userLevel: resolveUserLevel(settings.pointsBalance),
    );
  }

  Future<CheckInResult> performDailyCheckIn() async {
    final settings = await _settingsRepository.getSettings();
    if (hasCheckedInToday(settings)) {
      return CheckInResult(
        success: false,
        alreadyCheckedIn: true,
        pointsEarned: 0,
        newBalance: settings.pointsBalance,
        streak: settings.checkInStreak,
      );
    }

    final now = DateTime.now();
    final today = dateOnly(now);
    final reward = PointsConstants.dailyCheckInReward;
    final nextStreak = calculateNextCheckInStreak(
      today: today,
      lastCheckIn: settings.lastCheckInDate,
      currentStreak: settings.checkInStreak,
    );

    settings
      ..pointsBalance += reward
      ..checkInStreak = nextStreak
      ..longestCheckInStreak = nextStreak > settings.longestCheckInStreak
          ? nextStreak
          : settings.longestCheckInStreak
      ..lastCheckInDate = now
      ..updatedAt = now;

    final todayKey = formatCheckInDate(today);
    if (!settings.checkInDates.contains(todayKey)) {
      settings.checkInDates = [...settings.checkInDates, todayKey];
    }
    trimCheckInHistory(settings);

    await _settingsRepository.saveSettings(settings);
    await _recordTransaction(
      amount: reward,
      reason: '每日签到',
    );

    return CheckInResult(
      success: true,
      alreadyCheckedIn: false,
      pointsEarned: reward,
      newBalance: settings.pointsBalance,
      streak: settings.checkInStreak,
    );
  }

  Future<void> _recordTransaction({
    required int amount,
    required String reason,
  }) async {
    final transaction = PointTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amount: amount,
      reason: reason,
    );
    await HiveService.savePointTransaction(transaction);
  }

  Future<List<PointTransaction>> getRecentTransactions({
    int limit = PointsConstants.pointsHistoryPreviewLimit,
  }) async {
    final transactions = HiveService.getPointTransactions();
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (transactions.length <= limit) {
      return transactions;
    }
    return transactions.sublist(0, limit);
  }

  Future<List<PointTransaction>> getAllTransactions() async {
    final transactions = HiveService.getPointTransactions();
    transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return transactions;
  }
}

