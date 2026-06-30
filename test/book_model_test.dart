import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/book_model.dart';
import 'package:vocab_master/utils/book_content_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Book.fromJson loads test_40.json rich format', () async {
    final jsonStr = await rootBundle.loadString('assets/books/test_40.json');
    final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

    expect(book.bookName, '测试词库（40词）');
    expect(book.bookId, 'TEST_40');
    expect(book.words, hasLength(40));
    expect(book.words.first.word, 'adrift');
    expect(book.words.first.sentenceExamples.first.en, isNotEmpty);
    expect(book.words.first.sentenceExamples.first.cn, isNotEmpty);
    expect(book.words.first.definitions, isNotNull);
    expect(book.words.first.englishDefinitions, isNotNull);
    expect(book.words.first.synonymDetails, isNotNull);
    expect(bookNeedsRichContentRefresh(book), isFalse);
    expect(book.words.every(isRichBookWord), isTrue);
  });
}