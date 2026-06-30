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
      themeMode: fields[2] == null ? 'system' : fields[2] as String,
      reminderEnabled: fields[3] == null ? false : fields[3] as bool,
      autoReadEnabled: fields[5] == null ? true : fields[5] as bool,
      speechRate: fields[9] == null ? 0.45 : fields[9] as double,
      ttsAccent: fields[10] == null ? 'en-US' : fields[10] as String,
      reminderTime: fields[11] as String?,
      studyStreak: fields[12] == null ? 0 : fields[12] as int,
      longestStudyStreak: fields[13] == null ? 0 : fields[13] as int,
      lastStudyDate: fields[14] as DateTime?,
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
      ..writeByte(16)
      ..writeByte(2)
      ..write(obj.themeMode)
      ..writeByte(3)
      ..write(obj.reminderEnabled)
      ..writeByte(5)
      ..write(obj.autoReadEnabled)
      ..writeByte(9)
      ..write(obj.speechRate)
      ..writeByte(10)
      ..write(obj.ttsAccent)
      ..writeByte(11)
      ..write(obj.reminderTime)
      ..writeByte(12)
      ..write(obj.studyStreak)
      ..writeByte(13)
      ..write(obj.longestStudyStreak)
      ..writeByte(14)
      ..write(obj.lastStudyDate)
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
