import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/phonetic_utils.dart';

void main() {
  test('formatPhonetic wraps plain text with slashes', () {
    expect(formatPhonetic('dræɡ'), '/dræɡ/');
    expect(formatPhonetic('/dræɡ/'), '/dræɡ/');
  });

  test('resolvePhoneticUk and Us fall back to each other', () {
    expect(
      resolvePhoneticUk(phoneticUk: '', phoneticUs: '/dræɡ/'),
      '/dræɡ/',
    );
    expect(
      resolvePhoneticUs(phoneticUk: '/dræɡ/', phoneticUs: ''),
      '/dræɡ/',
    );
  });
}