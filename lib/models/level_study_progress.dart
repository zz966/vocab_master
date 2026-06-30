import 'package:hive_flutter/hive_flutter.dart';

part 'level_study_progress.g.dart';

@HiveType(typeId: 13)
class LevelStudyProgress {
  @HiveField(0)
  String bookId;

  @HiveField(1)
  int levelIndex;

  /// 本关已到达的最远单词序号（0-based），只随「下一词」前移。
  @HiveField(2)
  int maxWordIndex;

  LevelStudyProgress({
    required this.bookId,
    required this.levelIndex,
    this.maxWordIndex = -1,
  });

  String get storageKey => levelStudyStorageKey(bookId, levelIndex);
}

String levelStudyStorageKey(String bookId, int levelIndex) =>
    '${bookId}_$levelIndex';