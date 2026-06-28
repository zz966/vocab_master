import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/category_labels.dart';
import '../../core/router.dart';
import '../../providers/book_provider.dart';
import '../../providers/study_provider.dart';
import '../../repositories/book_repository.dart';
import '../search/global_search_page.dart';
import '../study/widgets/study_mode_picker_sheet.dart';
import 'create_book_page.dart';
import 'import_book_page.dart';
import '../../widgets/async_value_view.dart';
import '../../widgets/book_card.dart';

enum BookSortMode { name, progress, mastery }

extension BookSortModeLabel on BookSortMode {
  String get label => switch (this) {
    BookSortMode.name => '名称',
    BookSortMode.progress => '学习进度',
    BookSortMode.mastery => '掌握率',
  };
}

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  String _searchQuery = '';
  String? _categoryFilter;
  BookSortMode _sortMode = BookSortMode.name;

  bool _matchesSearch(BookProgress item) {
    if (_searchQuery.isEmpty) {
      return true;
    }
    final query = _searchQuery.toLowerCase();
    final title = item.book.title.toLowerCase();
    final category = item.book.category.toLowerCase();
    final categoryName = categoryLabel(item.book.category).toLowerCase();
    final difficulty = categoryDifficulty(item.book.category).toLowerCase();
    return title.contains(query) ||
        category.contains(query) ||
        categoryName.contains(query) ||
        difficulty.contains(query);
  }

  Future<void> _handleBookTap(BookProgress progress) async {
    ref.read(selectedBookIdsProvider.notifier).setAll([progress.book.id]);
    final mode = await showStudyModePicker(context);
    if (mode == null || !mounted) {
      return;
    }
    await AppRouter.pushStudySession(context, mode: mode);
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('单词书'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const GlobalSearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: '搜索单词',
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ImportBookPage()),
              );
            },
            icon: const Icon(Icons.upload_file),
            tooltip: '导入单词书',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const CreateBookPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('创建'),
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
          final filtered =
              books.where((item) {
                final matchesCategory =
                    _categoryFilter == null ||
                    item.book.category == _categoryFilter;
                return _matchesSearch(item) && matchesCategory;
              }).toList()..sort((a, b) {
                return switch (_sortMode) {
                  BookSortMode.name => a.book.title.compareTo(b.book.title),
                  BookSortMode.progress => b.learnedWords.compareTo(
                    a.learnedWords,
                  ),
                  BookSortMode.mastery => b.masteryRate.compareTo(
                    a.masteryRate,
                  ),
                };
              });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '搜索书名、分类或难度',
                    prefixIcon: Icon(Icons.menu_book),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    const Text('排序'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: BookSortMode.values.map((mode) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(mode.label),
                                selected: _sortMode == mode,
                                onSelected: (_) =>
                                    setState(() => _sortMode = mode),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    FilterChip(
                      label: const Text('全部'),
                      selected: _categoryFilter == null,
                      onSelected: (_) => setState(() => _categoryFilter = null),
                    ),
                    const SizedBox(width: 8),
                    ...bookCategories.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(categoryLabel(category)),
                          selected: _categoryFilter == category,
                          onSelected: (_) =>
                              setState(() => _categoryFilter = category),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    invalidateStudyData(ref);
                    await ref.read(booksProvider.future);
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.82,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final progress = filtered[index];
                      return BookCard(
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
