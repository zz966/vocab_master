import '../models/word.dart';

/// Fills multimedia learning fields for words imported from basic vocab data.
class WordEnrichment {
  WordEnrichment._();

  static const _prefixes = <String, String>{
    'un': '否定前缀，表示「不、非」',
    're': '前缀，表示「再次、重新」',
    'pre': '前缀，表示「预先、在前」',
    'dis': '前缀，表示「否定、分离」',
    'mis': '前缀，表示「错误、误」',
    'over': '前缀，表示「过度、超过」',
    'under': '前缀，表示「不足、在…下」',
    'inter': '前缀，表示「在…之间、相互」',
    'trans': '前缀，表示「跨越、转移」',
    'anti': '前缀，表示「反对、对抗」',
  };

  static const _suffixes = <String, String>{
    'tion': '名词后缀，常表示行为、过程或结果',
    'sion': '名词后缀，常表示状态或行为',
    'ment': '名词后缀，表示行为或结果',
    'ness': '名词后缀，表示性质或状态',
    'able': '形容词后缀，表示「能够…的」',
    'ible': '形容词后缀，表示「可…的」',
    'ful': '形容词后缀，表示「充满…的」',
    'less': '形容词后缀，表示「没有…的」',
    'ize': '动词后缀，表示「使成为、使…化」',
    'ise': '动词后缀，表示「使成为、使…化」',
    'ly': '副词后缀，表示「…地」',
    'ous': '形容词后缀，表示「具有…性质的」',
    'ive': '形容词后缀，表示「有…倾向的」',
    'ity': '名词后缀，表示性质或状态',
  };

  static void apply(Word word, {List<String>? peerWords}) {
    word.memoryTips ??= _buildMemoryTips(word);
    word.definitions ??= _buildDefinitions(word);
    word.structuredExamples ??= _buildStructuredExamples(word);
    word.structuredExamples = _ensureExamplesForDefinitions(word);
    word.collocations ??= _buildCollocations(word);
    word.confusableWords ??= _buildConfusableWords(word, peerWords ?? const []);
    word.examples ??= _legacyExamples(word);
  }

  /// Finds peer words with overlapping Chinese meanings for the synonyms tab.
  static List<ConfusableWord> buildSynonyms(
    Word word,
    List<Word> peers,
  ) {
    final segments = _meaningSegments(word.chinese);
    if (segments.isEmpty) {
      return const [];
    }

    final results = <ConfusableWord>[];
    for (final peer in peers) {
      if (peer.id == word.id ||
          peer.english.toLowerCase() == word.english.toLowerCase()) {
        continue;
      }

      final peerSegments = _meaningSegments(peer.chinese);
      final overlap = segments.any(
        (segment) => peerSegments.any(
          (peerSegment) =>
              segment == peerSegment ||
              segment.contains(peerSegment) ||
              peerSegment.contains(segment),
        ),
      );
      if (!overlap) {
        continue;
      }

      results.add(
        ConfusableWord()
          ..word = peer.english
          ..explanation = peer.chinese.split(RegExp(r'[；;,，]')).first.trim(),
      );
      if (results.length >= 6) {
        break;
      }
    }
    return results;
  }

  static Set<String> _meaningSegments(String chinese) {
    return chinese
        .split(RegExp(r'[；;,，/]'))
        .map((segment) => segment.trim())
        .where((segment) => segment.length >= 2)
        .toSet();
  }

  static MemoryTips _buildMemoryTips(Word word) {
    final tips = MemoryTips();
    tips.etymology = _analyzeEtymology(word.english);
    tips.mnemonic = _buildMnemonic(word);
    tips.association = '联想：${word.english} → ${word.chinese.split('；').first}';
    return tips;
  }

  static String? _analyzeEtymology(String english) {
    final lower = english.toLowerCase();
    final parts = <String>[];

    for (final entry in _prefixes.entries) {
      if (lower.startsWith(entry.key) && lower.length > entry.key.length + 2) {
        parts.add('${entry.key}-：${entry.value}');
        break;
      }
    }

    for (final entry in _suffixes.entries) {
      if (lower.endsWith(entry.key) && lower.length > entry.key.length + 2) {
        parts.add('-${entry.key}：${entry.value}');
        break;
      }
    }

    if (parts.isEmpty) {
      return null;
    }
    return parts.join('；');
  }

  static String? _buildMnemonic(Word word) {
    final lower = word.english.toLowerCase();
    final meaning = word.chinese.split(RegExp(r'[；;，,]')).first.trim();
    if (meaning.isEmpty) {
      return null;
    }

    if (lower.length <= 6) {
      return '谐音联想：${word.english} 读起来像「$meaning」相关的发音，帮助记住含义。';
    }
    return '拆分记忆：把 ${word.english} 拆成音节朗读，再联系「$meaning」。';
  }

  static List<WordDefinition> _buildDefinitions(Word word) {
    if (word.partOfSpeech == null || word.partOfSpeech!.trim().isEmpty) {
      return [
        WordDefinition()
          ..partOfSpeech = '释义'
          ..meaning = word.chinese,
      ];
    }

    final segments = word.chinese.split('；');
    final types = word.partOfSpeech!.split('/');

    if (types.length == segments.length) {
      return List.generate(types.length, (index) {
        return WordDefinition()
          ..partOfSpeech = types[index].trim()
          ..meaning = segments[index].trim();
      });
    }

    return [
      WordDefinition()
        ..partOfSpeech = word.partOfSpeech!.trim()
        ..meaning = word.chinese,
    ];
  }

