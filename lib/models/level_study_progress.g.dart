// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level_study_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelStudyProgressAdapter extends TypeAdapter<LevelStudyProgress> {
  @override
  final int typeId = 13;

  @override
  LevelStudyProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelStudyProgress(
      bookId: fields[0] as String,
      levelIndex: fields[1] as int,
      maxWordIndex: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LevelStudyProgress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.levelIndex)
      ..writeByte(2)
      ..write(obj.maxWordIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelStudyProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
