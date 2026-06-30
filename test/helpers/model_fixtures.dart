import 'package:vocab_master/models/answer_record.dart';
import 'package:vocab_master/models/book_model.dart';
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
  bool learned = false,
  List<String>? examples,
}) {
  return BookWord(
    id: id,
    word: english,
    definitionCn: chinese,
    bookIds: bookIds,
    learned: learned,
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

AnswerRecord testAnswerRecord({
  String id = 'answer_1',
  String wordId = 'word_1',
  String? bookId = 'book_1',
  DateTime? answeredAt,
}) {
  return AnswerRecord(
    id: id,
    wordId: wordId,
    bookId: bookId,
    answeredAt: answeredAt ?? DateTime.now(),
  );
}