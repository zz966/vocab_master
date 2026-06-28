import 'package:flutter_test/flutter_test.dart';

void main() {
  test('listVocabExportFiles pattern matches known export names', () {
    const pattern =
        r'^vocab_(sessions|master_stats|book_stats|book_export|words_favorites|words_wrongbook|words_review|search_results|weekly)_.+\.(csv|json|png)$';
    final regex = RegExp(pattern, caseSensitive: false);

    expect(regex.hasMatch('vocab_sessions_20260616_1200.csv'), isTrue);
    expect(regex.hasMatch('vocab_sessions_selected_20260616_1200.csv'), isTrue);
    expect(regex.hasMatch('vocab_master_stats_20260616_1200.json'), isTrue);
    expect(regex.hasMatch('vocab_book_stats_20260616_1200.csv'), isTrue);
    expect(regex.hasMatch('vocab_weekly_1718534400000.png'), isTrue);
    expect(regex.hasMatch('vocab_sessions_selected_20260616_1200.json'), isTrue);
    expect(regex.hasMatch('vocab_sessions_single_42_20260616_1200.json'), isTrue);
    expect(regex.hasMatch('vocab_book_export_CET4_20260616.json'), isTrue);
    expect(regex.hasMatch('vocab_words_favorites_20260616_1200.csv'), isTrue);
    expect(regex.hasMatch('vocab_words_wrongbook_20260616_1200.json'), isTrue);
    expect(regex.hasMatch('vocab_search_results_apple_20260616_1200.csv'), isTrue);
    expect(regex.hasMatch('vocab_words_review_20260616_1200.csv'), isTrue);
    expect(regex.hasMatch('vocab_sessions_single_7_20260616_1200.csv'), isTrue);
    expect(regex.hasMatch('random_export.txt'), isFalse);
  });
}