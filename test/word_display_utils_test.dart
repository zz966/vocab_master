import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/utils/word_display_utils.dart';

void main() {
  test('displayDefinitions splits combined part of speech lines', () {
    final word = BookWord(
      id: 'w1',
      word: 'disgrace',
      partOfSpeech: 'n./v.',
      definitionCn: '耻辱；使丢脸',
      definitions: [
        WordDefinition(partOfSpeech: 'n./v.', meaning: '耻辱；使丢脸'),
      ],
    );

    final lines = displayDefinitions(word);

    expect(lines.length, 2);
    expect(lines[0].partOfSpeech, 'n.');
    expect(lines[0].meaning, '耻辱');
    expect(lines[1].partOfSpeech, 'v.');
    expect(lines[1].meaning, '使丢脸');
  });

  test('displayDefinitions keeps separate definition rows', () {
    final word = BookWord(
      id: 'w2',
      word: 'drag',
      definitions: [
        WordDefinition(partOfSpeech: 'v.', meaning: '拖拽'),
        WordDefinition(partOfSpeech: 'n.', meaning: '累赘'),
      ],
    );

    final lines = displayDefinitions(word);

    expect(lines.length, 2);
    expect(lines[0].meaning, '拖拽');
    expect(lines[1].meaning, '累赘');
  });
}