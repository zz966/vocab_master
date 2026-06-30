class CheckInResult {
  const CheckInResult({
    required this.success,
    required this.alreadyCheckedIn,
    required this.pointsEarned,
    required this.newBalance,
    required this.checkInStreak,
  });

  final bool success;
  final bool alreadyCheckedIn;
  final int pointsEarned;
  final int newBalance;
  final int checkInStreak;
}

class CheckInStatus {
  const CheckInStatus({
    required this.checkedInToday,
    required this.checkInStreak,
    required this.longestCheckInStreak,
    required this.pointsBalance,
    required this.todayReward,
    required this.recentCheckInDates,
    required this.displayName,
    required this.userLevel,
  });

  final bool checkedInToday;
  final int checkInStreak;
  final int longestCheckInStreak;
  final int pointsBalance;
  final int todayReward;
  final List<String> recentCheckInDates;
  final String displayName;
  final int userLevel;
}