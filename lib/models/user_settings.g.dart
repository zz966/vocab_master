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
      dailyGoal: fields[1] == null ? 20 : fields[1] as int,
      themeMode: fields[2] == null ? 'system' : fields[2] as String,
      reminderEnabled: fields[3] == null ? false : fields[3] as bool,
      weeklyReportEnabled: fields[4] == null ? true : fields[4] as bool,
      autoReadEnabled: fields[5] == null ? true : fields[5] as bool,
      allowExtraStudy: fields[6] == null ? false : fields[6] as bool,
      quizPickEnglish: fields[7] == null ? true : fields[7] as bool,
      defaultStudyMode: fields[8] == null ? 'quiz' : fields[8] as String,
      speechRate: fields[9] == null ? 0.45 : fields[9] as double,
      ttsAccent: fields[10] == null ? 'en-US' : fields[10] as String,
      reminderTime: fields[11] as String?,
      currentStreak: fields[12] == null ? 0 : fields[12] as int,
      longestStreak: fields[13] == null ? 0 : fields[13] as int,
      lastStudyDate: fields[14] as DateTime?,
      hasSeenOnboarding: fields[15] == null ? false : fields[15] as bool,
      unlockedAchievementIds:
          fields[16] == null ? [] : (fields[16] as List?)?.cast<String>(),
      updatedAt: fields[17] as DateTime?,
      pointsBalance: fields[18] == null ? 0 : fields[18] as int,
      checkInStreak: fields[19] == null ? 0 : fields[19] as int,
      longestCheckInStreak: fields[20] == null ? 0 : fields[20] as int,
      lastCheckInDate: fields[21] as DateTime?,
      checkInDates:
          fields[22] == null ? [] : (fields[22] as List?)?.cast<String>(),
      displayName: fields[23] == null ? '学习者' : fields[23] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(24)
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
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.pointsBalance)
      ..writeByte(19)
      ..write(obj.checkInStreak)
      ..writeByte(20)
      ..write(obj.longestCheckInStreak)
      ..writeByte(21)
      ..write(obj.lastCheckInDate)
      ..writeByte(22)
      ..write(obj.checkInDates)
      ..writeByte(23)
      ..write(obj.displayName);
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
