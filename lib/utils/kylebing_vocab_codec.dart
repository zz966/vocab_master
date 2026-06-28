import 'dart:convert';

import 'book_export.dart';

/// Parses KyleBing/english-vocabulary json-simple format.
class KyleBingVocabCodec {
  static List<WordImportData> decode(String json) {
    final raw = jsonDecode(json);
    if (raw is! List<dynamic>) {
      throw FormatException('KyleBing vocab JSON must be an array');
    }

    return raw.map((item) {
      final map = item as Map<String, dynamic>;
      final english = map['word'] as String? ?? '';
      final translations =
          map['translations'] as List<dynamic>? ?? const [];
      final phrases = map['phrases'] as List<dynamic>? ?? const [];

      if (english.trim().isEmpty) {
        throw FormatException('KyleBing vocab entry missing word field');
      }

      final definitions = _parseDefinitions(translations);
      final chinese = definitions.map((item) => item.meaning).join('；');
      if (chinese.isEmpty) {
        throw FormatException('KyleBing vocab entry missing translations');
      }

      final phraseItems = _parsePhrases(phrases);
      final collocations = phraseItems
          .where((item) => item.phrase.split(' ').length <= 5)
          .take(8)
          .toList();
      final structuredExamples = _buildStructuredExamples(
        english: english.trim(),
        definitions: definitions,
        phraseItems: phraseItems,
      );

      return WordImportData(
        english: english.trim(),
        chinese: chinese,
        partOfSpeech: _combineTypes(definitions),
        examples: phraseItems
            .map((item) => '${item.phrase}: ${item.translation}')
            .toList(),
        definitions: definitions,
        collocations: collocations,
        structuredExamples: structuredExamples,
      );
    }).toList();
  }

  static List<WordDefinitionImport> _parseDefinitions(List<dynamic> translations) {
    return translations
        .map((item) {
          final map = item as Map<String, dynamic>;
          final meaning = map['translation'] as String? ?? '';
          final type = map['type'] as String?;
          if (meaning.trim().isEmpty) {
            return null;
          }
          return WordDefinitionImport(
            partOfSpeech: _formatPartOfSpeech(type),
            meaning: meaning.trim(),
          );
        })
        .whereType<WordDefinitionImport>()
        .toList();
  }

  static List<WordPhraseImport> _parsePhrases(List<dynamic> phrases) {
    return phrases
        .map((item) {
          final map = item as Map<String, dynamic>;
          final phrase = map['phrase'] as String? ?? '';
          final translation = map['translation'] as String? ?? '';
          if (phrase.trim().isEmpty) {
            return null;
          }
          return WordPhraseImport(
            phrase: phrase.trim(),
            translation: translation.trim(),
          );
        })
        .whereType<WordPhraseImport>()
        .toList();
  }

  static List<WordExampleImport> _buildStructuredExamples({
    required String english,
    required List<WordDefinitionImport> definitions,
    required List<WordPhraseImport> phraseItems,
  }) {
    if (definitions.isEmpty) {
      return [];
    }

    final examples = <WordExampleImport>[];
    for (var i = 0; i < definitions.length; i++) {
      final definition = definitions[i];
      final assigned = phraseItems.skip(i * 2).take(2).toList();
      for (final phrase in assigned) {
        examples.add(
          WordExampleImport(
            english: _exampleFromPhrase(english, phrase.phrase),
            chinese: phrase.translation,
            partOfSpeech: definition.partOfSpeech,
            meaning: definition.meaning,
          ),
        );
      }
    }

    if (examples.isEmpty && definitions.isNotEmpty) {
      final definition = definitions.first;
      examples.add(
        WordExampleImport(
          english: 'This word means "${definition.meaning}".',
          chinese: '这个单词的意思是「${definition.meaning}」。',
          partOfSpeech: definition.partOfSpeech,
          meaning: definition.meaning,
        ),
      );
    }

    return examples;
  }

  static String? _combineTypes(List<WordDefinitionImport> definitions) {
    final types = definitions
        .map((item) => item.partOfSpeech)
        .where((value) => value.trim().isNotEmpty)
        .toSet()
        .toList();
    if (types.isEmpty) {
      return null;
    }
    return types.join('/');
  }

  static String _formatPartOfSpeech(String? type) {
    if (type == null || type.trim().isEmpty) {
      return '释义';
    }
    return type.endsWith('.') ? type : '${type.trim()}.';
  }

  static String _exampleFromPhrase(String word, String phrase) {
    final trimmed = phrase.trim();
    if (trimmed.toLowerCase().contains(word.toLowerCase())) {
      final first = trimmed[0].toUpperCase();
      final rest = trimmed.length > 1 ? trimmed.substring(1) : '';
      return '$first$rest.';
    }
    return 'A common phrase is "$trimmed" with "$word".';
  }
}