import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../models/word.dart';
import '../providers/export_refresh_provider.dart';
import 'export_file.dart';
import 'word_collection_export.dart';

Future<void> shareReviewQueueText(List<Word> words) async {
  final text = formatWordCollectionShareText(
    kind: WordCollectionKind.reviewQueue,
    words: words,
  );
  await Share.share(text, subject: 'VocabMaster 今日复习');
}

Future<void> exportReviewQueue(
  BuildContext context,
  WidgetRef ref,
  List<Word> words, {
  required String format,
  bool shareAfter = false,
}) async {
  if (words.isEmpty) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('没有可导出的复习单词')),
    );
    return;
  }

  final kind = WordCollectionKind.reviewQueue;
  final isJson = format == 'json';
  final content = isJson
      ? WordCollectionExportCodec.toJson(words, kind: kind)
      : WordCollectionExportCodec.toCsv(words);
  final fileName = buildWordCollectionFileName(
    kind: kind,
    format: isJson ? 'json' : 'csv',
  );
  final path = await saveTextToDocuments(content: content, fileName: fileName);

  if (path != null) {
    bumpExportFilesRevision(ref);
  }
  if (!context.mounted) {
    return;
  }

  if (path != null && shareAfter) {
    final result = await shareFileAtPath(path, name: fileName);
    if (!context.mounted) {
      return;
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
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        path == null
            ? '${isJson ? 'JSON' : 'CSV'} 已生成（当前平台不支持保存文件）'
            : '已导出至 $path',
      ),
      action: path == null
          ? null
          : SnackBarAction(
              label: '分享',
              onPressed: () => shareFileAtPath(path, name: fileName),
            ),
    ),
  );
}