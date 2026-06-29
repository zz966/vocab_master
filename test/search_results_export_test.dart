import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/providers/search_provider.dart';
import 'package:vocab_master/utils/search_results_export.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('formatSearchResultsShareText summarizes search results', () {
    final text = formatSearchResultsShareText(
      query: 'app',
      words: [testWord(id: 'w1', english: 'test', chinese: '测试')],
      filter: const WordSearchFilter(favoritesOnly: true),
    );

    expect(text, contains('app'));
    expect(text, contains('test(测试)'));
    expect(text, contains('仅收藏'));
  });

  test('SearchResultsExportCodec produces JSON with query metadata', () {
    final json = SearchResultsExportCodec.toJson(
      query: 'hello',
      words: [testWord(id: 'w1', english: 'test', chinese: '测试')],
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