import '../models/word.dart';

/// Builds definition lines for the word detail header.
List<WordDefinition> displayDefinitions(Word word) {
  final definitions = word.definitions ?? const <WordDefinition>[];
  if (definitions.length > 1) {
    return definitions;
  }

  if (definitions.length == 1) {
    final single = definitions.first;
    final split = _splitCombinedDefinition(
      partOfSpeech: single.partOfSpeech,
      meaning: single.meaning,
    );
    if (split.length > 1) {
      return split;
    }
    return definitions;
  }

  final split = _splitCombinedDefinition(
    partOfSpeech: word.partOfSpeech,
    meaning: word.chinese,
  );
  if (split.isNotEmpty) {
    return split;
  }

  if (word.chinese.trim().isEmpty) {
    return const [];
  }

  return [
    WordDefinition(
      partOfSpeech: word.partOfSpeech,
      meaning: word.chinese,
    ),
  ];
}

List<WordDefinition> _splitCombinedDefinition({
  required String partOfSpeech,
  required String meaning,
}) {
  final posParts = _splitPartOfSpeech(partOfSpeech);
  final meaningParts = _splitMeanings(meaning);

  if (posParts.length <= 1) {
    return const [];
  }

  if (meaningParts.length == posParts.length) {
    return List.generate(
      posParts.length,
      (index) => WordDefinition(
        partOfSpeech: posParts[index],
        meaning: meaningParts[index],
      ),
    );
  }

  if (meaningParts.length == 1) {
    return posParts
        .map(
          (pos) => WordDefinition(
            partOfSpeech: pos,
            meaning: meaningParts.first,
          ),
        )
        .toList();
  }

  return List.generate(
    posParts.length,
    (index) => WordDefinition(
      partOfSpeech: posParts[index],
      meaning: index < meaningParts.length
          ? meaningParts[index]
          : meaningParts.last,
    ),
  );
}

List<String> _splitPartOfSpeech(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return const [];
  }

  return trimmed
      .split(RegExp(r'[/／、,，]'))
      .map((part) {
        final value = part.trim();
        if (value.isEmpty) {
          return '';
        }
        return value.endsWith('.') ? value : '$value.';
      })
      .where((part) => part.isNotEmpty)
      .toList();
}

List<String> _splitMeanings(String raw) {
  return raw
      .split(RegExp(r'[；;]'))
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();
}