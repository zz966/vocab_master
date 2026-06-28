/// SM-2 inspired spaced repetition algorithm.
/// Quality: 0=Forgot, 1=Unsure, 2=Remembered, 3=Easy legacy.
class Sm2Result {
  const Sm2Result({
    required this.interval,
    required this.repetitions,
    required this.easeFactor,
    required this.nextReview,
  });

  final double interval;
  final int repetitions;
  final double easeFactor;
  final DateTime nextReview;
}

class Sm2Algorithm {
  static const double minEaseFactor = 1.3;
  static const double defaultEaseFactor = 2.5;

  static const _ratingAliases = <String, int>{
    'again': 0,
    'forgot': 0,
    '忘了': 0,
    'hard': 1,
    'unsure': 1,
    '模糊': 1,
    'good': 2,
    'remembered': 2,
    '记住了': 2,
    'easy': 3,
  };

  /// Documented API: returns next review date and updated familiarity.
  ///
  /// [rating]: "Forgot", "Unsure", "Remembered", or legacy Anki-style
  /// "Again", "Hard", "Good", "Easy" (case-insensitive).
  static Map<String, dynamic> calculateNextReview(
    int currentFamiliarity, {
    required String rating,
    DateTime? now,
  }) {
    final quality = _qualityFromRating(rating);
    final repetitions = currentFamiliarity.clamp(0, 5);
    final interval = _defaultIntervalForRepetitions(repetitions);

    final result = calculate(
      quality: quality,
      repetitions: repetitions,
      easeFactor: defaultEaseFactor,
      interval: interval,
      now: now,
    );

    return {
      'nextReview': result.nextReview,
      'familiarity': nextFamiliarity(currentFamiliarity, quality),
      'interval': result.interval,
      'repetitions': result.repetitions,
      'easeFactor': result.easeFactor,
      'quality': quality,
    };
  }

  static Sm2Result calculate({
    required int quality,
    required int repetitions,
    required double easeFactor,
    required double interval,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    var newEase = easeFactor;
    var newRepetitions = repetitions;
    var newInterval = interval;

    if (quality == 0) {
      newRepetitions = 0;
      newInterval = 0;
    } else if (quality == 1) {
      newRepetitions = 0;
      newInterval = 0.25;
    } else {
      newEase =
          (easeFactor + (0.1 - (3 - quality) * (0.08 + (3 - quality) * 0.02)))
              .clamp(minEaseFactor, double.infinity);
      if (newRepetitions == 0) {
        newInterval = 1;
      } else if (newRepetitions == 1) {
        newInterval = 6;
      } else {
        newInterval = (interval * newEase).roundToDouble();
      }
      newRepetitions += 1;
    }

    final nextReview = switch (quality) {
      0 => current.add(const Duration(minutes: 10)),
      1 => current.add(const Duration(hours: 6)),
      _ => current.add(Duration(days: newInterval.round())),
    };

    return Sm2Result(
      interval: newInterval,
      repetitions: newRepetitions,
      easeFactor: newEase,
      nextReview: nextReview,
    );
  }

  static int _qualityFromRating(String rating) {
    final normalized = rating.trim().toLowerCase();
    final quality = _ratingAliases[normalized];
    if (quality == null) {
      throw ArgumentError(
        'Unknown rating "$rating". Expected Forgot, Unsure, Remembered, or Easy.',
      );
    }
    return quality;
  }

  static double _defaultIntervalForRepetitions(int repetitions) {
    if (repetitions <= 0) {
      return 0;
    }
    if (repetitions == 1) {
      return 1;
    }
    return 6;
  }

  /// Maps SM-2 quality (0–3) to a 0–5 familiarity score.
  static int nextFamiliarity(int current, int quality) {
    return switch (quality) {
      0 => (current - 1).clamp(0, 5),
      1 => current.clamp(0, 5),
      2 => (current + 1).clamp(0, 5),
      3 => (current + 2).clamp(0, 5),
      _ => current.clamp(0, 5),
    };
  }
}
