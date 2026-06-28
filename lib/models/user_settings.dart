import 'package:isar/isar.dart';

part 'user_settings.g.dart';

@collection
class UserSettings {
  Id id = Isar.autoIncrement;

  List<int> defaultBookIds = [];
  int dailyGoal = 20;
  String themeMode = 'system';
  bool reminderEnabled = false;
  bool weeklyReportEnabled = true;
  bool autoReadEnabled = true;
  bool allowExtraStudy = false;
  bool quizPickEnglish = true;
  String defaultStudyMode = 'flashcard';
  double speechRate = 0.45;
  String ttsAccent = 'en-US';
  String? reminderTime;
  int currentStreak = 0;
  int longestStreak = 0;
  DateTime? lastStudyDate;
  bool hasSeenOnboarding = false;
  List<String> unlockedAchievementIds = [];
  DateTime updatedAt = DateTime.now();
}