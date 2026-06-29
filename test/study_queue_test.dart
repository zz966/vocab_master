import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/study_queue.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('buildStudyQueue orders by ascending familiarity', () {
    final queue = buildStudyQueue(
      [
        testWord(id: 'w1', english: 'zebra', familiarity: 3),
        testWord(id: 'w2', english: 'apple', familiarity: 0),
        testWord(id: 'w3', english: 'mango', familiarity: 1),
      ],
      StudyQueueOrder.familiarity,
    );

    expect(queue.map((w) => w.english).toList(), ['apple', 'mango', 'zebra']);
  });

  test('buildStudyQueue random mode preserves word count', () {
    final input = [
      testWord(id: 'w1', english: 'a', familiarity: 0),
      testWord(id: 'w2', english: 'b', familiarity: 2),
      testWord(id: 'w3', english: 'c', familiarity: 1),
    ];
    final queue = buildStudyQueue(input, StudyQueueOrder.random);

    expect(queue, hasLength(3));
    expect(queue.map((w) => w.english).toSet(), {'a', 'b', 'c'});
  });
}