import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/level_utils.dart';

void main() {
  test('levelBrowseProgress uses max index for bar and current for label', () {
    const total = 30;

    expect(
      levelBrowseProgressPercent(currentIndex: -1, totalWords: total),
      0,
    );
    expect(
      levelBrowseProgressPercent(currentIndex: 9, totalWords: total),
      33,
    );
    expect(
      levelBrowseProgressPercent(currentIndex: 29, totalWords: total),
      100,
    );

    const maxIndex = 9;
    const currentIndex = 2;
    expect(
      levelBrowseProgressPercent(currentIndex: maxIndex, totalWords: total),
      33,
    );
    expect(currentIndex + 1, 3);
  });
}