import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/models/learning_session.dart';
import 'package:vocab_master/utils/session_export.dart';

void main() {
  test('SessionExportCodec produces CSV with headers and rows', () {
    final started = DateTime(2026, 6, 16, 10, 30);
    final completed = DateTime(2026, 6, 16, 10, 45);

    final session = LearningSession()
      ..id = 1
      ..sessionType = 'flashcard'
      ..wordsStudied = 10
      ..wordsCorrect = 8
      ..startedAt = started
      ..completedAt = completed;

    final csv = SessionExportCodec.toCsv([session]);
    final lines = csv.trim().split('\n');

    expect(lines, hasLength(2));
    expect(lines.first, '类型,开始时间,完成时间,学习词数,正确数,正确率');
    expect(lines[1], contains('速刷学习'));
    expect(lines[1], contains('2026-06-16 10:30'));
    expect(lines[1], contains('2026-06-16 10:45'));
    expect(lines[1], contains('10'));
    expect(lines[1], contains('8'));
    expect(lines[1], contains('80%'));
  });

  test('SessionExportCodec produces valid JSON', () {
    final started = DateTime(2026, 6, 16, 10, 30);
    final completed = DateTime(2026, 6, 16, 10, 45);

    final session = LearningSession()
      ..id = 42
      ..sessionType = 'flashcard'
      ..bookIds = [1, 2]
      ..wordsStudied = 10
      ..wordsCorrect = 8
      ..startedAt = started
      ..completedAt = completed;

    final json = SessionExportCodec.toJson([session]);
    final data = jsonDecode(json) as Map<String, dynamic>;

    expect(data['version'], 1);
    expect(data['count'], 1);
    final sessions = data['sessions'] as List<dynamic>;
    expect(sessions, hasLength(1));
    final row = sessions.first as Map<String, dynamic>;
    expect(row['id'], 42);
    expect(row['type'], 'flashcard');
    expect(row['typeLabel'], '速刷学习');
    expect(row['bookIds'], [1, 2]);
    expect(row['wordsStudied'], 10);
    expect(row['wordsCorrect'], 8);
    expect(row['accuracy'], closeTo(0.8, 0.001));
    expect(row['startedAt'], started.toIso8601String());
    expect(row['completedAt'], completed.toIso8601String());
  });
}
