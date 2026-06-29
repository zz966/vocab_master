import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/word_collection_export.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('WordCollectionExportCodec produces CSV with headers', () {
    final csv = WordCollectionExportCodec.toCsv([
      testWord(id: 'w1', english: 'apple', chinese: '苹果'),
      testWord(id: 'w2', english: 'banana', chinese: '香蕉'),
    ]);

    final lines = csv.trim().split('\n');
    expect(lines.first, '英文,中文,音标');
    expect(lines, hasLength(3));
    expect(lines[1], contains('apple'));
    expect(lines[1], contains('苹果'));
  });

  test('WordCollectionExportCodec produces valid JSON', () {
    final json = WordCollectionExportCodec.toJson(
      [testWord(id: 'w1', english: 'cat', chinese: '猫')],
      kind: WordCollectionKind.favorites,
    );
    final data = jsonDecode(json) as Map<String, dynamic>;

    expect(data['kind'], 'favorites');
    expect(data['count'], 1);
    final words = data['words'] as List<dynamic>;
    expect(words.first['english'], 'cat');
  });

  test('formatWordCollectionShareText previews words', () {
    final text = formatWordCollectionShareText(
      kind: WordCollectionKind.wrongBook,
      words: [testWord(id: 'w1', english: 'dog', chinese: '狗')],
    );

    expect(text, contains('错题本'));
    expect(text, contains('dog(狗)'));
  });

  test('buildWordCollectionFileName uses kind prefix', () {
    final name = buildWordCollectionFileName(
      kind: WordCollectionKind.favorites,
      format: 'csv',
    );

    expect(name, startsWith('vocab_words_favorites_'));
    expect(name, endsWith('.csv'));
  });

  test('review queue kind uses vocab_words_review prefix', () {
    final name = buildWordCollectionFileName(
      kind: WordCollectionKind.reviewQueue,
      format: 'json',
    );

    expect(name, startsWith('vocab_words_review_'));
    expect(name, endsWith('.json'));
  });
}