import 'package:hive_flutter/hive_flutter.dart';

import '../utils/level_challenge.dart';

part 'level_challenge_progress.g.dart';

@HiveType(typeId: 11)
class LevelChallengeProgress {
  @HiveField(0)
  String bookId;

  @HiveField(1)
  int levelIndex;

  @HiveField(2)
  List<String> completedModes;

  LevelChallengeProgress({
    required this.bookId,
    required this.levelIndex,
    List<String>? completedModes,
  }) : completedModes = completedModes ?? [];

  String get storageKey => levelChallengeStorageKey(bookId, levelIndex);

  int get starCount => completedModes.length.clamp(0, maxChallengeStars);
}

String levelChallengeStorageKey(String bookId, int levelIndex) =>
    '${bookId}_$levelIndex';