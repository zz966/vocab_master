import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/kylebing_vocab_codec.dart';

void main() {
  test('KyleBingVocabCodec parses simple vocabulary entry', () {
    const json = '''
[
  {
    "word": "talk",
    "translations": [
      {"translation": "说话；谈话", "type": "v"},
      {"translation": "交谈", "type": "n"}
    ],
    "phrases": [
      {"phrase": "talk about", "translation": "谈论某事"},
      {"phrase": "small talk", "translation": "闲聊；聊天"}
    ]
  }
]
''';

    final words = KyleBingVocabCodec.decode(json);

    expect(words, hasLength(1));
    expect(words.first.english, 'talk');
    expect(words.first.chinese, '说话；谈话；交谈');
    expect(words.first.partOfSpeech, 'v./n.');
    expect(words.first.examples, [
      'talk about: 谈论某事',
      'small talk: 闲聊；聊天',
    ]);
    expect(words.first.definitions, hasLength(2));
    expect(words.first.collocations, hasLength(2));
    expect(words.first.structuredExamples, isNotEmpty);
  });

  test('KyleBingVocabCodec parses bundled Level4 asset', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final json = await rootBundle.loadString('assets/vocab/Level4_1.json');

    final words = KyleBingVocabCodec.decode(json);

    expect(words.length, greaterThan(100));
    expect(words.first.english, isNotEmpty);
    expect(words.first.chinese, isNotEmpty);
  });
}