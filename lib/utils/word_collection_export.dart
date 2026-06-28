import 'dart:convert';

import 'package:intl/intl.dart';

import '../models/word.dart';

enum WordCollectionKind { favorites, wrongBook, reviewQueue }

extension WordCollectionKindLabel on WordCollectionKind {
  String get title => switch (this) {
        WordCollectionKind.favorites => '收藏夹',
        WordCollectionKind.wrongBook => '错题本',
        WordCollectionKind.reviewQueue => '今日复习',
      };

  String get filePrefix => switch (this) {
        WordCollectionKind.favorites => 'vocab_words_favorites',
        WordCollectionKind.wrongBook => 'vocab_words_wrongbook',
        WordCollectionKind.reviewQueue => 'vocab_words_review',
      };
}

class WordCollectionExportCodec {
  static String toCsv(List<Word> words) {
    final buffer = StringBuffer()..writeln('英文,中文,音标');

    for (final word in words) {
      buffer.writeln(
        '${_escape(word.english)},'
        '${_escape(word.chinese)},'
        '${_escape(word.phonetic ?? '')}',
      );
    }

    return buffer.toString();
  }

  static String toJson(List<Word> words, {required WordCollectionKind kind}) {
    final data = {
      'version': 1,
      'kind': kind.name,
      'exportedAt': DateTime.now().toIso8601String(),
      'count': words.length,
      'words': words
          .map(
            (word) => {
              'english': word.english,
              'chinese': word.chinese,
              if (word.phonetic != null) 'phonetic': word.phonetic,
              if (word.partOfSpeech != null) 'partOfSpeech': word.partOfSpeech,
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  static String _escape(String value) {
    if (value.contains(',') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

String buildWordCollectionFileName({
  required WordCollectionKind kind,
  required String format,
}) {
  final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
  return '${kind.filePrefix}_$timestamp.$format';
}

String formatWordCollectionShareText({
  required WordCollectionKind kind,
  required List<Word> words,
}) {
  final parts = <String>[
    '📖 VocabMaster ${kind.title}',
    '共 ${words.length} 词',
  ];

  if (words.isEmpty) {
    parts.add(kind == WordCollectionKind.wrongBook ? '暂无错题' : '暂无收藏');
    return parts.join(' · ');
  }

  final preview = words
      .take(12)
      .map((word) => '${word.english}(${word.chinese})')
      .join('、');
  parts.add(words.length > 12 ? '$preview…' : preview);
  return parts.join(' · ');
}