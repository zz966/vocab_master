import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/answer_record.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/overview_stats.dart';

Word _word(String english, {bool learned = false}) {
  return BookWord(
    id: english,
    word: english,
    definitionCn: english,
    learned: learned,
  );
}

AnswerRecord _record({
  required String wordId,
  required DateTime answeredAt,
}) {
  return AnswerRecord(
    id: '$wordId-${answeredAt.millisecondsSinceEpoch}',
    wordId: wordId,
    answeredAt: answeredAt,
  );
}

void main() {
  group('countTodayStudiedWords', () {
    test('counts unique words studied today', () {
      final today = DateTime(2026, 6, 29, 15);
      final records = [
        _record(wordId: 'a', answeredAt: today),
        _record(wordId: 'a', answeredAt: today.add(const Duration(minutes: 5))),
        _record(wordId: 'b', answeredAt: today),
        _record(
          wordId: 'c',
          answeredAt: DateTime(2026, 6, 28, 23, 59),
        ),
      ];

      expect(
        countTodayStudiedWords(records, now: today),
        2,
      );
    });
  });

  group('computeOverviewStats', () {
    test('deduplicates same english word across books by learned flag', () {
      final stats = computeOverviewStats([
        _word('hello', learned: true),
        _word('hello', learned: false),
        _word('world', learned: true),
      ]);

      expect(stats.totalWords, 2);
      expect(stats.learnedWords, 2);
    });

    test('returns zeros for empty library', () {
      final stats = computeOverviewStats(const []);

      expect(stats.totalWords, 0);
      expect(stats.learnedWords, 0);
    });
  });
}