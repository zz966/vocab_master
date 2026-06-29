import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/study_mode.dart';
import 'package:vocab_master/utils/level_challenge.dart';

void main() {
  test('LevelChallengeRef builds and parses session type', () {
    const ref = LevelChallengeRef(
      bookId: 'TEST_40',
      levelIndex: 1,
      mode: StudyMode.quiz,
    );

    expect(ref.sessionType, 'level_TEST_40_1_challenge_quiz');

    final parsed = parseLevelChallengeSessionType(ref.sessionType);
    expect(parsed?.bookId, ref.bookId);
    expect(parsed?.levelIndex, ref.levelIndex);
    expect(parsed?.mode, ref.mode);
  });

  test('parseLevelChallengeSessionType supports book ids with underscores', () {
    final parsed = parseLevelChallengeSessionType(
      'level_cet4_1_2_challenge_spelling',
    );

    expect(parsed?.bookId, 'cet4_1');
    expect(parsed?.levelIndex, 2);
    expect(parsed?.mode, StudyMode.spelling);
  });

  test('isPerfectChallengeScore requires 100 percent accuracy', () {
    expect(
      isPerfectChallengeScore(
        totalWords: 30,
        wordsStudied: 30,
        wordsCorrect: 30,
      ),
      isTrue,
    );
    expect(
      isPerfectChallengeScore(
        totalWords: 30,
        wordsStudied: 30,
        wordsCorrect: 29,
      ),
      isFalse,
    );
    expect(
      isPerfectChallengeScore(
        totalWords: 30,
        wordsStudied: 29,
        wordsCorrect: 29,
      ),
      isFalse,
    );
  });

  test('calculateChallengeStars counts completed modes up to three', () {
    expect(calculateChallengeStars(const []), 0);
    expect(calculateChallengeStars(const ['quiz']), 1);
    expect(
      calculateChallengeStars(const ['quiz', 'spelling', 'listening']),
      3,
    );
    expect(
      calculateChallengeStars(
        const ['quiz', 'spelling', 'listening', 'quiz'],
      ),
      3,
    );
  });
}