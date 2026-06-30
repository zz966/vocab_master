import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router.dart';
import '../../models/word.dart';
import '../../providers/repository_providers.dart';
import '../../utils/word_display_utils.dart';

class WordLookupPage extends ConsumerStatefulWidget {
  const WordLookupPage({super.key});

  @override
  ConsumerState<WordLookupPage> createState() => _WordLookupPageState();
}

class _WordLookupPageState extends ConsumerState<WordLookupPage> {
  final _searchController = TextEditingController();
  List<_LookupResult> _results = const [];
  bool _searching = false;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed == _lastQuery) {
      return;
    }

    _lastQuery = trimmed;
    if (trimmed.length < 2) {
      setState(() {
        _searching = false;
        _results = const [];
      });
      return;
    }

    setState(() => _searching = true);

    final words =
        await ref.read(wordRepositoryProvider).searchWords(trimmed);

    if (!mounted || trimmed != _lastQuery) {
      return;
    }

    final bookRepo = ref.read(bookRepositoryProvider);
    final results = <_LookupResult>[];
    for (final word in words) {
      final bookId = word.bookIds.isNotEmpty ? word.bookIds.first : null;
      final book = bookId == null ? null : await bookRepo.getBook(bookId);
      results.add(
        _LookupResult(
          word: word,
          bookId: bookId,
          bookTitle: book?.title,
        ),
      );
    }

    if (!mounted || trimmed != _lastQuery) {
      return;
    }

    setState(() {
      _searching = false;
      _results = results;
    });
  }

  Future<void> _openWord(_LookupResult result) async {
    await AppRouter.pushWordDetail(
      context,
      wordId: result.word.id,
      bookId: result.bookId,
      bookTitle: result.bookTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('查单词'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '输入英文或中文（至少 2 个字符）',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _lastQuery = '';
                          setState(() => _results = const []);
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              textInputAction: TextInputAction.search,
              onChanged: _runSearch,
              onSubmitted: _runSearch,
            ),
          ),
          if (_searching)
            const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: _buildBody(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final query = _searchController.text.trim();

    if (query.length < 2) {
      return const Center(
        child: Text('输入关键词开始搜索'),
      );
    }

    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_results.isEmpty) {
      return const Center(child: Text('未找到匹配单词'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = _results[index];
        final word = result.word;
        final definitions = displayDefinitions(word);
        final subtitle = definitions.isNotEmpty
            ? definitions.first.meaning
            : word.chinese;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            word.english,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle.trim().isNotEmpty) Text(subtitle),
              if (result.bookTitle != null)
                Text(
                  result.bookTitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openWord(result),
        );
      },
    );
  }
}

class _LookupResult {
  const _LookupResult({
    required this.word,
    this.bookId,
    this.bookTitle,
  });

  final Word word;
  final String? bookId;
  final String? bookTitle;
}