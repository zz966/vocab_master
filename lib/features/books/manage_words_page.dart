import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/word.dart';
import '../../providers/book_provider.dart';
import '../../providers/study_provider.dart';
import '../../repositories/book_repository.dart';
import '../study/word_detail_page.dart';
import 'add_word_page.dart';
import 'widgets/batch_import_dialog.dart';

class ManageWordsPage extends ConsumerStatefulWidget {
  const ManageWordsPage({super.key, required this.bookId});

  final String bookId;

  @override
  ConsumerState<ManageWordsPage> createState() => _ManageWordsPageState();
}

class _ManageWordsPageState extends ConsumerState<ManageWordsPage> {
  String _query = '';

  List<Word> _filterWords(List<Word> words) {
    if (_query.isEmpty) {
      return words;
    }
    final lower = _query.toLowerCase();
    return words
        .where(
          (word) =>
              word.english.toLowerCase().contains(lower) ||
              word.chinese.contains(_query),
        )
        .toList();
  }

  Future<void> _addWord() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddWordPage(bookId: widget.bookId),
      ),
    );
    _invalidate();
  }

  Future<void> _editWord(Word word) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddWordPage(bookId: widget.bookId, word: word),
      ),
    );
    _invalidate();
  }

  Future<void> _batchImport() async {
    final lines = await showBatchImportDialog(context);
    if (lines == null || lines.isEmpty) {
      return;
    }

    final repo = ref.read(bookRepositoryProvider);
    for (final line in lines) {
      await repo.addWordToBook(
        bookId: widget.bookId,
        english: line.english,
        chinese: line.chinese,
      );
    }

    _invalidate();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已导入 ${lines.length} 个单词')),
      );
    }
  }

  void _invalidate() {
    invalidateStudyData(ref);
    ref.invalidate(bookWordsProvider(widget.bookId));
    ref.invalidate(bookProgressProvider(widget.bookId));
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(bookWordsProvider(widget.bookId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('管理单词'),
        actions: [
          IconButton(
            onPressed: _batchImport,
            icon: const Icon(Icons.playlist_add),
            tooltip: '批量导入',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWord,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '搜索单词',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          Expanded(
            child: wordsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('加载失败: $error')),
              data: (words) {
                final filtered = _filterWords(words);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      _query.isEmpty ? '暂无单词，点击 + 添加' : '未找到匹配单词',
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final word = filtered[index];
                    return ListTile(
                      title: Text(word.english),
                      subtitle: Text(word.chinese),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                WordDetailPage(wordId: word.id),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _editWord(word),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await ref
                                  .read(bookRepositoryProvider)
                                  .removeWordFromBook(
                                    bookId: widget.bookId,
                                    wordId: word.id,
                                  );
                              _invalidate();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}