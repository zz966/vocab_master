import '../models/word.dart';

const int wordsPerLevel = 30;

class BookLevel {
  const BookLevel({
    required this.index,
    required this.words,
  });

  final int index;
  final List<Word> words;

  int get wordCount => words.length;
}

List<BookLevel> splitWordsIntoLevels(
  List<Word> words, {
  int chunkSize = wordsPerLevel,
}) {
  if (words.isEmpty) {
    return const [];
  }

  final sorted = words.toList()
    ..sort((a, b) => a.english.compareTo(b.english));

  final levels = <BookLevel>[];
  for (var i = 0; i < sorted.length; i += chunkSize) {
    final end = (i + chunkSize).clamp(0, sorted.length);
    levels.add(
      BookLevel(
        index: levels.length,
        words: sorted.sublist(i, end),
      ),
    );
  }
  return levels;
}

String levelDisplayName(int index) => '第${chineseOrdinal(index + 1)}关';

String chineseOrdinal(int number) {
  if (number <= 0) {
    return number.toString();
  }
  if (number < 10) {
    return const ['一', '二', '三', '四', '五', '六', '七', '八', '九'][number - 1];
  }
  if (number < 20) {
    return number == 10 ? '十' : '十${chineseOrdinal(number - 10)}';
  }
  if (number < 100) {
    final tens = number ~/ 10;
    final ones = number % 10;
    final tensPart = '${chineseOrdinal(tens)}十';
    return ones == 0 ? tensPart : '$tensPart${chineseOrdinal(ones)}';
  }
  return number.toString();
}