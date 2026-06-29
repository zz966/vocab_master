import '../core/study_mode.dart';

const int maxChallengeStars = 3;
const String levelChallengeSessionPrefix = 'level_';
const String levelChallengeSessionMarker = '_challenge_';

class LevelChallengeRef {
  const LevelChallengeRef({
    required this.bookId,
    required this.levelIndex,
    required this.mode,
  });

  final String bookId;
  final int levelIndex;
  final StudyMode mode;

  String get sessionType =>
      '${levelChallengeSessionPrefix}${bookId}_$levelIndex$levelChallengeSessionMarker${mode.name}';
}

LevelChallengeRef? parseLevelChallengeSessionType(String? sessionType) {
  if (sessionType == null ||
      !sessionType.startsWith(levelChallengeSessionPrefix) ||
      !sessionType.contains(levelChallengeSessionMarker)) {
    return null;
  }

  final markerIndex = sessionType.indexOf(levelChallengeSessionMarker);
  final prefix = sessionType.substring(
    levelChallengeSessionPrefix.length,
    markerIndex,
  );
  final modeName = sessionType.substring(
    markerIndex + levelChallengeSessionMarker.length,
  );

  final levelSeparator = prefix.lastIndexOf('_');
  if (levelSeparator <= 0) {
    return null;
  }

  final bookId = prefix.substring(0, levelSeparator);
  final levelIndex = int.tryParse(prefix.substring(levelSeparator + 1));
  if (bookId.isEmpty || levelIndex == null) {
    return null;
  }

  final mode = StudyMode.values
      .where(
        (item) =>
            item.name == modeName &&
            levelChallengeModes.any((challenge) => challenge.name == modeName),
      )
      .firstOrNull;
  if (mode == null) {
    return null;
  }

  return LevelChallengeRef(
    bookId: bookId,
    levelIndex: levelIndex,
    mode: mode,
  );
}

bool isPerfectChallengeScore({
  required int totalWords,
  required int wordsStudied,
  required int wordsCorrect,
}) {
  return totalWords > 0 &&
      wordsStudied == totalWords &&
      wordsCorrect == totalWords;
}

int calculateChallengeStars(Iterable<String> completedModes) {
  final valid = completedModes
      .where(
        (name) => levelChallengeModes.any((mode) => mode.name == name),
      )
      .toSet();
  return valid.length.clamp(0, maxChallengeStars);
}