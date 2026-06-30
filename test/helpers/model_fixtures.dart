import 'package:vocab_master/models/book_model.dart';
import 'package:vocab_master/models/learning_session.dart';
import 'package:vocab_master/models/review_record.dart';
import 'package:vocab_master/models/word.dart';

List<BookWordExample> _examplesFromStrings(List<String>? examples) {
  if (examples == null) {
    return [];
  }
  return examples
      .map((raw) {
        final separator = raw.indexOf(': ');
        if (separator == -1) {
          return BookWordExample(en: raw.trim(), cn: '');
        }
        return BookWordExample(
          en: raw.substring(0, separator).trim(),
          cn: raw.substring(separator + 2).trim(),
        );
      })
      .toList();
}

Word testWord({
  String id = 'word_1',
  String english = 'test',
  String chinese = '测试',
  List<String> bookIds = const ['book_1'],
  int reviewCount = 0,
  DateTime? nextReview,
  int familiarity = 0,
  List<String>? examples,
}) {
  return BookWord(
    id: id,
    word: english,
    definitionCn: chinese,
    bookIds: bookIds,
    reviewCount: reviewCount,
    lastReviewTime: nextReview,
    masteryLevel: familiarity,
    sentenceExamples: _examplesFromStrings(examples),
  );
}

Book testBook({
  String bookId = 'book_1',
  String bookName = 'Test Book',
  String description = '',
  String category = 'custom',
  String coverColor = '#607D8B',
}) {
  return Book(
    bookId: bookId,
    bookName: bookName,
    description: description,
    category: category,
    coverColor: coverColor,
  );
}

LearningSession testSession({
  String id = 'session_1',
  String sessionType = 'quiz',
  List<String> bookIds = const ['book_1'],
  DateTime? startedAt,
  DateTime? completedAt,
  int wordsStudied = 0,
  int wordsCorrect = 0,
}) {
  return LearningSession(
    id: id,
    sessionType: sessionType,
    bookIds: bookIds,
    startedAt: startedAt,
    completedAt: completedAt,
    wordsStudied: wordsStudied,
    wordsCorrect: wordsCorrect,
  );
}

ReviewRecord testReviewRecord({
  String id = 'review_1',
  String wordId = 'word_1',
  String? bookId = 'book_1',
  int quality = 3,
  DateTime? reviewedAt,
}) {
  return ReviewRecord(
    id: id,
    wordId: wordId,
    bookId: bookId,
    quality: quality,
    reviewedAt: reviewedAt ?? DateTime.now(),
  );
}