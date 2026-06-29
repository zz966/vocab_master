import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/repositories/book_repository.dart';
import 'package:vocab_master/utils/book_stats_share.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('formatBookStatsShareText summarizes book progress', () {
    final progress = BookProgress(
      book: testBook(bookName: 'CET-4'),
      totalWords: 100,
      learnedWords: 60,
      masteredWords: 40,
    );

    final text = formatBookStatsShareText(progress);

    expect(text, contains('CET-4'));
    expect(text, contains('40%'));
    expect(text, contains('60/100'));
    expect(text, contains('掌握 40 词'));
  });
}