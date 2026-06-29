import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/word_share.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('formatWordShareText includes core fields and books', () {
    final word = testWord(
      id: 'w1',
      english: 'apple',
      chinese: '苹果',
      examples: ['An apple a day.'],
    )
      ..phonetic = '/ˈæpl/'
      ..partOfSpeech = 'n.';

    final book = testBook(bookName: 'CET-4');

    final text = formatWordShareText(word, books: [book]);

    expect(text, contains('apple'));
    expect(text, contains('苹果'));
    expect(text, contains('/ˈæpl/'));
    expect(text, contains('n.'));
    expect(text, contains('An apple a day.'));
    expect(text, contains('CET-4'));
  });
}