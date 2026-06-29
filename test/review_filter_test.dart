import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/review_filter.dart';

import 'helpers/model_fixtures.dart';

void main() {
  final today = DateTime(2026, 6, 16, 12);

  test('getTodayReviewWords includes words due on or before today', () {
    final words = [
      testWord(
        id: 'w1',
        english: 'due_today',
        reviewCount: 1,
        nextReview: DateTime(2026, 6, 16, 8),
      ),
      testWord(
        id: 'w2',
        english: 'due_yesterday',
        reviewCount: 1,
        nextReview: DateTime(2026, 6, 15, 20),
      ),
      testWord(
        id: 'w3',
        english: 'due_tomorrow',
        reviewCount: 1,
        nextReview: DateTime(2026, 6, 17, 8),
      ),
      testWord(id: 'w4', english: 'never_studied', reviewCount: 0),
    ];

    final due = getTodayReviewWords(words, today: today);

    expect(due.map((w) => w.english).toList(),
        ['due_yesterday', 'due_today']);
  });

  test('getTodayReviewWords filters by book ids for mixed mode', () {
    final words = [
      testWord(
        id: 'w1',
        english: 'book1',
        reviewCount: 1,
        nextReview: DateTime(2026, 6, 16),
        bookIds: ['book_1'],
      ),
      testWord(
        id: 'w2',
        english: 'book2',
        reviewCount: 1,
        nextReview: DateTime(2026, 6, 16),
        bookIds: ['book_2'],
      ),
    ];

    final due = getTodayReviewWords(
      words,
      today: today,
      bookIds: ['book_1'],
    );

    expect(due, hasLength(1));
    expect(due.first.english, 'book1');
  });

  test('simulated next day surfaces tomorrow review words', () {
    final word = testWord(
      id: 'w1',
      english: 'future',
      reviewCount: 1,
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