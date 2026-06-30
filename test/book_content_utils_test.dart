import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/book_model.dart';
import 'package:vocab_master/utils/book_content_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('isRichBookWord accepts test_40 words', () async {
    final jsonStr = await rootBundle.loadString('assets/books/test_40.json');
    final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

    expect(book.words.every(isRichBookWord), isTrue);
    expect(bookNeedsRichContentRefresh(book), isFalse);
  });

  test('isRichBookWord rejects legacy simplified words', () {
    final legacy = BookWord(
      id: 'legacy_1',
      word: 'abruptly',
      phoneticUk: '/əˈbrʌptli/',
      phoneticUs: '/əˈbrʌptli/',
      partOfSpeech: 'adv.',
      definitionCn: '突然地',
      sentenceExamples: [
        BookWordExample(en: 'Example.', cn: '例句。'),
      ],
      synonymDetails: [
        ConfusableWord(word: 'suddenly', explanation: '突然地'),
      ],
    );

    expect(isRichBookWord(legacy), isFalse);
    expect(
      bookNeedsRichContentRefresh(
        Book(
          bookId: 'LEGACY',
          bookName: 'Legacy',
          words: [legacy],
        ),
      ),
      isTrue,
    );
  });
}