import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/word.dart';
import '../../providers/book_provider.dart';
import '../../providers/export_refresh_provider.dart';
import '../../providers/search_provider.dart';
import '../../utils/export_file.dart';
import '../../utils/search_results_export.dart';
import '../study/word_detail_page.dart';

class GlobalSearchPage extends ConsumerStatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  ConsumerState<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends ConsumerState<GlobalSearchPage> {
  final _controller = TextEditingController();
  String _query = '';
  WordSearchFilter _filter = WordSearchFilter.none;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _exportResults(
    List<Word> words, {
    required String format,
    bool shareAfter = false,
  }) async {
    if (words.isEmpty) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有可导出的搜索结果')),
      );
      return;
    }

    final isJson = format == 'json';
    final content = isJson
        ? SearchResultsExportCodec.toJson(
            query: _query,
            words: words,
            filter: _filter,
          )
        : SearchResultsExportCodec.toCsv(words);
    final fileName = buildSearchResultsFileName(
      query: _query,
      format: isJson ? 'json' : 'csv',
    );
    final path = await saveTextToDocuments(content: content, fileName: fileName);

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
            result == ShareExportResult.shared
                ? '已导出并打开分享'
                : '已导出，分享失败',
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

  Future<void> _shareResultsText(List<Word> words) async {
    await Share.share(
      formatSearchResultsShareText(
        query: _query,
        words: words,
        filter: _filter,
      ),
      subject: 'VocabMaster 搜索结果',
    );
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksProvider);
    final resultsAsync = _query.length >= 2
        ? ref.watch(
            wordSearchProvider((query: _query, filter: _filter)),
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索单词'),
        actions: [
          if (resultsAsync != null)
            resultsAsync.when(
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
                        await _shareResultsText(words);
                      case 'export_csv':
                        await _exportResults(words, format: 'csv');
                      case 'export_csv_share':
                        await _exportResults(
                          words,
                          format: 'csv',
                          shareAfter: true,
                        );
                      case 'export_json':
                        await _exportResults(words, format: 'json');
                      case 'export_json_share':
                        await _exportResults(
                          words,
                          format: 'json',
                          shareAfter: true,
                        );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'share_text',
                      child: Text('分享文字列表'),
                    ),
                    PopupMenuItem(
                      value: 'export_csv',
                      child: Text('导出 CSV'),
                    ),
                    PopupMenuItem(
                      value: 'export_csv_share',
                      child: Text('导出并分享 CSV'),
                    ),
                    PopupMenuItem(
                      value: 'export_json',
                      child: Text('导出 JSON'),
                    ),
                    PopupMenuItem(
                      value: 'export_json_share',
                      child: Text('导出并分享 JSON'),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '输入英文或中文（至少2个字符）',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: const Text('收藏'),
                  selected: _filter.favoritesOnly,
                  onSelected: (selected) {
                    setState(() {
                      _filter = _filter.copyWith(
                        favoritesOnly: selected,
                        wrongBookOnly:
                            selected ? false : _filter.wrongBookOnly,
                      );
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('错题'),
                  selected: _filter.wrongBookOnly,
                  onSelected: (selected) {
                    setState(() {
                      _filter = _filter.copyWith(
                        wrongBookOnly: selected,
                        favoritesOnly:
                            selected ? false : _filter.favoritesOnly,
                      );
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('全部单词书'),
                  selected: _filter.bookId == null,
                  onSelected: (_) {
                    setState(() {
                      _filter = _filter.copyWith(clearBookId: true);
                    });
                  },
                ),
                ...booksAsync.maybeWhen(
                  data: (books) => books.map(
                    (progress) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Text(progress.book.title),
                        selected: _filter.bookId == progress.book.id,
                        onSelected: (_) {
                          setState(() {
                            _filter = _filter.copyWith(
                              bookId: progress.book.id,
                            );
                          });
                        },
                      ),
                    ),
                  ),
                  orElse: () => const <Widget>[],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _query.length < 2
                ? const Center(child: Text('输入关键词开始全局搜索'))
                : resultsAsync!.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        Center(child: Text('搜索失败: $error')),
                    data: (words) {
                      if (words.isEmpty) {
                        return const Center(child: Text('未找到匹配单词'));
                      }
                      return ListView.separated(
                        itemCount: words.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final word = words[index];
                          return ListTile(
                            title: Text(word.english),
                            subtitle: Text(word.chinese),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (word.inWrongBook)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                  ),
                                if (word.isFavorite)
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      WordDetailPage(wordId: word.id),
                                ),
                              );
                            },
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