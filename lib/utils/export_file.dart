import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum ExportFileKind { all, csv, json, png }

ExportFileKind exportFileKindFromName(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.csv')) {
    return ExportFileKind.csv;
  }
  if (lower.endsWith('.png')) {
    return ExportFileKind.png;
  }
  return ExportFileKind.json;
}

List<ExportFileInfo> filterExportFilesByKind(
  List<ExportFileInfo> files,
  ExportFileKind kind,
) {
  if (kind == ExportFileKind.all) {
    return files;
  }
  return files
      .where((file) => exportFileKindFromName(file.name) == kind)
      .toList();
}

class ExportFileInfo {
  const ExportFileInfo({
    required this.name,
    required this.path,
    required this.sizeBytes,
    required this.modifiedAt,
  });

  final String name;
  final String path;
  final int sizeBytes;
  final DateTime modifiedAt;
}

String describeExportFileName(String name) {
  final lower = name.toLowerCase();
  if (lower.startsWith('vocab_sessions')) {
    return '学习记录';
  }
  if (lower.startsWith('vocab_words_favorites')) {
    return '收藏夹';
  }
  if (lower.startsWith('vocab_words_wrongbook')) {
    return '错题本';
  }
  if (lower.startsWith('vocab_words_review')) {
    return '复习队列';
  }
  if (lower.startsWith('vocab_search_results')) {
    return '搜索结果';
  }
  if (lower.startsWith('vocab_book_stats')) {
    return '单词书统计';
  }
  if (lower.startsWith('vocab_book_export')) {
    return '单词书导出';
  }
  if (lower.startsWith('vocab_master_stats')) {
    return '学习数据摘要';
  }
  if (lower.startsWith('vocab_weekly')) {
    return '周报图片';
  }
  return '导出文件';
}

final _exportNamePattern = RegExp(
  r'^vocab_(sessions|master_stats|book_stats|book_export|words_favorites|words_wrongbook|words_review|search_results|weekly)_.+\.(csv|json|png)$',
  caseSensitive: false,
);

Future<String?> getDocumentsDirectoryPath() async {
  if (kIsWeb) {
    return null;
  }
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

Future<List<ExportFileInfo>> listVocabExportFiles() async {
  if (kIsWeb) {
    return [];
  }

  final dir = await getApplicationDocumentsDirectory();
  final entries = <ExportFileInfo>[];

  await for (final entity in dir.list()) {
    if (entity is! File) {
      continue;
    }
    final name = entity.uri.pathSegments.last;
    if (!_exportNamePattern.hasMatch(name)) {
      continue;
    }
    final stat = await entity.stat();
    entries.add(
      ExportFileInfo(
        name: name,
        path: entity.path,
        sizeBytes: stat.size,
        modifiedAt: stat.modified,
      ),
    );
  }

  entries.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
  return entries;
}

Future<bool> openDocumentsDirectory() async {
  if (kIsWeb) {
    return false;
  }

  final path = await getDocumentsDirectoryPath();
  if (path == null) {
    return false;
  }

  if (Platform.isWindows) {
    await Process.run('explorer', [path]);
    return true;
  }
  if (Platform.isMacOS) {
    await Process.run('open', [path]);
    return true;
  }
  if (Platform.isLinux) {
    await Process.run('xdg-open', [path]);
    return true;
  }

  return false;
}

Future<void> copyExportPath(String path) async {
  await Clipboard.setData(ClipboardData(text: path));
}

enum ShareExportResult {
  shared,
  contentCopied,
  pathCopied,
  failed,
}

const _maxShareContentBytes = 512 * 1024;

Future<bool> deleteExportFile(String path) async {
  if (kIsWeb) {
    return false;
  }

  final file = File(path);
  if (!await file.exists()) {
    return false;
  }
  await file.delete();
  return true;
}

Future<ShareExportResult> shareFileAtPath(
  String path, {
  String? name,
}) async {
  if (kIsWeb) {
    return ShareExportResult.failed;
  }

  final file = File(path);
  if (!await file.exists()) {
    return ShareExportResult.failed;
  }

  try {
    await Share.shareXFiles(
      [XFile(path)],
      text: name,
    );
    return ShareExportResult.shared;
  } catch (_) {
    return ShareExportResult.failed;
  }
}

Future<ShareExportResult> shareExportFile(ExportFileInfo info) async {
  if (kIsWeb) {
    return _shareViaClipboard(info);
  }

  final file = File(info.path);
  if (!await file.exists()) {
    return ShareExportResult.failed;
  }

  try {
    await Share.shareXFiles(
      [XFile(info.path)],
      text: info.name,
    );
    return ShareExportResult.shared;
  } catch (_) {
    return _shareViaClipboard(info);
  }
}

Future<ShareExportResult> _shareViaClipboard(ExportFileInfo info) async {
  if (kIsWeb) {
    return ShareExportResult.failed;
  }

  final file = File(info.path);
  if (!await file.exists()) {
    return ShareExportResult.failed;
  }

  if (info.sizeBytes <= _maxShareContentBytes) {
    final content = await file.readAsString();
    await Clipboard.setData(ClipboardData(text: content));
    return ShareExportResult.contentCopied;
  }

  await Clipboard.setData(ClipboardData(text: info.path));
  return ShareExportResult.pathCopied;
}

Future<int> deleteAllExportFiles() async {
  if (kIsWeb) {
    return 0;
  }

  final files = await listVocabExportFiles();
  var deleted = 0;
  for (final file in files) {
    if (await deleteExportFile(file.path)) {
      deleted++;
    }
  }
  return deleted;
}

String formatExportFileSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  }
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

Future<String?> saveBytesToDocuments({
  required List<int> bytes,
  required String fileName,
}) async {
  if (kIsWeb) {
    return null;
  }

  final dir = await getApplicationDocumentsDirectory();
  final safeName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  final file = File('${dir.path}/$safeName');
  await file.writeAsBytes(bytes);
  return file.path;
}

Future<String?> saveTextToDocuments({
  required String content,
  required String fileName,
}) async {
  if (kIsWeb) {
    return null;
  }

  final dir = await getApplicationDocumentsDirectory();
  final safeName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  final file = File('${dir.path}/$safeName');
  await file.writeAsString(content);
  return file.path;
}