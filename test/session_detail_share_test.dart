import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/learning_session.dart';
import 'package:vocab_master/models/review_record.dart';
import 'package:vocab_master/models/word.dart';
import 'package:vocab_master/providers/session_detail_provider.dart';
import 'package:vocab_master/utils/session_detail_share.dart';

void main() {
  test('formatSessionShareText summarizes session stats', () {
    final session = LearningSession()
      ..id = 7
      ..sessionType = 'flashcard'
      ..wordsStudied = 12
      ..wordsCorrect = 9
      ..startedAt = DateTime(2026, 6, 16, 9, 30)
      ..completedAt = DateTime(2026, 6, 16, 9, 50);

    final text = formatSessionShareText(session: session);

    expect(text, contains('速刷学习'));
    expect(text, contains('2026-06-16 09:30'));
    expect(text, contains('12 词'));
    expect(text, contains('75%'));
    expect(text, contains('20 分钟'));
  });

  test('formatSessionShareText includes word preview', () {
    final session = LearningSession()
      ..sessionType = 'quiz'
      ..wordsStudied = 2
      ..wordsCorrect = 2
      ..startedAt = DateTime(2026, 6, 16, 14, 0);

    final word = Word()
      ..english = 'apple'
      ..chinese = '苹果'
      ..bookIds = [1];
    final record = ReviewRecord()..quality = 2;

    final text = formatSessionShareText(
      session: session,
      entries: [SessionWordEntry(word: word, record: record)],
    );

    expect(text, contains('apple(苹果)'));
  });
}
