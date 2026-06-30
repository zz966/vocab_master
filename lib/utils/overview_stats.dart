import '../models/answer_record.dart';
import '../models/word.dart';

class OverviewStats {
  const OverviewStats({
    required this.totalWords,
    required this.learnedWords,
  });

  final int totalWords;
  final int learnedWords;
}

OverviewStats computeOverviewStats(Iterable<Word> words) {
  final learnedByEnglish = <String, bool>{};

  for (final word in words) {
    final key = word.english.trim().toLowerCase();
    if (key.isEmpty) {
      continue;
    }
    learnedByEnglish.update(
      key,
      (current) => current || word.learned,
      ifAbsent: () => word.learned,
    );
  }

  final totalWords = learnedByEnglish.length;
  final learnedWords =
      learnedByEnglish.values.where((learned) => learned).length;

  return OverviewStats(
    totalWords: totalWords,
    learnedWords: learnedWords,
  );
}

/// 今日学习词数：每天每个 [wordId] 最多计 1 次。
int countTodayStudiedWords(
  Iterable<AnswerRecord> records, {
  DateTime? now,
}) {
  final anchor = now ?? DateTime.now();
  final startOfDay = DateTime(anchor.year, anchor.month, anchor.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return records
      .where(
        (record) =>
            !record.answeredAt.isBefore(startOfDay) &&
            record.answeredAt.isBefore(endOfDay),
      )
      .map((record) => record.wordId)
      .toSet()
      .length;
}