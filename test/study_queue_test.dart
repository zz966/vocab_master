import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/study_queue.dart';

Word _word(String english, {int familiarity = 0}) {
  return Word()
    ..english = english
    ..chinese = english
    ..bookIds = [1]
    ..familiarity = familiarity;
}

void main() {
  test('buildStudyQueue orders by ascending familiarity', () {
    final queue = buildStudyQueue(
      [
        _word('zebra', familiarity: 3),
        _word('apple', familiarity: 0),
        _word('mango', familiarity: 1),
      ],
      StudyQueueOrder.familiarity,
    );

    expect(queue.map((w) => w.english).toList(), ['apple', 'mango', 'zebra']);
  });

  test('buildStudyQueue random mode preserves word count', () {
    final input = [
      _word('a', familiarity: 0),
      _word('b', familiarity: 2),
      _word('c', familiarity: 1),
    ];
    final queue = buildStudyQueue(input, StudyQueueOrder.random);

    expect(queue, hasLength(3));
    expect(queue.map((w) => w.english).toSet(), {'a', 'b', 'c'});
  });
}