import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/models/word_book.dart';
import 'package:vocab_master/utils/word_share.dart';

void main() {
  test('formatWordShareText includes core fields and books', () {
    final word = Word()
      ..english = 'apple'
      ..chinese = '苹果'
      ..phonetic = '/ˈæpl/'
      ..partOfSpeech = 'n.'
      ..examples = ['An apple a day.']
      ..bookIds = [1];

    final book = WordBook()..title = 'CET-4';

    final text = formatWordShareText(word, books: [book]);

    expect(text, contains('apple'));
    expect(text, contains('苹果'));
    expect(text, contains('/ˈæpl/'));
    expect(text, contains('n.'));
    expect(text, contains('An apple a day.'));
    expect(text, contains('CET-4'));
  });
}