import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/review_filter.dart';

Word _word({
  required String english,
  int reviewCount = 1,
  DateTime? nextReview,
  List<int> bookIds = const [1],
}) {
  return Word()
    ..english = english
    ..chinese = english
    ..bookIds = bookIds
    ..reviewCount = reviewCount
    ..nextReview = nextReview;
}

void main() {
  final today = DateTime(2026, 6, 16, 12);

  test('getTodayReviewWords includes words due on or before today', () {
    final words = [
      _word(
        english: 'due_today',
        nextReview: DateTime(2026, 6, 16, 8),
      ),
      _word(
        english: 'due_yesterday',
        nextReview: DateTime(2026, 6, 15, 20),
      ),
      _word(
        english: 'due_tomorrow',
        nextReview: DateTime(2026, 6, 17, 8),
      ),
      _word(english: 'never_studied', reviewCount: 0),
    ];

    final due = getTodayReviewWords(words, today: today);

    expect(due.map((w) => w.english).toList(),
        ['due_yesterday', 'due_today']);
  });

  test('getTodayReviewWords filters by book ids for mixed mode', () {
    final words = [
      _word(
        english: 'book1',
        nextReview: DateTime(2026, 6, 16),
        bookIds: [1],
      ),
      _word(
        english: 'book2',
        nextReview: DateTime(2026, 6, 16),
        bookIds: [2],
      ),
    ];

    final due = getTodayReviewWords(
      words,
      today: today,
      bookIds: [1],
    );

    expect(due, hasLength(1));
    expect(due.first.english, 'book1');
  });

  test('simulated next day surfaces tomorrow review words', () {
    final word = _word(
      english: 'future',
      nextReview: DateTime(2026, 6, 17, 9),
    );

    expect(
      getTodayReviewWords([word], today: DateTime(2026, 6, 16)),
      isEmpty,
    );
    expect(
      getTodayReviewWords([word], today: DateTime(2026, 6, 17)),
      hasLength(1),
    );
  });
}