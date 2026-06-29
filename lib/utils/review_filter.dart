import '../models/word.dart';

/// Returns true when [word] is due for review on [referenceDay] (calendar day).
bool isDueForReview(Word word, DateTime referenceDay) {
  if (word.reviewCount <= 0 || word.nextReview == null) {
    return false;
  }

  final startOfTomorrow = DateTime(
    referenceDay.year,
    referenceDay.month,
    referenceDay.day + 1,
  );
  return word.nextReview!.isBefore(startOfTomorrow);
}

/// Filters words whose [Word.nextReview] falls on or before [today].
///
/// When [bookIds] is provided, only words belonging to at least one of those
/// books are included (supports multi-book mixed review).
List<Word> getTodayReviewWords(
  List<Word> words, {
  DateTime? today,
  List<String>? bookIds,
}) {
  final referenceDay = today ?? DateTime.now();
  final bookFilter = bookIds == null || bookIds.isEmpty
      ? null
      : bookIds.toSet();

  final due = words.where((word) {
    if (bookFilter != null &&
        !word.bookIds.any(bookFilter.contains)) {
      return false;
    }
    return isDueForReview(word, referenceDay);
  }).toList();

  due.sort((a, b) {
    final byDue = (a.nextReview ?? DateTime(1970))
        .compareTo(b.nextReview ?? DateTime(1970));
    if (byDue != 0) {
      return byDue;
    }
    return a.familiarity.compareTo(b.familiarity);
  });

  return due;
}