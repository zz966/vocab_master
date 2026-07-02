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

  test('bookNeedsBundledAssetRefresh detects word count changes', () {
    final rich = BookWord(
      id: 'w1',
      word: 'test',
      phoneticUk: '/test/',
      phoneticUs: '/test/',
      partOfSpeech: 'n.',
      definitionCn: '测试',
      sentenceExamples: List.generate(
        3,
        (index) => BookWordExample(en: 'Ex $index.', cn: '例 $index。'),
      ),
      definitions: [WordDefinition(partOfSpeech: 'n.', meaning: '测试')],
      englishDefinitions: [
        WordDefinition(partOfSpeech: 'n.', meaning: 'test'),
      ],
      synonymDetails: [
        ConfusableWord(word: 'exam', explanation: '考试'),
      ],
      collocations: [
        WordPhrase(
          phrase: 'test case',
          translation: '测试用例',
          exampleEnglish: 'Write a test case.',
          exampleChinese: '写一个测试用例。',
        ),
      ],
    );

    final existing = Book(
      bookId: 'CET4_CORE',
      bookName: '四级',
      totalWords: 1,
      words: [rich],
    );
    final incoming = Book(
      bookId: 'CET4_CORE',
      bookName: '四级',
      totalWords: 2,
      words: [rich, rich],
    );

    expect(
      bookNeedsBundledAssetRefresh(existing: existing, incoming: incoming),
      isTrue,
    );
    expect(
      bookNeedsBundledAssetRefresh(
        existing: existing,
        incoming: Book(
          bookId: 'CET4_CORE',
          bookName: '四级',
          totalWords: 1,
          words: [rich],
        ),
      ),
      isFalse,
    );
  });

  test('isRichBookWord accepts single authentic example', () {
    final authentic = BookWord(
      id: 'legacy_1',
      word: 'abruptly',
      phoneticUk: '/əˈbrʌptli/',
      phoneticUs: '/əˈbrʌptli/',
      partOfSpeech: 'adv.',
      definitionCn: '突然地',
      sentenceExamples: [
        BookWordExample(en: 'Example.', cn: '例句。'),
      ],
      definitions: [WordDefinition(partOfSpeech: 'adv.', meaning: '突然地')],
      synonymDetails: [
        ConfusableWord(word: 'suddenly', explanation: '突然地'),
      ],
    );

    expect(isRichBookWord(authentic), isTrue);
  });

  test('isRichBookWord accepts words without examples when definitions exist', () {
    final sparse = BookWord(
      id: 'legacy_2',
      word: 'abruptly',
      phoneticUk: '/əˈbrʌptli/',
      phoneticUs: '/əˈbrʌptli/',
      partOfSpeech: 'adv.',
      definitionCn: '突然地',
      sentenceExamples: const [],
      definitions: [WordDefinition(partOfSpeech: 'adv.', meaning: '突然地')],
    );

    expect(isRichBookWord(sparse), isTrue);
  });

  test('isRichBookWord rejects words without definitions', () {
    final legacy = BookWord(
      id: 'legacy_3',
      word: 'abruptly',
      phoneticUk: '/əˈbrʌptli/',
      phoneticUs: '/əˈbrʌptli/',
      partOfSpeech: 'adv.',
      definitionCn: '突然地',
      sentenceExamples: const [],
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