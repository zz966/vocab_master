import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/book_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Book.fromJson loads cet4_1.json', () async {
    final jsonStr = await File('assets/books/cet4_1.json').readAsString();
    final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

    expect(book.bookName, '大学英语四级核心词汇');
    expect(book.bookId, 'CET4_1');
    expect(book.words, isNotEmpty);
    expect(book.words.first.word, 'abruptly');
    expect(book.words.first.sentenceExamples.first.en, isNotEmpty);
    expect(book.words.first.sentenceExamples.first.cn, isNotEmpty);
  });
}