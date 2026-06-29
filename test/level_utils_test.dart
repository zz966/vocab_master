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