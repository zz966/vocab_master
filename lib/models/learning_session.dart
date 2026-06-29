import 'package:hive_flutter/hive_flutter.dart';

part 'learning_session.g.dart';

@HiveType(typeId: 9)
class LearningSession {
  @HiveField(0)
  String id;

  @HiveField(1)
  String sessionType;

  @HiveField(2)
  List<String> bookIds;

  @HiveField(3)
  int wordsStudied;

  @HiveField(4)
  int wordsCorrect;

  @HiveField(5)
  DateTime startedAt;

  @HiveField(6)
  DateTime? completedAt;

  LearningSession({
    required this.id,
    required this.sessionType,
    List<String>? bookIds,
    this.wordsStudied = 0,
    this.wordsCorrect = 0,
    DateTime? startedAt,
    this.completedAt,
  })  : bookIds = bookIds ?? [],
        startedAt = startedAt ?? DateTime.now();
}