import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/book_model.dart';
import 'package:vocab_master/utils/quiz_generator.dart';
import 'package:vocab_master/utils/word_display_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('test_40.json loads 40 words', () async {
    final jsonStr = await rootBundle.loadString('assets/books/test_40.json');
    final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

    expect(book.bookId, 'TEST_40');
    expect(book.words.length, 40);
    expect(book.words.first.id, 'TEST_40_1');
    expect(book.words.last.word, 'insecure');

    final drag = book.words.firstWhere((word) => word.word == 'drag');
    expect(drag.phoneticUk, '/dræɡ/');
    expect(drag.phoneticUs, '/dræɡ/');
    for (final word in book.words) {
      expect(
        word.sentenceExamples.length,
        greaterThanOrEqualTo(3),
        reason: '${word.word} should have at least 3 examples',
      );
      expect(word.phoneticUk, isNotEmpty, reason: '${word.word} phoneticUk');
      expect(word.phoneticUs, isNotEmpty, reason: '${word.word} phoneticUs');
      expect(word.definitions, isNotNull, reason: '${word.word} definitions');
      expect(
        word.englishDefinitions,
        isNotNull,
        reason: '${word.word} englishDefinitions',
      );
      expect(word.synonyms, isNotEmpty, reason: '${word.word} synonyms');
      expect(word.synonymDetails, isNotNull, reason: '${word.word} synonymDetails');
      expect(
        word.synonymDetails!.every((item) => item.explanation.trim().isNotEmpty),
        isTrue,
        reason: '${word.word} synonym Chinese meanings',
      );
      if (word.collocations != null && word.collocations!.isNotEmpty) {
        expect(
          word.collocations!.every(
            (phrase) => (phrase.exampleEnglish ?? '').trim().isNotEmpty,
          ),
          isTrue,
          reason: '${word.word} phrase examples',
        );
      }
    }

    final ample = book.words.firstWhere((word) => word.word == 'ample');
    expect(ample.collocations, isNotNull);
    expect(ample.collocations!.first.phrase, 'ample evidence');
    expect(ample.collocations!.first.exampleEnglish, isNotEmpty);

    final disgrace = book.words.firstWhere((word) => word.word == 'disgrace');
    expect(displayDefinitions(disgrace).length, 2);

    final wordsWithoutPhrases = book.words
        .where((word) => word.collocations == null || word.collocations!.isEmpty)
        .map((word) => word.word)
        .toList();
    expect(wordsWithoutPhrases, isNotEmpty);
  });

  test('test_40.json supports quiz, spelling, and listening modes', () async {
    final jsonStr = await rootBundle.loadString('assets/books/test_40.json');
    final book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

    for (final word in book.words) {
      expect(word.word.trim(), isNotEmpty, reason: '${word.id} spelling/listening');
      expect(word.definitionCn.trim(), isNotEmpty, reason: '${word.id} quiz/spelling');
      expect(word.phoneticUk.trim(), isNotEmpty, reason: '${word.id} listening');
      expect(word.phoneticUs.trim(), isNotEmpty, reason: '${word.id} listening');
      expect(word.partOfSpeech.trim(), isNotEmpty, reason: '${word.id} quiz distractors');

      for (final pickEnglish in [true, false]) {
        final options = QuizGenerator.generateOptions(
          correct: word,
          pool: book.words,
          pickEnglish: pickEnglish,
        );
        final answer =
            pickEnglish ? word.word.trim() : word.definitionCn.trim();

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
}