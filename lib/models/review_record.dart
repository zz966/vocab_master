import 'package:hive_flutter/hive_flutter.dart';

part 'review_record.g.dart';

@HiveType(typeId: 10)
class ReviewRecord {
  @HiveField(0)
  String id;

  @HiveField(1)
  String wordId;

  @HiveField(2)
  String? bookId;

  @HiveField(3)
  int quality;

  @HiveField(4)
  DateTime reviewedAt;

  @HiveField(5)
  double previousInterval;

  @HiveField(6)
  double newInterval;

  @HiveField(7)
  double easeFactor;

  ReviewRecord({
    required this.id,
    required this.wordId,
    this.bookId,
    required this.quality,
    required this.reviewedAt,
    this.previousInterval = 0,
    this.newInterval = 0,
    this.easeFactor = 2.5,
  });
}