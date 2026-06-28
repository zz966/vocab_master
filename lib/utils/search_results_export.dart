import 'dart:convert';

import 'package:intl/intl.dart';

import '../models/word.dart';
import '../providers/search_provider.dart';
import 'word_collection_export.dart';

String buildSearchResultsFileName({
  required String query,
  required String format,
}) {
  final safeQuery = query
      .replaceAll(RegExp(r'[<>:"/\\|?*\s]'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  final prefix = safeQuery.isEmpty ? 'all' : safeQuery;
  final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
  return 'vocab_search_results_${prefix}_$timestamp.$format';
}

String formatSearchResultsShareText({
  required String query,
  required List<Word> words,
  WordSearchFilter filter = WordSearchFilter.none,
}) {
  final parts = <String>[
    '🔍 VocabMaster 搜索结果',
    '关键词「$query」',
    '共 ${words.length} 词',
  ];

  if (filter.favoritesOnly) {
    parts.add('仅收藏');
  } else if (filter.wrongBookOnly) {
    parts.add('仅错题');
  }

  if (words.isEmpty) {
    parts.add('未找到匹配单词');
    return parts.join(' · ');
  }

  final preview = words
      .take(10)
      .map((word) => '${word.english}(${word.chinese})')
      .join('、');
  parts.add(words.length > 10 ? '$preview…' : preview);
  return parts.join(' · ');
}

class SearchResultsExportCodec {
  static String toCsv(List<Word> words) => WordCollectionExportCodec.toCsv(words);

  static String toJson({
    required String query,
    required List<Word> words,
    WordSearchFilter filter = WordSearchFilter.none,
  }) {
    final data = {
      'version': 1,
      'query': query,
      'filter': {
        'bookId': filter.bookId,
        'favoritesOnly': filter.favoritesOnly,
        'wrongBookOnly': filter.wrongBookOnly,
      },
      'exportedAt': DateTime.now().toIso8601String(),
      'count': words.length,
      'words': words
          .map(
            (word) => {
              'english': word.english,
              'chinese': word.chinese,
              if (word.phonetic != null) 'phonetic': word.phonetic,
              'isFavorite': word.isFavorite,
              'inWrongBook': word.inWrongBook,
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }
}