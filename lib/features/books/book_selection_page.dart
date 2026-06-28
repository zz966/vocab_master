import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/study_mode.dart';
import '../../providers/book_provider.dart';
import '../../providers/study_provider.dart';
import '../../utils/study_queue.dart';
import '../study/study_session_page.dart';
import '../study/widgets/study_mode_picker_sheet.dart';
import 'widgets/book_card.dart';

class BookSelectionPage extends ConsumerStatefulWidget {
  const BookSelectionPage({super.key});

  @override
  ConsumerState<BookSelectionPage> createState() => _BookSelectionPageState();
}

class _BookSelectionPageState extends ConsumerState<BookSelectionPage> {
  void _startWithMode(StudyMode mode) {
    ref.read(studySessionModeProvider.notifier).state = mode;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => StudySessionPage(mode: mode)),
    );
  }

  void _startFlashcard() {
    _startWithMode(StudyMode.flashcard);
  }

  Future<void> _pickMode() async {
    final mode = await showStudyModePicker(context);
    if (mode == null || !mounted) {
      return;
    }
    _startWithMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksProvider);
    final selectedIds = ref.watch(selectedBookIdsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('选择单词书')),
      body: booksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('加载失败: $error')),
        data: (books) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '已选 ${selectedIds.length} 本 · 支持多选混合学习',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: StudyQueueOrder.values.map((order) {
                        final selected =
                            ref.watch(studyQueueOrderProvider) == order;
                        return FilterChip(
                          label: Text(order.label),
                          selected: selected,
                          onSelected: (_) {
                            ref.read(studyQueueOrderProvider.notifier).state =
                                order;
                            ref.invalidate(studyWordsProvider(selectedIds));
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final progress = books[index];
                    final selected = selectedIds.contains(progress.book.id);
                    return BookCard(
                      progress: progress,
                      selected: selected,
                      onTap: () {
                        ref
                            .read(selectedBookIdsProvider.notifier)
                            .toggle(progress.book.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: selectedIds.isEmpty ? null : _startFlashcard,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  selectedIds.isEmpty
                      ? '请至少选择 1 本单词书'
                      : '开始学习（速刷 · 已选 ${selectedIds.length} 本）',
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: selectedIds.isEmpty ? null : _pickMode,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
                child: const Text('选择其他学习模式'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
