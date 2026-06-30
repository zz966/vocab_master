import '../models/word.dart';

const int quickBrowseWordsPerPage = 100;

int quickBrowseTotalPages(
  int wordCount, {
  int pageSize = quickBrowseWordsPerPage,
}) {
  if (wordCount <= 0) {
    return 1;
  }
  return (wordCount / pageSize).ceil();
}

int clampQuickBrowsePage(
  int page, {
  required int wordCount,
  int pageSize = quickBrowseWordsPerPage,
}) {
  final totalPages = quickBrowseTotalPages(wordCount, pageSize: pageSize);
  return page.clamp(1, totalPages);
}

List<Word> quickBrowsePageWords(
  List<Word> allWords, {
  required int page,
  int pageSize = quickBrowseWordsPerPage,
}) {
  if (allWords.isEmpty) {
    return const [];
  }

  final clampedPage = clampQuickBrowsePage(
    page,
    wordCount: allWords.length,
    pageSize: pageSize,
  );
  final start = (clampedPage - 1) * pageSize;
  final end = (start + pageSize).clamp(0, allWords.length);
  return allWords.sublist(start, end);
}

List<Word> sortWordsForQuickBrowse(List<Word> words) {
  return words.toList()..sort((a, b) => a.english.compareTo(b.english));
}