import 'dart:convert';

import 'package:intl/intl.dart';

import '../core/session_labels.dart';
import '../models/learning_session.dart';

class SessionExportCodec {
  static String toJson(List<LearningSession> sessions) {
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'count': sessions.length,
      'sessions': sessions
          .map(
            (session) => {
              'id': session.id,
              'type': session.sessionType,
              'typeLabel': sessionTypeLabel(session.sessionType),
              'bookIds': session.bookIds,
              'wordsStudied': session.wordsStudied,
              'wordsCorrect': session.wordsCorrect,
              'accuracy': session.wordsStudied == 0
                  ? 0.0
                  : session.wordsCorrect / session.wordsStudied,
              'startedAt': session.startedAt.toIso8601String(),
              'completedAt': session.completedAt?.toIso8601String(),
            },
          )
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  static String toCsv(List<LearningSession> sessions) {
    final buffer = StringBuffer()
      ..writeln('类型,开始时间,完成时间,学习词数,正确数,正确率');

    final formatter = DateFormat('yyyy-MM-dd HH:mm');

    for (final session in sessions) {
      final accuracy = session.wordsStudied == 0
          ? 0
          : (session.wordsCorrect / session.wordsStudied * 100).round();
      final completed = session.completedAt == null
          ? ''
          : formatter.format(session.completedAt!);

      buffer.writeln(
        '${_escape(sessionTypeLabel(session.sessionType))},'
        '${formatter.format(session.startedAt)},'
        '${_escape(completed)},'
        '${session.wordsStudied},'
        '${session.wordsCorrect},'
        '$accuracy%',
      );
    }

    return buffer.toString();
  }

  static String _escape(String value) {
    if (value.contains(',') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}