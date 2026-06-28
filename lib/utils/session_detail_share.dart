import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../models/learning_session.dart';
import '../providers/export_refresh_provider.dart';
import '../providers/session_detail_provider.dart';
import 'export_file.dart';
import 'session_export.dart';
import '../core/session_labels.dart';

String formatSessionShareText({
  required LearningSession session,
  List<SessionWordEntry>? entries,
}) {
  final accuracy = session.wordsStudied == 0
      ? 0
      : (session.wordsCorrect / session.wordsStudied * 100).round();
  final parts = <String>[
    '📝 VocabMaster 学习记录',
    sessionTypeLabel(session.sessionType),
    DateFormat('yyyy-MM-dd HH:mm').format(session.startedAt),
    '${session.wordsStudied} 词 · 正确率 $accuracy%',
  ];

  if (session.completedAt != null) {
    final duration = session.completedAt!.difference(session.startedAt);
    if (duration.inMinutes >= 1) {
      parts.add('时长 ${duration.inMinutes} 分钟');
    }
  }

  if (entries != null && entries.isNotEmpty) {
    final preview = entries
        .take(5)
        .map((entry) => '${entry.word.english}(${entry.word.chinese})')
        .join('、');
    final suffix = entries.length > 5 ? '…' : '';
    parts.add('单词 $preview$suffix');
  }

  return parts.join(' · ');
}

Future<void> shareSessionText({
  required LearningSession session,
  List<SessionWordEntry>? entries,
}) async {
  final text = formatSessionShareText(session: session, entries: entries);
  await Share.share(text, subject: 'VocabMaster 学习记录');
}

Future<bool> exportSession({
  required BuildContext context,
  required LearningSession session,
  required String format,
  bool shareAfter = true,
}) async {
  final timestamp = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
  final isJson = format == 'json';
  final content = isJson
      ? SessionExportCodec.toJson([session])
      : SessionExportCodec.toCsv([session]);
  final fileName =
      'vocab_sessions_single_${session.id}_$timestamp.${isJson ? 'json' : 'csv'}';
  final path = await saveTextToDocuments(content: content, fileName: fileName);

  if (path != null && context.mounted) {
    bumpExportFilesRevisionFromContext(context);
  }

  if (!context.mounted) {
    return false;
  }

  if (path == null) {
    return false;
  }

  if (!shareAfter) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已导出至 $path'),
        action: SnackBarAction(
          label: '分享',
          onPressed: () => shareFileAtPath(path, name: fileName),
        ),
      ),
    );
    return true;
  }

  final result = await shareFileAtPath(path, name: fileName);
  if (!context.mounted) {
    return false;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result == ShareExportResult.shared
            ? '已导出并打开分享'
            : '已导出，分享失败',
      ),
    ),
  );
  return result == ShareExportResult.shared;
}

Future<bool> exportAndShareSession({
  required BuildContext context,
  required LearningSession session,
  bool shareAfter = true,
  String format = 'json',
}) {
  return exportSession(
    context: context,
    session: session,
    format: format,
    shareAfter: shareAfter,
  );
}