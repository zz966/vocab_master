import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/study_mode.dart';
import '../../providers/book_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/study_provider.dart';
import '../books/book_selection_page.dart';
import '../review/review_page.dart';
import 'study_session_page.dart';
import 'widgets/study_mode_list.dart';

class StudyPage extends ConsumerWidget {
  const StudyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(selectedBookIdsProvider);
    final booksAsync = ref.watch(booksProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final remainingAsync = ref.watch(dailyQuotaRemainingProvider);
    final dueCountAsync = ref.watch(dueWordsCountProvider(selectedIds));

    return Scaffold(
      appBar: AppBar(
        title: const Text('学习'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const BookSelectionPage(),
                ),
              );
            },
            icon: const Icon(Icons.library_books_outlined),
            tooltip: '选择单词书',
          ),
        ],
      ),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (books) {
          if (selectedIds.isEmpty) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: (constraints.maxHeight - 48).clamp(
                        0,
                        double.infinity,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.menu_book,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '先选择一本词书',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '我们会根据每日目标和复习时间帮你安排今日任务。',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const BookSelectionPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.library_books_outlined),
                            label: const Text('选择单词书'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          final selectedBooks = books
              .where((item) => selectedIds.contains(item.book.id))
              .map((item) => item.book.title)
              .toList();
          final settings = settingsAsync.value;
          final allowExtra = settings?.allowExtraStudy ?? false;
          final remaining = remainingAsync.value ?? 0;
          final dueCount = dueCountAsync.value ?? 0;
          final goalReached = remaining == 0 && dueCount > 0 && !allowExtra;
          final extraStudying = remaining == 0 && dueCount > 0 && allowExtra;
          final defaultMode = StudyMode.fromId(
            settings?.defaultStudyMode ?? 'flashcard',
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '今日学习',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedBooks
                            .map((title) => Chip(label: Text(title)))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      if (!goalReached && !extraStudying)
                        Text(
                          '还可学习 $remaining 个新词',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      if (extraStudying)
                        Text(
                          '加练模式 · 共 $dueCount 个待学词',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                    ],
                  ),
                ),
              ),
              if (goalReached || extraStudying) ...[
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          extraStudying
                              ? Icons.fitness_center
                              : Icons.celebration,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            extraStudying
                                ? '今日目标已完成，加练模式已开启，可继续学习 $dueCount 个待学词'
                                : '今日学习目标已完成，可去复习巩固或明天继续新词',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (goalReached)
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ReviewPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text('去复习巩固'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                )
              else ...[
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => StudySessionPage(mode: defaultMode),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bolt),
                  label: Text('继续今日任务（${defaultMode.title}）'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 16),
                Text('切换练习方式', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                StudyModeList(
                  onModeSelected: (mode) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => StudySessionPage(mode: mode),
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
