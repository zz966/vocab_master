import 'package:hive_flutter/hive_flutter.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 8)
class UserSettings {
  @HiveField(0)
  List<String> defaultBookIds;

  @HiveField(1)
  int dailyGoal;

  @HiveField(2)
  String themeMode;

  @HiveField(3)
  bool reminderEnabled;

  @HiveField(4)
  bool weeklyReportEnabled;

  @HiveField(5)
  bool autoReadEnabled;

  @HiveField(6)
  bool allowExtraStudy;

  @HiveField(7)
  bool quizPickEnglish;

  @HiveField(8)
  String defaultStudyMode;

  @HiveField(9)
  double speechRate;

  @HiveField(10)
  String ttsAccent;

  @HiveField(11)
  String? reminderTime;

  @HiveField(12)
  int currentStreak;

  @HiveField(13)
  int longestStreak;

  @HiveField(14)
  DateTime? lastStudyDate;

  @HiveField(15)
  bool hasSeenOnboarding;

  @HiveField(16)
  List<String> unlockedAchievementIds;

  @HiveField(17)
  DateTime updatedAt;

  UserSettings({
    List<String>? defaultBookIds,
    this.dailyGoal = 20,
    this.themeMode = 'system',
    this.reminderEnabled = false,
    this.weeklyReportEnabled = true,
    this.autoReadEnabled = true,
    this.allowExtraStudy = false,
    this.quizPickEnglish = true,
    this.defaultStudyMode = 'flashcard',
    this.speechRate = 0.45,
    this.ttsAccent = 'en-US',
    this.reminderTime,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastStudyDate,
    this.hasSeenOnboarding = false,
    List<String>? unlockedAchievementIds,
    DateTime? updatedAt,
  })  : defaultBookIds = defaultBookIds ?? [],
        unlockedAchievementIds = unlockedAchievementIds ?? [],
        updatedAt = updatedAt ?? DateTime.now();
}