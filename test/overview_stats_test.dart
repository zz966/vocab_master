import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/review_record.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/overview_stats.dart';

Word _word(String english, {int familiarity = 0}) {
  return BookWord(
    id: english,
    word: english,
    definitionCn: english,
    masteryLevel: familiarity,
  );
}

ReviewRecord _record({
  required String wordId,
  required DateTime reviewedAt,
}) {
  return ReviewRecord(
    id: '$wordId-${reviewedAt.millisecondsSinceEpoch}',
    wordId: wordId,
    quality: 2,
    reviewedAt: reviewedAt,
    previousInterval: 0,
    newInterval: 1,
    easeFactor: 2.5,
  );
}

void main() {
  group('countTodayStudiedWords', () {
    test('counts unique words studied today', () {
      final today = DateTime(2026, 6, 29, 15);
      final records = [
        _record(wordId: 'a', reviewedAt: today),
        _record(wordId: 'a', reviewedAt: today.add(const Duration(minutes: 5))),
        _record(wordId: 'b', reviewedAt: today),
        _record(
          wordId: 'c',
          reviewedAt: DateTime(2026, 6, 28, 23, 59),
        ),
      ];

      expect(
        countTodayStudiedWords(records, now: today),
        2,
      );
    });
  });

  group('computeOverviewStats', () {
    test('deduplicates same english word across books by max familiarity', () {
      final stats = computeOverviewStats([
        _word('Apple', familiarity: 2),
        _word('apple', familiarity: 4),
        _word('banana', familiarity: 0),
        _word('cherry', familiarity: 5),
      ]);

      expect(stats.totalWords, 3);
      expect(stats.learnedWords, 2);
      expect(stats.masteredWords, 2);
      expect(stats.masteryRate, closeTo(2 / 3, 0.001));
    });

    test('returns zeros for empty library', () {
      final stats = computeOverviewStats(const []);

      expect(stats.totalWords, 0);
      expect(stats.learnedWords, 0);
      expect(stats.masteredWords, 0);
      expect(stats.masteryRate, 0);
    });
  });
}