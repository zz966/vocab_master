import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/level_utils.dart';

Word _word(String english, {bool learned = false}) {
  return BookWord(
    id: english,
    word: english,
    definitionCn: english,
    learned: learned,
  );
}

void main() {
  test('levelBrowseProgress matches word detail session progress', () {
    expect(
      levelBrowseProgress(currentIndex: 0, totalWords: 30),
      closeTo(1 / 30, 0.0001),
    );
    expect(levelBrowseProgressPercent(currentIndex: 2, totalWords: 30), 10);
    expect(levelBrowseProgressPercent(currentIndex: -1, totalWords: 30), 0);
    expect(levelBrowseProgressPercent(currentIndex: 29, totalWords: 30), 100);
  });

  test('splitWordsIntoLevels chunks by 30', () {
    final words = List.generate(65, (index) => _word('w$index'));
    final levels = splitWordsIntoLevels(words);

    expect(levels.length, 3);
    expect(levels[0].words.length, 30);
    expect(levels[1].words.length, 30);
    expect(levels[2].words.length, 5);
  });
}