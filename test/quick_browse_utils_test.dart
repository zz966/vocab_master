import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/quick_browse_utils.dart';

Word _word(String english) {
  return BookWord(
    id: english,
    word: english,
    definitionCn: english,
  );
}

void main() {
  test('quickBrowseTotalPages uses 100 words per page', () {
    expect(quickBrowseTotalPages(0), 1);
    expect(quickBrowseTotalPages(1), 1);
    expect(quickBrowseTotalPages(100), 1);
    expect(quickBrowseTotalPages(101), 2);
    expect(quickBrowseTotalPages(250), 3);
  });

  test('quickBrowsePageWords returns the requested slice', () {
    final words = List.generate(250, (index) => _word('w$index'));

    expect(quickBrowsePageWords(words, page: 1).length, 100);
    expect(quickBrowsePageWords(words, page: 2).length, 100);
    expect(quickBrowsePageWords(words, page: 3).length, 50);
    expect(quickBrowsePageWords(words, page: 1).first.english, 'w0');
    expect(quickBrowsePageWords(words, page: 2).first.english, 'w100');
  });

  test('clampQuickBrowsePage enforces page boundaries', () {
    expect(
      clampQuickBrowsePage(0, wordCount: 250),
      1,
    );
    expect(
      clampQuickBrowsePage(99, wordCount: 250),
      3,
    );
    expect(
      clampQuickBrowsePage(2, wordCount: 250),
      2,
    );
  });

  test('sortWordsForQuickBrowse sorts alphabetically', () {
    final sorted = sortWordsForQuickBrowse([
      _word('zebra'),
      _word('apple'),
      _word('mango'),
    ]);

    expect(sorted.map((word) => word.english).toList(), [
      'apple',
      'mango',
      'zebra',
    ]);
  });
}