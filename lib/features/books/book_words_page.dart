import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/word.dart';
import '../../providers/book_provider.dart';
import '../study/word_detail_page.dart';

class BookWordsPage extends ConsumerStatefulWidget {
  const BookWordsPage({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  final int bookId;
  final String bookTitle;

  @override
  ConsumerState<BookWordsPage> createState() => _BookWordsPageState();
}

enum _FamiliarityFilter { all, newWord, learning, mastered }

class _BookWordsPageState extends ConsumerState<BookWordsPage> {
  String _query = '';
  _FamiliarityFilter _familiarityFilter = _FamiliarityFilter.all;

  bool _matchesFamiliarity(Word word) {
    return switch (_familiarityFilter) {
      _FamiliarityFilter.all => true,
      _FamiliarityFilter.newWord => word.familiarity == 0,
      _FamiliarityFilter.learning =>
        word.familiarity >= 1 && word.familiarity <= 3,
      _FamiliarityFilter.mastered => word.familiarity >= 4,
    };
  }

  List<Word> _filterWords(List<Word> words) {
    var result = words.where(_matchesFamiliarity);
    if (_query.isNotEmpty) {
      final lower = _query.toLowerCase();
      result = result.where(
        (word) =>
            word.english.toLowerCase().contains(lower) ||
            word.chinese.contains(_query),
      );
    }
    return result.toList()..sort((a, b) => a.english.compareTo(b.english));
  }

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(bookWordsProvider(widget.bookId));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bookTitle} · 单词'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: const Text('全部'),
                  selected: _familiarityFilter == _FamiliarityFilter.all,
                  onSelected: (_) => setState(
                    () => _familiarityFilter = _FamiliarityFilter.all,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('未学'),
                  selected: _familiarityFilter == _FamiliarityFilter.newWord,
                  onSelected: (_) => setState(
                    () => _familiarityFilter = _FamiliarityFilter.newWord,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('学习中'),
                  selected: _familiarityFilter == _FamiliarityFilter.learning,
                  onSelected: (_) => setState(
                    () => _familiarityFilter = _FamiliarityFilter.learning,
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('已掌握'),
                  selected: _familiarityFilter == _FamiliarityFilter.mastered,
                  onSelected: (_) => setState(
                    () => _familiarityFilter = _FamiliarityFilter.mastered,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                    child: Text(_query.isEmpty ? '暂无单词' : '未找到匹配单词'),
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
                      trailing: _FamiliarityBadge(familiarity: word.familiarity),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => WordDetailPage(
                              wordId: word.id,
                              wordIds: filtered.map((item) => item.id).toList(),
                            ),
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

class _FamiliarityBadge extends StatelessWidget {
  const _FamiliarityBadge({required this.familiarity});

  final int familiarity;

  @override
  Widget build(BuildContext context) {
    final color = switch (familiarity) {
      >= 4 => Colors.green,
      >= 2 => Colors.orange,
      >= 1 => Colors.blue,
      _ => Colors.grey,
    };
    return Chip(
      label: Text('$familiarity/5', style: const TextStyle(fontSize: 11)),
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      visualDensity: VisualDensity.compact,
    );
  }
}