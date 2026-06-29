import '../models/review_record.dart';
import '../models/word.dart';

class OverviewStats {
  const OverviewStats({
    required this.totalWords,
    required this.learnedWords,
    required this.masteredWords,
  });

  final int totalWords;
  final int learnedWords;
  final int masteredWords;

  double get masteryRate =>
      totalWords == 0 ? 0 : masteredWords / totalWords;
}

OverviewStats computeOverviewStats(Iterable<Word> words) {
  final maxFamiliarityByEnglish = <String, int>{};

  for (final word in words) {
    final key = word.english.trim().toLowerCase();
    if (key.isEmpty) {
      continue;
    }
    maxFamiliarityByEnglish.update(
      key,
      (current) =>
          word.familiarity > current ? word.familiarity : current,
      ifAbsent: () => word.familiarity,
    );
  }

  final totalWords = maxFamiliarityByEnglish.length;
  final learnedWords =
      maxFamiliarityByEnglish.values.where((value) => value > 0).length;
  final masteredWords =
      maxFamiliarityByEnglish.values.where((value) => value >= 4).length;

  return OverviewStats(
    totalWords: totalWords,
    learnedWords: learnedWords,
    masteredWords: masteredWords,
  );
}

int countTodayStudiedWords(
  Iterable<ReviewRecord> records, {
  DateTime? now,
}) {
  final anchor = now ?? DateTime.now();
  final startOfDay = DateTime(anchor.year, anchor.month, anchor.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return records
      .where(
        (record) =>
            !record.reviewedAt.isBefore(startOfDay) &&
            record.reviewedAt.isBefore(endOfDay),
      )
      .map((record) => record.wordId)
      .toSet()
      .length;
}