// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_challenge_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelChallengeProgressAdapter
    extends TypeAdapter<LevelChallengeProgress> {
  @override
  final int typeId = 11;

  @override
  LevelChallengeProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelChallengeProgress(
      bookId: fields[0] as String,
      levelIndex: fields[1] as int,
      completedModes: (fields[2] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, LevelChallengeProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.levelIndex)
      ..writeByte(2)
      ..write(obj.completedModes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelChallengeProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
