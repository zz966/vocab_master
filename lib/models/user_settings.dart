import 'package:hive_flutter/hive_flutter.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 8)
class UserSettings {
  @HiveField(2, defaultValue: 'system')
  String themeMode;

  @HiveField(3, defaultValue: false)
  bool reminderEnabled;

  @HiveField(5, defaultValue: true)
  bool autoReadEnabled;

  @HiveField(9, defaultValue: 0.45)
  double speechRate;

  @HiveField(10, defaultValue: 'en-US')
  String ttsAccent;

  @HiveField(11)
  String? reminderTime;

  @HiveField(12, defaultValue: 0)
  int studyStreak;

  @HiveField(13, defaultValue: 0)
  int longestStudyStreak;

  @HiveField(14)
  DateTime? lastStudyDate;

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
    this.themeMode = 'system',
    this.reminderEnabled = false,
    this.autoReadEnabled = true,
    this.speechRate = 0.45,
    this.ttsAccent = 'en-US',
    this.reminderTime,
    this.studyStreak = 0,
    this.longestStudyStreak = 0,
    this.lastStudyDate,
    DateTime? updatedAt,
    this.pointsBalance = 0,
    this.checkInStreak = 0,
    this.longestCheckInStreak = 0,
    this.lastCheckInDate,
    List<String>? checkInDates,
    this.displayName = '学习者',
  })  : checkInDates = checkInDates ?? [],
        updatedAt = updatedAt ?? DateTime.now();
}