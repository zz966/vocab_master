import 'dart:math';

import '../models/word.dart';

class QuizGenerator {
  QuizGenerator._();

  static final _random = Random();

  static const placeholderPrefixes = ['option_', '选项_'];
  static const optionCount = 4;

  static List<String> generateOptions({
    required Word correct,
    required List<Word> pool,
    required bool pickEnglish,
    Random? random,
  }) {
    final rng = random ?? _random;
    final correctDisplay = _optionText(correct, pickEnglish);
    final answerKey = _normalize(correctDisplay);
    if (answerKey.isEmpty) {
      return const [];
    }

    final usedKeys = <String>{answerKey};
    final options = <String>[correctDisplay];

    final candidates = <String>[];
    for (final word in pool) {
      if (word.id == correct.id) {
        continue;
      }
      for (final text in _textsForWord(word, pickEnglish)) {
        final key = _normalize(text);
        if (key.isEmpty || key == answerKey || usedKeys.contains(key)) {
          continue;
        }
        usedKeys.add(key);
        candidates.add(text);
      }
    }
    candidates.shuffle(rng);

    for (final candidate in candidates) {
      if (options.length >= optionCount) {
        break;
      }
      options.add(candidate);
    }

    var filler = 1;
    while (options.length < optionCount) {
      final placeholder =
          pickEnglish ? 'option_$filler' : '选项_$filler';
      filler += 1;
      final key = _normalize(placeholder);
      if (usedKeys.add(key)) {
        options.add(placeholder);
      }
    }

    final result = List<String>.from(options)..shuffle(rng);
    assert(
      isValidQuizOptions(options: result, correctAnswer: correctDisplay),
      'Quiz options must be 4 unique strings with exactly one correct answer',
    );
    return result;
  }

  static bool isValidQuizOptions({
    required List<String> options,
    required String correctAnswer,
  }) {
    if (options.length != optionCount) {
      return false;
    }

    final normalized = options.map(_normalize).toList();
    if (normalized.toSet().length != optionCount) {
      return false;
    }

    final correctMatches =
        normalized.where((item) => item == _normalize(correctAnswer)).length;
    return correctMatches == 1;
  }

  static bool matchesAnswer(String selected, String correctAnswer) {
    return _normalize(selected) == _normalize(correctAnswer);
  }

  static bool containsPlaceholder(Iterable<String> options) {
    return options.any(
      (option) => placeholderPrefixes.any(option.startsWith),
    );
  }

  static Iterable<String> _textsForWord(Word word, bool pickEnglish) {
    if (pickEnglish) {
      final english = word.english.trim();
      return english.isEmpty ? const [] : [english];
    }

    final texts = <String>[];
    final seen = <String>{};

    void addText(String? raw) {
      final text = raw?.trim() ?? '';
      final key = _normalize(text);
      if (text.isEmpty || seen.contains(key)) {
        return;
      }
      seen.add(key);
      texts.add(text);
    }

    addText(word.chinese);
    for (final definition in word.definitions ?? const []) {
      addText(definition.meaning);
    }

    return texts;
  }

  static String _optionText(Word word, bool pickEnglish) {
    return (pickEnglish ? word.english : word.chinese).trim();
  }

  static String _normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}