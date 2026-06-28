import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/providers/search_provider.dart';
import 'package:vocab_master/utils/search_results_export.dart';

void main() {
  Word sampleWord() {
    return Word()
      ..english = 'test'
      ..chinese = '测试'
      ..bookIds = [1];
  }

  test('formatSearchResultsShareText summarizes search results', () {
    final text = formatSearchResultsShareText(
      query: 'app',
      words: [sampleWord()],
      filter: const WordSearchFilter(favoritesOnly: true),
    );

    expect(text, contains('app'));
    expect(text, contains('test(测试)'));
    expect(text, contains('仅收藏'));
  });

  test('SearchResultsExportCodec produces JSON with query metadata', () {
    final json = SearchResultsExportCodec.toJson(
      query: 'hello',
      words: [sampleWord()],
    );
    final data = jsonDecode(json) as Map<String, dynamic>;

    expect(data['query'], 'hello');
    expect(data['count'], 1);
  });

  test('buildSearchResultsFileName sanitizes query', () {
    final name = buildSearchResultsFileName(query: 'a b', format: 'csv');

    expect(name, startsWith('vocab_search_results_a_b_'));
    expect(name, endsWith('.csv'));
  });
}