import 'package:hive_flutter/hive_flutter.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 8)
class UserSettings {
  @HiveField(0)
  List<String> defaultBookIds;

  @HiveField(1, defaultValue: 20)
  int dailyGoal;

  @HiveField(2, defaultValue: 'system')
  String themeMode;

  @HiveField(3, defaultValue: false)
  bool reminderEnabled;

  @HiveField(4, defaultValue: true)
  bool weeklyReportEnabled;

  @HiveField(5, defaultValue: true)
  bool autoReadEnabled;

  @HiveField(6, defaultValue: false)
  bool allowExtraStudy;

  @HiveField(7, defaultValue: true)
  bool quizPickEnglish;

  @HiveField(8, defaultValue: 'flashcard')
  String defaultStudyMode;

  @HiveField(9, defaultValue: 0.45)
  double speechRate;

  @HiveField(10, defaultValue: 'en-US')
  String ttsAccent;

  @HiveField(11)
  String? reminderTime;

  @HiveField(12, defaultValue: 0)
  int currentStreak;

  @HiveField(13, defaultValue: 0)
  int longestStreak;

  @HiveField(14)
  DateTime? lastStudyDate;

  @HiveField(15, defaultValue: false)
  bool hasSeenOnboarding;

  @HiveField(16, defaultValue: <String>[])
  List<String> unlockedAchievementIds;

  @HiveField(17)
  DateTime updatedAt;

  @HiveField(18, defaultValue: 0)
  int pointsBalance;

  @HiveField(19, defaultValue: 0)
  int checkInStreak;

  @HiveField(20, defaultValue: 0)
  int longestCheckInStreak;

  @HiveField(21)
  DateTime? lastCheckInDate;

  @HiveField(22, defaultValue: <String>[])
  List<String> checkInDates;

  @HiveField(23, defaultValue: '学习者')
  String displayName;

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
    this.pointsBalance = 0,
    this.checkInStreak = 0,
    this.longestCheckInStreak = 0,
    this.lastCheckInDate,
    List<String>? checkInDates,
    this.displayName = '学习者',
  })  : defaultBookIds = defaultBookIds ?? [],
        unlockedAchievementIds = unlockedAchievementIds ?? [],
        checkInDates = checkInDates ?? [],
        updatedAt = updatedAt ?? DateTime.now();
}