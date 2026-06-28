import 'package:intl/intl.dart';

import 'export_file.dart';

String buildBookExportFileName(String title) {
  final safeTitle = title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  final date = DateFormat('yyyyMMdd').format(DateTime.now());
  return 'vocab_book_export_${safeTitle}_$date.json';
}

Future<String?> saveBookExportJson({
  required String json,
  required String title,
}) async {
  return saveTextToDocuments(
    content: json,
    fileName: buildBookExportFileName(title),
  );
}