  static List<WordExample> _buildStructuredExamples(Word word) {
    final examples = <WordExample>[];
    final definitions = word.definitions ?? _buildDefinitions(word);

    if (word.examples != null) {
      for (final raw in word.examples!) {
        final parsed = _parseLegacyExample(raw);
        examples.add(
          WordExample()
            ..english = parsed.english
            ..chinese = parsed.chinese
            ..partOfSpeech = definitions.first.partOfSpeech
            ..meaning = definitions.first.meaning,
        );
      }
    }

    final collocations = word.collocations ?? _buildCollocations(word);
    for (var i = 0; i < definitions.length; i++) {
      final definition = definitions[i];
      final assigned = collocations
          .where(
            (item) =>
                item.phrase.toLowerCase().contains(word.english.toLowerCase()),
          )
          .skip(i)
          .take(2)
          .toList();

      for (final phrase in assigned) {
        examples.add(
          WordExample()
            ..english = _exampleFromPhrase(word.english, phrase.phrase)
            ..chinese = phrase.translation
            ..partOfSpeech = definition.partOfSpeech
            ..meaning = definition.meaning,
        );
      }
    }

    if (examples.isEmpty && definitions.isNotEmpty) {
      final definition = definitions.first;
      examples.add(
        WordExample()
          ..english = 'This word means "${definition.meaning}".'
          ..chinese = '这个单词的意思是「${definition.meaning}」。'
          ..partOfSpeech = definition.partOfSpeech
          ..meaning = definition.meaning,
      );
    }

    return examples;
  }

  static List<WordExample> _ensureExamplesForDefinitions(Word word) {
    final definitions = word.definitions ?? _buildDefinitions(word);
    final examples = [...(word.structuredExamples ?? const <WordExample>[])];

    for (final definition in definitions) {
      final hasExample = examples.any((example) {
        return example.partOfSpeech == definition.partOfSpeech &&
            example.meaning == definition.meaning &&
            example.english.trim().isNotEmpty;
      });
      if (hasExample) {
        continue;
      }
      examples.add(
        WordExample()
          ..english = _exampleForDefinition(word.english, definition)
          ..chinese = '这个例句用于记忆「${definition.meaning}」这个含义。'
          ..partOfSpeech = definition.partOfSpeech
          ..meaning = definition.meaning,
      );
    }

    return examples;
  }

  static String _exampleForDefinition(String word, WordDefinition definition) {
    final type = definition.partOfSpeech.trim().isEmpty
        ? 'meaning'
        : definition.partOfSpeech.trim();
    return 'The word "$word" can be used as $type to mean "${definition.meaning}".';
  }

  static List<WordPhrase> _buildCollocations(Word word) {
    if (word.examples == null) {
      return [];
    }

    return word.examples!
        .map(_parseLegacyExample)
        .where((item) => item.chinese.isNotEmpty)
        .map(
          (item) => WordPhrase()
            ..phrase = item.english
            ..translation = item.chinese,
        )
        .where((item) => item.phrase.split(' ').length <= 5)
        .take(8)
        .toList();
  }

  static List<ConfusableWord> _buildConfusableWords(
    Word word,
    List<String> peerWords,
  ) {
    final lower = word.english.toLowerCase();
    final candidates = peerWords
        .where((peer) => peer.toLowerCase() != lower)
        .where((peer) => _isSimilar(lower, peer.toLowerCase()))
        .take(3)
        .toList();

    return candidates
        .map(
          (peer) => ConfusableWord()
            ..word = peer
            ..explanation =
                '「$peer」与「${word.english}」拼写相近，注意区分含义：${word.chinese.split('；').first}。'
            ..exampleEnglish =
                'Compare "$peer" and "${word.english}" in context.'
            ..exampleChinese = '在语境中区分 $peer 与 ${word.english} 的用法。',
        )
        .toList();
  }

  static List<String>? _legacyExamples(Word word) {
    final structured =
        word.structuredExamples ?? _buildStructuredExamples(word);
    if (structured.isEmpty) {
      return word.examples;
    }
    return structured.map((item) {
      if (item.chinese.isEmpty) {
        return item.english;
      }
      return '${item.english}: ${item.chinese}';
    }).toList();
  }

  static bool _isSimilar(String a, String b) {
    if ((a.length - b.length).abs() > 2) {
      return false;
    }
    if (a.startsWith(b.substring(0, b.length.clamp(0, 3))) ||
        b.startsWith(a.substring(0, a.length.clamp(0, 3)))) {
      return true;
    }
    return _editDistance(a, b) <= 2;
  }

  static int _editDistance(String a, String b) {
    final dp = List.generate(a.length + 1, (_) => List.filled(b.length + 1, 0));
    for (var i = 0; i <= a.length; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= b.length; j++) {
      dp[0][j] = j;
    }
    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost,
        ].reduce((left, right) => left < right ? left : right);
      }
    }
    return dp[a.length][b.length];
  }

  static _ParsedExample _parseLegacyExample(String raw) {
    final separator = raw.indexOf(': ');
    if (separator == -1) {
      return _ParsedExample(english: raw.trim(), chinese: '');
    }
    return _ParsedExample(
      english: raw.substring(0, separator).trim(),
      chinese: raw.substring(separator + 2).trim(),
    );
  }

  static String _exampleFromPhrase(String word, String phrase) {
    final trimmed = phrase.trim();
    if (trimmed.isEmpty) {
      return 'Use the word "$word" in a sentence.';
    }
    if (trimmed.toLowerCase().contains(word.toLowerCase())) {
      final first = trimmed[0].toUpperCase();
      final rest = trimmed.length > 1 ? trimmed.substring(1) : '';
      return '$first$rest.';
    }
    return 'A common phrase is "$trimmed" with "$word".';
  }
}

class _ParsedExample {
  const _ParsedExample({required this.english, required this.chinese});

  final String english;
  final String chinese;
}
