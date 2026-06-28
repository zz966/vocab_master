import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../features/stats/widgets/weekly_report_share_card.dart';
import '../providers/export_refresh_provider.dart';
import '../repositories/stats_repository.dart';
import 'image_save.dart';
import 'reminder_message.dart';
import 'widget_capture.dart';

Future<void> shareWeeklyReportText({
  required SessionSummary summary,
  required int masteredWords,
  required int currentStreak,
}) async {
  final text = formatWeeklyReport(
    totalSessions: summary.totalSessions,
    totalWordsStudied: summary.totalWordsStudied,
    accuracy: summary.accuracy,
    masteredWords: masteredWords,
    currentStreak: currentStreak,
  );
  await Share.share(text, subject: 'VocabMaster 本周学习周报');
}

Future<File?> captureWeeklyReportImage({
  required BuildContext context,
  required SessionSummary summary,
  required int masteredWords,
  required int currentStreak,
  List<DailyStudyStat>? weekStats,
}) async {
  final key = GlobalKey();
  final overlay = OverlayEntry(
    builder: (ctx) => Positioned(
      left: -2000,
      top: -2000,
      child: RepaintBoundary(
        key: key,
        child: WeeklyReportShareCard(
          summary: summary,
          masteredWords: masteredWords,
          currentStreak: currentStreak,
          weekStats: weekStats,
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlay);
  await Future<void>.delayed(const Duration(milliseconds: 120));
  final file = await captureWidgetToPng(key);
  overlay.remove();
  return file;
}

Future<bool> shareWeeklyReportImage({
  required BuildContext context,
  required SessionSummary summary,
  required int masteredWords,
  required int currentStreak,
  List<DailyStudyStat>? weekStats,
}) async {
  final file = await captureWeeklyReportImage(
    context: context,
    summary: summary,
    masteredWords: masteredWords,
    currentStreak: currentStreak,
    weekStats: weekStats,
  );

  if (file == null) {
    return false;
  }

  await Share.shareXFiles(
    [XFile(file.path)],
    text: 'VocabMaster 本周学习周报',
  );
  return true;
}

Future<ImageSaveResult> saveWeeklyReportImage({
  required BuildContext context,
  required SessionSummary summary,
  required int masteredWords,
  required int currentStreak,
  List<DailyStudyStat>? weekStats,
}) async {
  final file = await captureWeeklyReportImage(
    context: context,
    summary: summary,
    masteredWords: masteredWords,
    currentStreak: currentStreak,
    weekStats: weekStats,
  );

  if (file == null) {
    return ImageSaveResult.failed;
  }

  final result = await saveImageToGallery(file);
  if (result == ImageSaveResult.savedToDocuments && context.mounted) {
    bumpExportFilesRevisionFromContext(context);
  }
  return result;
}

Future<void> showWeeklyReportShareSheet({
  required BuildContext context,
  required SessionSummary summary,
  required int masteredWords,
  required int currentStreak,
  List<DailyStudyStat>? weekStats,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('分享文字周报'),
            onTap: () async {
              Navigator.pop(ctx);
              await shareWeeklyReportText(
                summary: summary,
                masteredWords: masteredWords,
                currentStreak: currentStreak,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text('分享图片卡片'),
            onTap: () async {
              Navigator.pop(ctx);
              final shared = await shareWeeklyReportImage(
                context: context,
                summary: summary,
                masteredWords: masteredWords,
                currentStreak: currentStreak,
                weekStats: weekStats,
              );
              if (!context.mounted) {
                return;
              }
              if (!shared) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('图片分享失败')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('保存图片到相册'),
            onTap: () async {
              Navigator.pop(ctx);
              final result = await saveWeeklyReportImage(
                context: context,
                summary: summary,
                masteredWords: masteredWords,
                currentStreak: currentStreak,
                weekStats: weekStats,
              );
              if (!context.mounted) {
                return;
              }
              final message = switch (result) {
                ImageSaveResult.savedToGallery => '图片已保存到相册',
                ImageSaveResult.savedToDocuments =>
                  '相册不可用，已保存到导出目录',
                ImageSaveResult.failed => '保存失败',
              };
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          ),
        ],
      ),
    ),
  );
}