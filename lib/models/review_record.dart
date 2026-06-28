import 'package:isar/isar.dart';

part 'review_record.g.dart';

@collection
class ReviewRecord {
  Id id = Isar.autoIncrement;

  late int wordId;
  int? bookId;
  late int quality;
  late DateTime reviewedAt;
  double previousInterval = 0;
  double newInterval = 0;
  double easeFactor = 2.5;
}