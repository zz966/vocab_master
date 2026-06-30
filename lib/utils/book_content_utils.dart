import '../models/book_model.dart';

/// 判断 [BookWord] 是否符合 test_40 富内容词库格式。
bool isRichBookWord(BookWord word) {
  if (word.sentenceExamples.length < 3) {
    return false;
  }
  if (word.phoneticUk.trim().isEmpty || word.phoneticUs.trim().isEmpty) {
    return false;
  }
  if (word.definitions == null || word.englishDefinitions == null) {
    return false;
  }
  if (word.synonymDetails == null || word.synonymDetails!.isEmpty) {
    return false;
  }
  if (word.synonymDetails!.any((item) => item.explanation.trim().isEmpty)) {
    return false;
  }
  return !_collocationsMissingExamples(word);
}

bool bookNeedsRichContentRefresh(Book book) {
  if (book.words.isEmpty) {
    return true;
  }
  return book.words.any((word) => !isRichBookWord(word));
}

/// assets 内置词书是否应覆盖 Hive 中已有数据。
bool bookNeedsBundledAssetRefresh({
  required Book? existing,
  required Book incoming,
}) {
  if (existing == null) {
    return true;
  }
  if (bookNeedsRichContentRefresh(existing)) {
    return true;
  }
  if (existing.words.length != incoming.words.length) {
    return true;
  }
  if (existing.totalWords != incoming.totalWords) {
    return true;
  }
  return false;
}

bool _collocationsMissingExamples(BookWord word) {
  final phrases = word.collocations;
  if (phrases == null || phrases.isEmpty) {
    return false;
  }
  return phrases.any(
    (phrase) => (phrase.exampleEnglish ?? '').trim().isEmpty,
  );
}

void preserveWordLearningState({
  required Book from,
  required Book into,
}) {
  final previousWords = {for (final word in from.words) word.id: word};
  for (final word in into.words) {
    final previous = previousWords[word.id];
    if (previous == null) {
      continue;
    }
    word.learned = previous.learned;
  }
}

void attachBookIds(Book book) {
  for (final word in book.words) {
    word.bookIds = [book.bookId];
  }
}