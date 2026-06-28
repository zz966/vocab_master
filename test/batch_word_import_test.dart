import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/batch_word_import.dart';

void main() {
  test('parseBatchWordLines supports comma separated format', () {
    final lines = parseBatchWordLines('hello,你好\nworld,世界');
    expect(lines.length, 2);
    expect(lines[0].english, 'hello');
    expect(lines[0].chinese, '你好');
  });

  test('parseBatchWordLines supports tab and dash formats', () {
    final lines = parseBatchWordLines(
      'apple\t苹果\nbanana - 香蕉',
    );
    expect(lines.length, 2);
    expect(lines[1].english, 'banana');
    expect(lines[1].chinese, '香蕉');
  });

  test('parseBatchWordLines skips invalid lines', () {
    final lines = parseBatchWordLines('invalid line\nok,好的');
    expect(lines.length, 1);
    expect(lines.first.english, 'ok');
  });
}