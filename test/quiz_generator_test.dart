import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/book_model.dart';
import 'package:vocab_master/utils/quiz_generator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuizGenerator with test_40', () {
    late List<BookWord> words;

    setUpAll(() async {
      final jsonStr = await rootBundle.loadString('assets/books/test_40.json');
      final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
      words = book.words;
    });

    test('generates four unique quiz options for every word', () {
      final random = Random(42);
      for (final word in words) {
        for (final pickEnglish in [true, false]) {
          final options = QuizGenerator.generateOptions(
            correct: word,
            pool: words,
            pickEnglish: pickEnglish,
            random: random,
          );

          final answer =
              pickEnglish ? word.word.trim() : word.definitionCn.trim();

          expect(options, hasLength(4));
          expect(
            options.toSet(),
            hasLength(4),
            reason: '${word.word} ${pickEnglish ? 'en' : 'cn'} options',
          );
          expect(
            QuizGenerator.isValidQuizOptions(
              options: options,
              correctAnswer: answer,
            ),
            isTrue,
            reason: '${word.word} must have exactly one correct option',
          );
          expect(
            QuizGenerator.containsPlaceholder(options),
            isFalse,
            reason: '${word.word} should not use placeholder distractors',
          );
          expect(options, contains(answer));
        }
      }
    });

    test('level pools still provide four unique listening options', () {
      final levelOne = words.take(30).toList();
      final levelTwo = words.skip(30).toList();

      for (final level in [levelOne, levelTwo]) {
        for (final word in level) {
          final options = QuizGenerator.generateOptions(
            correct: word,
            pool: level,
            pickEnglish: false,
            random: Random(7),
          );

          final answer = word.definitionCn.trim();

          expect(options, hasLength(4));
          expect(options.toSet(), hasLength(4));
          expect(
            QuizGenerator.isValidQuizOptions(
              options: options,
              correctAnswer: answer,
            ),
            isTrue,
          );
          expect(QuizGenerator.containsPlaceholder(options), isFalse);
        }
      }
    });
  });
}