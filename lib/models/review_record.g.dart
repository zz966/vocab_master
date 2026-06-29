// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewRecordAdapter extends TypeAdapter<ReviewRecord> {
  @override
  final int typeId = 10;

  @override
  ReviewRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewRecord(
      id: fields[0] as String,
      wordId: fields[1] as String,
      bookId: fields[2] as String?,
      quality: fields[3] as int,
      reviewedAt: fields[4] as DateTime,
      previousInterval: fields[5] as double,
      newInterval: fields[6] as double,
      easeFactor: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.wordId)
      ..writeByte(2)
      ..write(obj.bookId)
      ..writeByte(3)
      ..write(obj.quality)
      ..writeByte(4)
      ..write(obj.reviewedAt)
      ..writeByte(5)
      ..write(obj.previousInterval)
      ..writeByte(6)
      ..write(obj.newInterval)
      ..writeByte(7)
      ..write(obj.easeFactor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
