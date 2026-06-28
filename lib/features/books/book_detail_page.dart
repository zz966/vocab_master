import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/category_labels.dart';
import '../../providers/book_provider.dart';
import '../../providers/export_refresh_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/study_provider.dart';
import '../../providers/word_provider.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/stats_repository.dart';
import '../../utils/book_stats_export.dart';
import '../../utils/book_stats_share.dart';
import '../../utils/book_word_export.dart';
import '../../utils/color_utils.dart';
import '../../utils/export_file.dart';
import '../stats/session_history_page.dart';
import '../study/study_session_page.dart';
import '../../utils/session_date_filter.dart';
import '../study/widgets/study_mode_picker_sheet.dart';
import 'book_words_page.dart';
import 'edit_book_page.dart';
import 'import_book_page.dart';
import 'manage_words_page.dart';
import 'widgets/book_accuracy_trend_chart.dart';
import 'widgets/book_study_bar_chart.dart';
import 'widgets/book_study_calendar.dart';
import 'widgets/book_study_trend_chart.dart';

class BookDetailPage extends ConsumerWidget {
  const BookDetailPage({super.key, required this.bookId});

  final int bookId;

  Future<void> _resetBookProgress(
    BuildContext context,
    WidgetRef ref,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重置本书进度'),
        content: Text('确定重置「$title」中所有单词的学习记录？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('重置'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await ref.read(wordRepositoryProvider).resetBookProgress(bookId);
    invalidateStudyData(ref);
    ref.invalidate(bookProgressProvider(bookId));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('本书学习进度已重置')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(bookProgressProvider(bookId));
    final dailyStatsAsync = ref.watch(bookDailyStatsProvider(bookId));
    final accuracyAsync = ref.watch(bookDailyAccuracyProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('单词书详情'),
        actions: [
          progressAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (progress) {
              if (progress == null) {
                return const SizedBox.shrink();
              }

              return PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'edit':
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => EditBookPage(book: progress.book),
                        ),
                      );
                    case 'words':
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ManageWordsPage(bookId: progress.book.id),
                        ),
                      );
                    case 'browse':
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BookWordsPage(
                            bookId: progress.book.id,
                            bookTitle: progress.book.title,
                          ),
                        ),
                      );
                    case 'history':
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SessionHistoryPage(
                            initialBookId: progress.book.id,
                            initialDateRange: SessionDateRange.last30Days,
                          ),
                        ),
                      );
                    case 'export':
                      await _exportBook(
                        context,
                        ref,
                        progress.book.id,
                        progress.book.title,
                      );
                    case 'export_share':
                      await _exportBook(
                        context,
                        ref,
                        progress.book.id,
                        progress.book.title,
                        shareAfter: true,
                      );
                    case 'export_stats':
                      await _exportBookStats(context, ref, progress);
                    case 'export_stats_share':
                      await _exportBookStats(
                        context,
                        ref,
                        progress,
                        shareAfter: true,
                      );
                    case 'share_stats':
                      await shareBookStats(progress);
                    case 'reset':
                      await _resetBookProgress(
                        context,
                        ref,
                        progress.book.title,
                      );
                    case 'delete':
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('删除单词书'),
                          content: Text('确定删除「${progress.book.title}」？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('取消'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('删除'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true && context.mounted) {
                        await ref
                            .read(bookRepositoryProvider)
                            .deleteBook(progress.book.id);
                        invalidateStudyData(ref);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'browse',
                    child: Text('浏览单词'),
                  ),
                  const PopupMenuItem(
                    value: 'history',
                    child: Text('学习记录'),
                  ),
                  if (progress.isCustom) ...[
                    const PopupMenuItem(value: 'edit', child: Text('编辑信息')),
                    const PopupMenuItem(value: 'words', child: Text('管理单词')),
                  ],
                  const PopupMenuItem(value: 'export', child: Text('导出 JSON')),
                  const PopupMenuItem(
                    value: 'export_share',
                    child: Text('导出并分享 JSON'),
                  ),
                  const PopupMenuItem(
                    value: 'export_stats',
                    child: Text('导出学习统计'),
                  ),
                  const PopupMenuItem(
                    value: 'export_stats_share',
                    child: Text('导出并分享统计'),
                  ),
                  const PopupMenuItem(
                    value: 'share_stats',
                    child: Text('分享统计摘要'),
                  ),
                  const PopupMenuItem(value: 'reset', child: Text('重置本书进度')),
                  if (progress.isCustom)
                    const PopupMenuItem(value: 'delete', child: Text('删除')),
                ],
              );
            },
          ),
        ],
      ),
      body: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (progress) {
          if (progress == null) {
            return const Center(child: Text('单词书不存在'));
          }

          final book = progress.book;
          final color = parseHexColor(book.coverColor);
          final masteryPercent = (progress.masteryRate * 100).round();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: color,
                    child: Text(
                      book.title.isNotEmpty ? book.title[0] : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Chip(label: Text(categoryLabel(book.category))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (book.description != null) Text(book.description!),
              const SizedBox(height: 24),
              _StatTile(label: '总词数', value: '${progress.totalWords}'),
              _StatTile(label: '已学习', value: '${progress.learnedWords}'),
              _StatTile(label: '已掌握', value: '$masteryPercent%'),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress.masteryRate,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                color: color,
              ),
              const SizedBox(height: 24),
              dailyStatsAsync.when(
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
                error: (_, _) => const SizedBox.shrink(),
                data: (stats) => Column(
                  children: [
                    BookStudyTrendChart(stats: stats),
                    const SizedBox(height: 16),
                    accuracyAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                      data: (accuracyStats) => Column(
                        children: [
                          BookAccuracyTrendChart(
                            stats: accuracyStats,
                            lineColor: color,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    BookStudyBarChart(stats: stats, barColor: color),
                    const SizedBox(height: 16),
                    BookStudyCalendar(
                      stats: stats,
                      onDayTap: (stat) {
                        final day = DateTime(
                          stat.date.year,
                          stat.date.month,
                          stat.date.day,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => SessionHistoryPage(
                              initialBookId: book.id,
                              initialDateRange: SessionDateRange.custom,
                              initialCustomRange: DateTimeRange(
                                start: day,
                                end: day,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _exportBookStats(context, ref, progress),
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('导出本书统计'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _exportBookStats(
                        context,
                        ref,
                        progress,
                        shareAfter: true,
                      ),
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('导出并分享'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SessionHistoryPage(
                        initialBookId: book.id,
                        initialDateRange: SessionDateRange.last30Days,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('本书学习记录'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: progress.totalWords == 0
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => BookWordsPage(
                              bookId: book.id,
                              bookTitle: book.title,
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.list_alt),
                label: const Text('浏览单词'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              if (progress.isCustom) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ManageWordsPage(bookId: book.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_note),
                  label: const Text('管理单词'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: progress.totalWords == 0
                    ? null
                    : () async {
                        ref
                            .read(selectedBookIdsProvider.notifier)
                            .setAll([book.id]);
                        final mode = await showStudyModePicker(context);
                        if (mode == null || !context.mounted) {
                          return;
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => StudySessionPage(mode: mode),
                          ),
                        );
                      },
                icon: const Icon(Icons.play_arrow),
                label: const Text('开始学习'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _exportBookStats(
    BuildContext context,
    WidgetRef ref,
    BookProgress progress, {
    bool shareAfter = false,
  }) async {
    try {
      final statsRepo = ref.read(statsRepositoryProvider);
      final dailyStats =
          await statsRepo.getDailyStatsForBook(progress.book.id);
      final accuracyStats =
          await statsRepo.getDailyAccuracyForBook(progress.book.id);
      final sessions =
          await ref.read(sessionRepositoryProvider).getRecentSessions(limit: 100);
      final bookSessions = sessions
          .where((session) => session.bookIds.contains(progress.book.id))
          .toList();

      final json = BookStatsExportCodec.encode(
        progress: progress,
        dailyStats: dailyStats,
        accuracyStats: accuracyStats,
        sessions: bookSessions,
      );
      final safeTitle = progress.book.title.replaceAll(
        RegExp(r'[<>:"/\\|?*]'),
        '_',
      );
      final fileName =
          'vocab_book_stats_${safeTitle}_${DateFormat('yyyyMMdd').format(DateTime.now())}.json';
      final path = await saveTextToDocuments(content: json, fileName: fileName);

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
        final shared = result == ShareExportResult.shared;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(shared ? '已导出并打开分享' : '已导出，分享失败'),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            path == null ? '导出失败' : '本书统计已导出至 $path',
          ),
          action: path == null
              ? null
              : SnackBarAction(
                  label: '分享',
                  onPressed: () => shareFileAtPath(path, name: fileName),
                ),
        ),
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $error')),
        );
      }
    }
  }

  Future<void> _exportBook(
    BuildContext context,
    WidgetRef ref,
    int bookId,
    String title, {
    bool shareAfter = false,
  }) async {
    try {
      final json =
          await ref.read(bookRepositoryProvider).exportBookJson(bookId);
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
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}