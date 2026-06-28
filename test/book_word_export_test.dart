import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/utils/book_word_export.dart';

void main() {
  test('buildBookExportFileName sanitizes title and uses vocab_book_export prefix', () {
    final name = buildBookExportFileName('CET-4 Core');

    expect(name, startsWith('vocab_book_export_CET-4 Core_'));
    expect(name, endsWith('.json'));
    expect(name, isNot(contains('<')));
  });
}