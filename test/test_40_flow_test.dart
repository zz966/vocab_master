import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/core/study_mode.dart';
import 'package:vocab_master/models/book_model.dart';
import 'package:vocab_master/utils/level_challenge.dart';
import 'package:vocab_master/utils/level_utils.dart';
import 'package:vocab_master/utils/quiz_generator.dart';

const challengeModes = <StudyMode>[
  StudyMode.quiz,
  StudyMode.spelling,
  StudyMode.listening,
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TEST_40 full challenge flow', () {
    late Book book;
    late List<BookLevel> levels;

    setUpAll(() async {
      final jsonStr = await rootBundle.loadString('assets/books/test_40.json');
      book = Book.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
      levels = splitWordsIntoLevels(book.words);
    });

    test('loads 40 words and splits into two levels', () {
      expect(book.bookId, 'TEST_40');
      expect(book.words.length, 40);
      expect(levels.length, 2);
      expect(levels[0].wordCount, 30);
      expect(levels[1].wordCount, 10);
    });

    test('each level supports quiz, spelling, and listening sessions', () {
      for (final level in levels) {
        for (final mode in challengeModes) {
          final ref = LevelChallengeRef(
            bookId: book.bookId,
            levelIndex: level.index,
            mode: mode,
          );

          final parsed = parseLevelChallengeSessionType(ref.sessionType);
          expect(parsed?.bookId, ref.bookId, reason: '${level.index} ${mode.name}');
          expect(parsed?.levelIndex, ref.levelIndex);
          expect(parsed?.mode, ref.mode);

          for (final word in level.words) {
            expect(word.word.trim(), isNotEmpty, reason: mode.name);
            expect(word.definitionCn.trim(), isNotEmpty, reason: mode.name);
            expect(word.phoneticUk.trim(), isNotEmpty, reason: mode.name);

            if (mode == StudyMode.quiz || mode == StudyMode.listening) {
              final options = QuizGenerator.generateOptions(
                correct: word,
                pool: level.words,
                pickEnglish: false,
              );
              final answer = word.definitionCn.trim();

              expect(options, hasLength(4));
              expect(
                QuizGenerator.isValidQuizOptions(
                  options: options,
                  correctAnswer: answer,
                ),
                isTrue,
                reason: '${word.word} level ${level.index}',
              );
              expect(QuizGenerator.containsPlaceholder(options), isFalse);
            }
          }
        }
      }
    });

    test('perfect challenge scores award stars for each mode', () {
      for (final level in levels) {
        for (final mode in challengeModes) {
          expect(
            isPerfectChallengeScore(
              totalWords: level.wordCount,
              wordsStudied: level.wordCount,
              wordsCorrect: level.wordCount,
            ),
            isTrue,
            reason: 'level ${level.index} ${mode.name}',
          );
        }
      }
    });

    test('three perfect modes earn three stars', () {
      final stars = calculateChallengeStars(
        challengeModes.map((mode) => mode.name),
      );
      expect(stars, 3);
    });

    test('level words are unique within each level', () {
      for (final level in levels) {
        final ids = level.words.map((word) => word.id).toSet();
        final english = level.words.map((word) => word.word.trim().toLowerCase()).toSet();
        final chinese =
            level.words.map((word) => word.definitionCn.trim()).toSet();

        expect(ids.length, level.wordCount);
        expect(english.length, level.wordCount);
        expect(chinese.length, level.wordCount);
      }
    });
  });
}