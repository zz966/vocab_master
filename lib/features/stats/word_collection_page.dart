import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:share_plus/share_plus.dart';

import '../../core/study_mode.dart';
import '../../models/word.dart';
import '../../providers/book_provider.dart';
import '../../providers/export_refresh_provider.dart';
import '../../providers/study_provider.dart';
import '../../utils/export_file.dart';
import '../../utils/word_collection_export.dart';
import '../study/study_session_page.dart';
import '../study/word_detail_page.dart';

class WordCollectionPage extends ConsumerStatefulWidget {
  const WordCollectionPage({
    super.key,
    required this.title,
    required this.isWrongBook,
  });

  final String title;
  final bool isWrongBook;

  @override
  ConsumerState<WordCollectionPage> createState() => _WordCollectionPageState();
}

class _WordCollectionPageState extends ConsumerState<WordCollectionPage> {
  String? _bookFilterId;
  String _searchQuery = '';

  WordCollectionKind get _kind => widget.isWrongBook
      ? WordCollectionKind.wrongBook
      : WordCollectionKind.favorites;

  List<Word> _filterWords(List<Word> words) {
    if (_searchQuery.isEmpty) {
      return words;
    }
    return words
        .where(
          (word) =>
              word.english.toLowerCase().contains(_searchQuery) ||
              word.chinese.contains(_searchQuery),
        )
        .toList();
  }

  Future<void> _exportWords(
    List<Word> words, {
    required String format,
    bool shareAfter = false,
  }) async {
    if (words.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('没有可导出的单词')));
      return;
    }

    final isJson = format == 'json';
    final content = isJson
        ? WordCollectionExportCodec.toJson(words, kind: _kind)
        : WordCollectionExportCodec.toCsv(words);
    final fileName = buildWordCollectionFileName(
      kind: _kind,
      format: isJson ? 'json' : 'csv',
    );
    final path = await saveTextToDocuments(
      content: content,
      fileName: fileName,
    );

    if (path != null) {
      bumpExportFilesRevision(ref);
    }
    if (!mounted) {
      return;
    }

    if (path != null && shareAfter) {
      final result = await shareFileAtPath(path, name: fileName);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == ShareExportResult.shared ? '已导出并打开分享' : '已导出，分享失败',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          path == null
              ? '${isJson ? 'JSON' : 'CSV'} 已生成（当前平台不支持保存文件）'
              : '已导出至 $path',
        ),
        action: path == null
            ? null
            : SnackBarAction(
                label: '分享',
                onPressed: () => shareFileAtPath(path, name: fileName),
              ),
      ),
    );
  }

  Future<void> _shareWordsText(List<Word> words) async {
    final text = formatWordCollectionShareText(kind: _kind, words: words);
    await Share.share(text, subject: 'VocabMaster ${_kind.title}');
  }

  void _startFlashcardReview(List<Word> words, {int startIndex = 0}) {
    if (words.isEmpty) {
      return;
    }
    final queue = [
      ...words.sublist(startIndex),
      ...words.sublist(0, startIndex),
    ];
    final sessionType = widget.isWrongBook ? 'wrong_book' : 'favorites';
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StudySessionPage(
          mode: StudyMode.flashcard,
          overrideWords: queue,
          sessionType: sessionType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookIds = _bookFilterId == null ? null : [_bookFilterId!];
    final wordsAsync = widget.isWrongBook
        ? ref.watch(wrongBookProvider(bookIds))
        : ref.watch(favoritesProvider(bookIds));
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          wordsAsync.maybeWhen(
            data: (words) {
              if (words.isEmpty) {
                return const SizedBox.shrink();
              }
              return PopupMenuButton<String>(
                onSelected: (action) async {
                  final filtered = _filterWords(words);
                  switch (action) {
                    case 'share_text':
                      await _shareWordsText(filtered);
                    case 'export_csv':
                      await _exportWords(filtered, format: 'csv');
                    case 'export_csv_share':
                      await _exportWords(
                        filtered,
                        format: 'csv',
                        shareAfter: true,
                      );
                    case 'export_json':
                      await _exportWords(filtered, format: 'json');
                    case 'export_json_share':
                      await _exportWords(
                        filtered,
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
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: wordsAsync.maybeWhen(
        data: (words) {
          if (words.isEmpty) {
            return null;
          }
          return FloatingActionButton.extended(
            onPressed: () => _startFlashcardReview(words),
            icon: const Icon(Icons.bolt),
            label: const Text('速刷复习'),
          );
        },
        orElse: () => null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索单词',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () => setState(() => _searchQuery = ''),
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
              onChanged: (value) =>
                  setState(() => _searchQuery = value.trim().toLowerCase()),
            ),
          ),
          booksAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (books) {
              return SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    FilterChip(
                      label: const Text('全部'),
                      selected: _bookFilterId == null,
                      onSelected: (_) => setState(() => _bookFilterId = null),
                    ),
                    const SizedBox(width: 8),
                    ...books.map(
                      (progress) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(progress.book.title),
                          selected: _bookFilterId == progress.book.id,
                          onSelected: (_) =>
                              setState(() => _bookFilterId = progress.book.id),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: wordsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('加载失败: $error')),
              data: (words) {
                final filtered = _filterWords(words);

                if (words.isEmpty) {
                  return Center(
                    child: Text(widget.isWrongBook ? '错题本为空' : '暂无收藏'),
                  );
                }
                if (filtered.isEmpty) {
                  return const Center(child: Text('未找到匹配单词'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    invalidateStudyData(ref);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final word = filtered[index];
                      return _WordListTile(
                        word: word,
                        isWrongBook: widget.isWrongBook,
                        onTap: () =>
                            _startFlashcardReview(filtered, startIndex: index),
                        onDetail: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => WordDetailPage(wordId: word.id),
                            ),
                          );
                        },
                        onRemove: () async {
                          if (widget.isWrongBook) {
                            await ref
                                .read(studyServiceProvider)
                                .removeFromWrongBook(word);
                          } else {
                            await ref
                                .read(studyServiceProvider)
                                .toggleFavorite(word);
                          }
                          invalidateStudyData(ref);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WordListTile extends StatelessWidget {
  const _WordListTile({
    required this.word,
    required this.isWrongBook,
    required this.onTap,
    required this.onDetail,
    required this.onRemove,
  });

  final Word word;
  final bool isWrongBook;
  final VoidCallback onTap;
  final VoidCallback onDetail;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(word.english),
      subtitle: Text(word.chinese),
      leading: Icon(Icons.bolt, color: Theme.of(context).colorScheme.primary),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: '详情',
            onPressed: onDetail,
          ),
          IconButton(
            icon: Icon(isWrongBook ? Icons.delete_outline : Icons.favorite),
            color: isWrongBook ? Colors.grey : Colors.red,
            tooltip: isWrongBook ? '移出错题本' : '取消收藏',
            onPressed: onRemove,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
