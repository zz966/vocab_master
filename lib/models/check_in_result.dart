class CheckInResult {
  const CheckInResult({
    required this.success,
    required this.alreadyCheckedIn,
    required this.pointsEarned,
    required this.newBalance,
    required this.streak,
  });

  final bool success;
  final bool alreadyCheckedIn;
  final int pointsEarned;
  final int newBalance;
  final int streak;
}

class CheckInStatus {
  const CheckInStatus({
    required this.checkedInToday,
    required this.streak,
    required this.longestStreak,
    required this.pointsBalance,
    required this.todayReward,
    required this.recentCheckInDates,
    required this.displayName,
    required this.userLevel,
  });

  final bool checkedInToday;
  final int streak;
  final int longestStreak;
  final int pointsBalance;
  final int todayReward;
  final List<String> recentCheckInDates;
  final String displayName;
  final int userLevel;
}