// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LearningSessionAdapter extends TypeAdapter<LearningSession> {
  @override
  final int typeId = 9;

  @override
  LearningSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LearningSession(
      id: fields[0] as String,
      sessionType: fields[1] as String,
      bookIds: (fields[2] as List?)?.cast<String>(),
      wordsStudied: fields[3] as int,
      wordsCorrect: fields[4] as int,
      startedAt: fields[5] as DateTime?,
      completedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LearningSession obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sessionType)
      ..writeByte(2)
      ..write(obj.bookIds)
      ..writeByte(3)
      ..write(obj.wordsStudied)
      ..writeByte(4)
      ..write(obj.wordsCorrect)
      ..writeByte(5)
      ..write(obj.startedAt)
      ..writeByte(6)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
