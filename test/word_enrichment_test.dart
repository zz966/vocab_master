import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/word_enrichment.dart';

import 'helpers/model_fixtures.dart';

void main() {
  test('WordEnrichment fills memory tips and structured examples', () {
    final word = testWord(
      id: 'w1',
      english: 'absorb',
      chinese: '吸收；使全神贯注',
      examples: ['absorb in: 集中精力做某事'],
    )
      ..partOfSpeech = 'v.';

    WordEnrichment.apply(word, peerWords: ['abstract', 'absurd', 'absent']);

    expect(word.memoryTips, isNotNull);
    expect(word.memoryTips!.association, contains('absorb'));
    expect(word.definitions, isNotEmpty);
    expect(word.structuredExamples, isNotEmpty);
    expect(word.collocations, isNotEmpty);
    expect(word.confusableWords, isNotEmpty);
  });

  test('WordEnrichment guarantees examples for each definition', () {
    final word = testWord(
      id: 'w2',
      english: 'record',
      chinese: '记录；唱片',
      examples: ['record data: 记录数据'],
    )
      ..partOfSpeech = 'v./n.';

    WordEnrichment.apply(word);

    expect(word.definitions, hasLength(2));
    for (final definition in word.definitions!) {
      final examples = word.structuredExamples.where((example) {
        return example.partOfSpeech == definition.partOfSpeech &&
            example.meaning == definition.meaning &&
            example.english.trim().isNotEmpty;
      });
      expect(examples, isNotEmpty);
    }
  });
}