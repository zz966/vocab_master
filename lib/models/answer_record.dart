import 'package:hive_flutter/hive_flutter.dart';

part 'answer_record.g.dart';

/// 某天某词答过题即有一条记录（仅用于统计「今日学过哪些词」）。
@HiveType(typeId: 10)
class AnswerRecord {
  @HiveField(0)
  String id;

  @HiveField(1)
  String wordId;

  @HiveField(2)
  String? bookId;

  @HiveField(3)
  DateTime answeredAt;

  AnswerRecord({
    required this.id,
    required this.wordId,
    this.bookId,
    DateTime? answeredAt,
  }) : answeredAt = answeredAt ?? DateTime.now();
}