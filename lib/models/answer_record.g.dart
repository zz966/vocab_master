// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnswerRecordAdapter extends TypeAdapter<AnswerRecord> {
  @override
  final int typeId = 10;

  @override
  AnswerRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnswerRecord(
      id: fields[0] as String,
      wordId: fields[1] as String,
      bookId: fields[2] as String?,
      answeredAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AnswerRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.wordId)
      ..writeByte(2)
      ..write(obj.bookId)
      ..writeByte(3)
      ..write(obj.answeredAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
