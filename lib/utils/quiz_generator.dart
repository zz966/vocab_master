import 'dart:math';

import '../models/word.dart';

class QuizGenerator {
  static final _random = Random();

  static List<String> generateOptions({
    required Word correct,
    required List<Word> pool,
    required bool pickEnglish,
  }) {
    final answer = pickEnglish ? correct.english : correct.chinese;
    final options = <String>{answer};

    final samePos = pool
        .where(
          (word) =>
              word.id != correct.id &&
              word.partOfSpeech != null &&
              word.partOfSpeech == correct.partOfSpeech,
        )
        .toList()
      ..shuffle(_random);

    final others = pool.where((word) => word.id != correct.id).toList()
      ..shuffle(_random);

    for (final word in [...samePos, ...others]) {
      if (options.length >= 4) {
        break;
      }
      final option = pickEnglish ? word.english : word.chinese;
      if (option != answer) {
        options.add(option);
      }
    }

    while (options.length < 4) {
      options.add('${pickEnglish ? 'option' : '选项'}_${options.length}');
    }

    final result = options.toList()..shuffle(_random);
    return result;
  }
}