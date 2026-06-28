import 'dart:convert';

import '../models/word.dart';
import '../models/word_book.dart';

class BookExportCodec {
  static String encode(WordBook book, List<Word> words) {
    final data = {
      'version': 2,
      'title': book.title,
      'description': book.description,
      'category': book.category,
      'coverColor': book.coverColor,
      'words': words
          .map(
            (word) => {
              'english': word.english,
              'chinese': word.chinese,
              if (word.phonetic != null) 'phonetic': word.phonetic,
              if (word.partOfSpeech != null) 'partOfSpeech': word.partOfSpeech,
              if (word.examples != null && word.examples!.isNotEmpty)
                'examples': word.examples,
              if (word.imageUrl != null) 'imageUrl': word.imageUrl,
              if (word.memoryTips != null)
                'memoryTips': {
                  if (word.memoryTips!.etymology != null)
                    'etymology': word.memoryTips!.etymology,
                  if (word.memoryTips!.mnemonic != null)
                    'mnemonic': word.memoryTips!.mnemonic,
                  if (word.memoryTips!.association != null)
                    'association': word.memoryTips!.association,
                },
              if (word.definitions != null && word.definitions!.isNotEmpty)
                'definitions': word.definitions!
                    .map(
                      (item) => {
                        'partOfSpeech': item.partOfSpeech,
                        'meaning': item.meaning,
                      },
                    )
                    .toList(),
              if (word.structuredExamples != null &&
                  word.structuredExamples!.isNotEmpty)
                'structuredExamples': word.structuredExamples!
                    .map(
                      (item) => {
                        'english': item.english,
                        'chinese': item.chinese,
                        if (item.partOfSpeech != null)
                          'partOfSpeech': item.partOfSpeech,
                        if (item.meaning != null) 'meaning': item.meaning,
                      },
                    )
                    .toList(),
              if (word.collocations != null && word.collocations!.isNotEmpty)
                'collocations': word.collocations!
                    .map(
                      (item) => {
                        'phrase': item.phrase,
                        'translation': item.translation,
                      },
                    )
                    .toList(),
            },
          )
          .toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  static BookImportData decode(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final rawWords = data['words'] as List<dynamic>? ?? [];

    return BookImportData(
      title: data['title'] as String? ?? '导入单词书',
      description: data['description'] as String?,
      category: data['category'] as String? ?? 'custom',
      coverColor: data['coverColor'] as String? ?? '#607D8B',
      words: rawWords.map((item) {
        final map = item as Map<String, dynamic>;
        final memoryTipsMap = map['memoryTips'] as Map<String, dynamic>?;
        return WordImportData(
          english: map['english'] as String,
          chinese: map['chinese'] as String,
          phonetic: map['phonetic'] as String?,
          partOfSpeech: map['partOfSpeech'] as String?,
          examples: (map['examples'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
          imageUrl: map['imageUrl'] as String?,
          memoryTips: memoryTipsMap == null
              ? null
              : MemoryTipsImport(
                  etymology: memoryTipsMap['etymology'] as String?,
                  mnemonic: memoryTipsMap['mnemonic'] as String?,
                  association: memoryTipsMap['association'] as String?,
                ),
          definitions: (map['definitions'] as List<dynamic>?)
              ?.map((entry) {
                final definition = entry as Map<String, dynamic>;
                return WordDefinitionImport(
                  partOfSpeech: definition['partOfSpeech'] as String? ?? '释义',
                  meaning: definition['meaning'] as String? ?? '',
                );
              })
              .where((item) => item.meaning.isNotEmpty)
              .toList(),
          structuredExamples: (map['structuredExamples'] as List<dynamic>?)
              ?.map((entry) {
                final example = entry as Map<String, dynamic>;
                return WordExampleImport(
                  english: example['english'] as String? ?? '',
                  chinese: example['chinese'] as String? ?? '',
                  partOfSpeech: example['partOfSpeech'] as String?,
                  meaning: example['meaning'] as String?,
                );
              })
              .where((item) => item.english.isNotEmpty)
              .toList(),
          collocations: (map['collocations'] as List<dynamic>?)
              ?.map((entry) {
                final phrase = entry as Map<String, dynamic>;
                return WordPhraseImport(
                  phrase: phrase['phrase'] as String? ?? '',
                  translation: phrase['translation'] as String? ?? '',
                );
              })
              .where((item) => item.phrase.isNotEmpty)
              .toList(),
        );
      }).toList(),
    );
  }
}

class BookImportData {
  const BookImportData({
    required this.title,
    this.description,
    required this.category,
    this.coverColor,
    required this.words,
  });

  final String title;
  final String? description;
  final String category;
  final String? coverColor;
  final List<WordImportData> words;
}

class WordImportData {
  const WordImportData({
    required this.english,
    required this.chinese,
    this.phonetic,
    this.partOfSpeech,
    this.examples,
    this.imageUrl,
    this.memoryTips,
    this.definitions,
    this.structuredExamples,
    this.collocations,
  });

  final String english;
  final String chinese;
  final String? phonetic;
  final String? partOfSpeech;
  final List<String>? examples;
  final String? imageUrl;
  final MemoryTipsImport? memoryTips;
  final List<WordDefinitionImport>? definitions;
  final List<WordExampleImport>? structuredExamples;
  final List<WordPhraseImport>? collocations;
}

class WordDefinitionImport {
  const WordDefinitionImport({
    required this.partOfSpeech,
    required this.meaning,
  });

  final String partOfSpeech;
  final String meaning;
}

class WordExampleImport {
  const WordExampleImport({
    required this.english,
    required this.chinese,
    this.partOfSpeech,
    this.meaning,
  });

  final String english;
  final String chinese;
  final String? partOfSpeech;
  final String? meaning;
}

class WordPhraseImport {
  const WordPhraseImport({
    required this.phrase,
    required this.translation,
  });

  final String phrase;
  final String translation;
}

class MemoryTipsImport {
  const MemoryTipsImport({
    this.etymology,
    this.mnemonic,
    this.association,
  });

  final String? etymology;
  final String? mnemonic;
  final String? association;
}