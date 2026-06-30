import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/category_labels.dart';
import '../../core/router.dart';
import '../../providers/book_provider.dart';
import '../../providers/repository_providers.dart';
import '../../providers/study_provider.dart';
import '../../repositories/book_repository.dart';
import '../../widgets/async_value_view.dart';
import 'widgets/book_list_item.dart';
import 'widgets/book_mode_picker_sheet.dart';

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  String? _categoryFilter;

  Future<bool> _ensureBookHasWords(BookProgress progress) async {
    final words = await ref
        .read(bookRepositoryProvider)
        .getWordsForBook(progress.book.id);

    if (!mounted) {
      return false;
    }

    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('该单词书暂无单词')),
      );
      return false;
    }

    return true;
  }

  Future<void> _handleBookTap(BookProgress progress) async {
    if (!await _ensureBookHasWords(progress)) {
      return;
    }

    if (!mounted) {
      return;
    }

    final mode = await showBookModePicker(
      context,
      bookTitle: progress.book.title,
    );

    if (!mounted || mode == null) {
      return;
    }

    switch (mode) {
      case BookStudyMode.quickBrowse:
        await AppRouter.pushQuickBrowse(
          context,
          bookId: progress.book.id,
          bookTitle: progress.book.title,
        );
      case BookStudyMode.normal:
        await AppRouter.pushBookLevels(
          context,
          bookId: progress.book.id,
          bookTitle: progress.book.title,
        );
      case BookStudyMode.challenge:
        await AppRouter.pushChallengeLevels(
          context,
          bookId: progress.book.id,
          bookTitle: progress.book.title,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('单词书'),
      ),
      body: AsyncValueView<List<BookProgress>>(
        value: booksAsync,
        onRetry: () {
          invalidateStudyData(ref);
          ref.invalidate(booksProvider);
        },
        empty: const Center(child: Text('暂无单词书')),
        isEmpty: (books) => books.isEmpty,
        data: (books) {
          final filtered = books.where((item) {
            return _categoryFilter == null ||
                item.book.category == _categoryFilter;
          }).toList()
            ..sort((a, b) => a.book.title.compareTo(b.book.title));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CategoryTabBar(
                selectedCategory: _categoryFilter,
                onCategorySelected: (category) {
                  setState(() => _categoryFilter = category);
                },
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('该分类暂无单词书'))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(bookRepositoryProvider)
                              .ensureTestBook();
                          invalidateStudyData(ref);
                          ref.invalidate(booksProvider);
                          await ref.read(booksProvider.future);
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          itemCount: filtered.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant
                                .withValues(alpha: 0.5),
                          ),
                          itemBuilder: (context, index) {
                            final progress = filtered[index];
                            return BookListItem(
                              progress: progress,
                              onTap: () => _handleBookTap(progress),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryTabBar extends StatelessWidget {
  const _CategoryTabBar({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  static const _tabCategories = [
    null,
    ...bookCategories,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _tabCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _tabCategories[index];
          final selected = selectedCategory == category;
          final label = category == null ? '全部' : categoryLabel(category);

          return ChoiceChip(
            label: Text(label),
            selected: selected,
            showCheckmark: false,
            labelStyle: TextStyle(
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            selectedColor: theme.colorScheme.primaryContainer,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            onSelected: (_) => onCategorySelected(category),
          );
        },
      ),
    );
  }
}