import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/books/import_book_page.dart';
import '../providers/export_refresh_provider.dart';
import '../repositories/book_repository.dart';
import 'book_word_export.dart';
import 'export_file.dart';

Future<void> exportBookAsJson(
  BuildContext context,
  WidgetRef ref, {
  required int bookId,
  required String title,
  bool shareAfter = false,
}) async {
  try {
    final json = await ref.read(bookRepositoryProvider).exportBookJson(bookId);
    final fileName = buildBookExportFileName(title);
    final path = await saveBookExportJson(json: json, title: title);

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

    showExportDialog(context, json, title, savedPath: path);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导出失败: $error')),
      );
    }
  }
}