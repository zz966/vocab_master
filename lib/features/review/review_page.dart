import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/study_mode.dart';
import '../../providers/book_provider.dart';
import '../../providers/review_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/study_provider.dart';
import '../books/book_selection_page.dart';
import '../study/study_session_page.dart';
import '../study/word_detail_page.dart';
import '../../utils/review_queue_export.dart';
import '../../widgets/empty_state.dart';
import '../study/widgets/study_mode_list.dart';

class ReviewPage extends ConsumerWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectedBookIdsProvider);
    final reviewAsync = ref.watch(todayReviewWordsProvider(selectedIds));
    final booksAsync = ref.watch(booksProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: reviewAsync.when(
          data: (words) => Text('今日复习 ${words.length} 个单词'),
          loading: () => const Text('今日复习'),
          error: (_, _) => const Text('今日复习'),
        ),
        actions: [
          reviewAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (words) {
              if (words.isEmpty) {
                return const SizedBox.shrink();
              }
              return PopupMenuButton<String>(
                onSelected: (action) async {
                  switch (action) {
                    case 'share_text':
                      await shareReviewQueueText(words);
                    case 'export_csv':
                      await exportReviewQueue(
                        context,
                        ref,
                        words,
                        format: 'csv',
                      );
                    case 'export_csv_share':
                      await exportReviewQueue(
                        context,
                        ref,
                        words,
                        format: 'csv',
                        shareAfter: true,
                      );
                    case 'export_json':
                      await exportReviewQueue(
                        context,
                        ref,
                        words,
                        format: 'json',
                      );
                    case 'export_json_share':
                      await exportReviewQueue(
                        context,
                        ref,
                        words,
                        format: 'json',
                        shareAfter: true,
                      );
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'share_text', child: Text('分享文字列表')),
                  PopupMenuItem(value: 'export_csv', child: Text('导出 CSV')),
                  PopupMenuItem(
                    value: 'export_csv_share',
                    child: Text('导出并分享 CSV'),
                  ),
                  PopupMenuItem(value: 'export_json', child: Text('导出 JSON')),
                  PopupMenuItem(
                    value: 'export_json_share',
                    child: Text('导出并分享 JSON'),
                  ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const BookSelectionPage(),
                ),
              );
            },
            icon: const Icon(Icons.filter_list),
            tooltip: '筛选单词书',
          ),
        ],
      ),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (books) {
          return reviewAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('加载失败: $error')),
            data: (words) {
              final selectedTitles = selectedIds.isEmpty
                  ? ['全部单词书']
                  : books
                        .where((item) => selectedIds.contains(item.book.id))
                        .map((item) => item.book.title)
                        .toList();
              final defaultMode = StudyMode.fromId(
                settingsAsync.value?.defaultStudyMode ?? 'flashcard',
              );

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              '${words.length}',
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Text('今日待复习单词'),
                          ],
                        ),
                      ),
                    ),
                    if (words.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => StudySessionPage(
                                mode: defaultMode,
                                reviewOnly: true,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bolt),
                        label: Text('快速复习（${defaultMode.title}）'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      '筛选范围',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedTitles
                          .map((title) => Chip(label: Text(title)))
                          .toList(),
                    ),
                    if (words.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        '待复习预览',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: [
                            for (final word in words.take(8))
                              ListTile(
                                dense: true,
                                title: Text(word.english),
                                subtitle: Text(word.chinese),
                                trailing: Text('${word.familiarity}/5'),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          WordDetailPage(wordId: word.id),
                                    ),
                                  );
                                },
                              ),
                            if (words.length > 8)
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  '还有 ${words.length - 8} 个单词…',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      '选择复习模式',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('复习时使用：忘了 / 模糊 / 记住了'),
                    const SizedBox(height: 16),
                    if (words.isEmpty)
                      Expanded(
                        child: EmptyState(
                          icon: Icons.celebration_outlined,
                          title: '今日复习已完成',
                          subtitle: '所有到期单词都已复习，或尚未开始学习。\n继续保持，明天见！',
                          actionLabel: '去学习新词',
                          onAction: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const BookSelectionPage(),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          child: StudyModeList(
                            onModeSelected: (mode) {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => StudySessionPage(
                                    mode: mode,
                                    reviewOnly: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
