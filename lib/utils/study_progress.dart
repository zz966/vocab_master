import '../models/word.dart';
import 'study_quality.dart';

/// Simple review scheduling and familiarity updates.
class StudyProgress {
  StudyProgress._();

  static void applyRating(Word word, StudyQuality quality) {
    word.familiarity = _nextFamiliarity(word.familiarity, quality.value);
    word.reviewCount += 1;
    word.correctStreak =
        quality.value >= 2 ? word.correctStreak + 1 : 0;

    final days = _daysUntilNextReview(quality, word.familiarity);
    word.sm2Interval = days.toDouble();
    word.nextReview = DateTime.now().add(Duration(days: days));

    if (quality == StudyQuality.again) {
      word.inWrongBook = true;
    } else if (quality.value >= 2) {
      word.inWrongBook = false;
    }
  }

  static int intervalDays(Word word) => word.sm2Interval.round();

  static int _nextFamiliarity(int current, int quality) {
    return switch (quality) {
      0 => (current - 1).clamp(0, 5),
      1 => current.clamp(0, 5),
      2 => (current + 1).clamp(0, 5),
      3 => (current + 2).clamp(0, 5),
      _ => current.clamp(0, 5),
    };
  }

  static int _daysUntilNextReview(StudyQuality quality, int familiarity) {
    return switch (quality) {
      StudyQuality.again => 0,
      StudyQuality.hard => 1,
      StudyQuality.good => familiarity.clamp(1, 5),
      StudyQuality.easy => (familiarity + 1).clamp(2, 7),
    };
  }
}