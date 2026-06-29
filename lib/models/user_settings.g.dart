// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 8;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      defaultBookIds: (fields[0] as List?)?.cast<String>(),
      dailyGoal: fields[1] as int,
      themeMode: fields[2] as String,
      reminderEnabled: fields[3] as bool,
      weeklyReportEnabled: fields[4] as bool,
      autoReadEnabled: fields[5] as bool,
      allowExtraStudy: fields[6] as bool,
      quizPickEnglish: fields[7] as bool,
      defaultStudyMode: fields[8] as String,
      speechRate: fields[9] as double,
      ttsAccent: fields[10] as String,
      reminderTime: fields[11] as String?,
      currentStreak: fields[12] as int,
      longestStreak: fields[13] as int,
      lastStudyDate: fields[14] as DateTime?,
      hasSeenOnboarding: fields[15] as bool,
      unlockedAchievementIds: (fields[16] as List?)?.cast<String>(),
      updatedAt: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.defaultBookIds)
      ..writeByte(1)
      ..write(obj.dailyGoal)
      ..writeByte(2)
      ..write(obj.themeMode)
      ..writeByte(3)
      ..write(obj.reminderEnabled)
      ..writeByte(4)
      ..write(obj.weeklyReportEnabled)
      ..writeByte(5)
      ..write(obj.autoReadEnabled)
      ..writeByte(6)
      ..write(obj.allowExtraStudy)
      ..writeByte(7)
      ..write(obj.quizPickEnglish)
      ..writeByte(8)
      ..write(obj.defaultStudyMode)
      ..writeByte(9)
      ..write(obj.speechRate)
      ..writeByte(10)
      ..write(obj.ttsAccent)
      ..writeByte(11)
      ..write(obj.reminderTime)
      ..writeByte(12)
      ..write(obj.currentStreak)
      ..writeByte(13)
      ..write(obj.longestStreak)
      ..writeByte(14)
      ..write(obj.lastStudyDate)
      ..writeByte(15)
      ..write(obj.hasSeenOnboarding)
      ..writeByte(16)
      ..write(obj.unlockedAchievementIds)
      ..writeByte(17)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
