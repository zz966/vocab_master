import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/level_utils.dart';

Word _word(String english, {int familiarity = 0}) {
  return BookWord(
    id: english,
    word: english,
    definitionCn: english,
    masteryLevel: familiarity,
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
    expect(levels[0].wordCount, 30);
    expect(levels[1].wordCount, 30);
    expect(levels[2].wordCount, 5);
    expect(levelDisplayName(0), '第一关');
    expect(levelDisplayName(9), '第十关');
  });

}