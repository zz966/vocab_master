import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/word.dart';
import '../../providers/book_provider.dart';
import '../../providers/word_provider.dart';
import '../../repositories/book_repository.dart';
import '../../utils/color_utils.dart';
import '../../utils/word_enrichment.dart';
import 'widgets/word_detail_info_section.dart';
import 'widgets/word_detail_tab_content.dart';

class WordDetailPage extends ConsumerStatefulWidget {
  const WordDetailPage({
    super.key,
    required this.wordId,
    this.wordIds,
    this.bookId,
    this.bookTitle,
  });

  final int wordId;
  final List<int>? wordIds;
  final int? bookId;
  final String? bookTitle;

  @override
  ConsumerState<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends ConsumerState<WordDetailPage> {
  late int _currentWordId;
  bool _loading = true;
  Word? _word;
  List<Word> _peerWords = [];
  WordDetailTab _selectedTab = WordDetailTab.examples;

  @override
  void initState() {
    super.initState();
    _currentWordId = widget.wordId;
    _loadWord(_currentWordId);
  }

  Future<void> _loadWord(int wordId) async {
    setState(() => _loading = true);

    final wordRepo = ref.read(wordRepositoryProvider);
    final bookRepo = ref.read(bookRepositoryProvider);
    final word = await wordRepo.getWord(wordId);

    if (!mounted) {
      return;
    }

    if (word == null) {
      setState(() {
        _loading = false;
        _word = null;
        _peerWords = [];
      });
      return;
    }

    final bookId = widget.bookId ?? _primaryBookId(word);
    List<Word> peerWords = [];
    if (bookId != null) {
      peerWords = await bookRepo.getWordsForBook(bookId);
    } else if (word.bookIds.isNotEmpty) {
      peerWords = await wordRepo.getWordsForBooks(word.bookIds);
    }

    if (word.memoryTips == null || word.structuredExamples == null) {
      final peerEnglish = peerWords.map((item) => item.english).toList();
      WordEnrichment.apply(word, peerWords: peerEnglish);
      await wordRepo.saveWord(word);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
      _word = word;
      _peerWords = peerWords;
    });
  }

  int? _primaryBookId(Word word) {
    if (widget.bookId != null) {
      return widget.bookId;
    }
    if (word.bookIds.isEmpty) {
      return null;
    }
    return word.bookIds.first;
  }

  List<int> get _navigationIds {
    if (widget.wordIds != null && widget.wordIds!.isNotEmpty) {
      return widget.wordIds!;
    }
    return [_currentWordId];
  }

  int? get _previousWordId {
    final ids = _navigationIds;
    final index = ids.indexOf(_currentWordId);
    if (index <= 0) {
      return null;
    }
    return ids[index - 1];
  }

  int? get _nextWordId {
    final ids = _navigationIds;
    final index = ids.indexOf(_currentWordId);
    if (index == -1 || index >= ids.length - 1) {
      return null;
    }
    return ids[index + 1];
  }

  void _goToWord(int wordId) {
    setState(() => _currentWordId = wordId);
    _loadWord(wordId);
  }

  String _appBarTitle(Word? word) {
    if (widget.bookTitle != null && widget.bookTitle!.trim().isNotEmpty) {
      return widget.bookTitle!;
    }
    return word?.english ?? '单词详情';
  }

  @override
  Widget build(BuildContext context) {
    final word = _word;
    final bookId = widget.bookId ?? (word != null ? _primaryBookId(word) : null);
    final bookProgressAsync =
        bookId == null ? null : ref.watch(bookProgressProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_appBarTitle(word)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : word == null
              ? const Center(child: Text('单词不存在'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WordDetailInfoSection(word: word),
                    _WordDetailTabBar(
                      selectedTab: _selectedTab,
                      onTabSelected: (tab) {
                        setState(() => _selectedTab = tab);
                      },
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: WordDetailTabContent(
                        word: word,
                        tab: _selectedTab,
                        peerWords: _peerWords,
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: _loading || word == null
          ? null
          : _WordDetailBottomBar(
              bookProgressAsync: bookProgressAsync,
              onPrevious: _previousWordId == null
                  ? null
                  : () => _goToWord(_previousWordId!),
              onNext:
                  _nextWordId == null ? null : () => _goToWord(_nextWordId!),
            ),
    );
  }
}

class _WordDetailTabBar extends StatelessWidget {
  const _WordDetailTabBar({
    required this.selectedTab,
    required this.onTabSelected,
  });

  final WordDetailTab selectedTab;
  final ValueChanged<WordDetailTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: WordDetailTab.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = WordDetailTab.values[index];
          final selected = selectedTab == tab;

          return ChoiceChip(
            label: Text(tab.label),
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
            onSelected: (_) => onTabSelected(tab),
          );
        },
      ),
    );
  }
}

class _WordDetailBottomBar extends StatelessWidget {
  const _WordDetailBottomBar({
    required this.bookProgressAsync,
    required this.onPrevious,
    required this.onNext,
  });

  final AsyncValue<BookProgress?>? bookProgressAsync;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (bookProgressAsync != null)
              bookProgressAsync!.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (progress) {
                  if (progress == null) {
                    return const SizedBox.shrink();
                  }
                  final percent = (progress.learnedRate * 100).round();
                  final color = parseHexColor(progress.book.coverColor);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '学习进度',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            '$percent%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress.learnedRate,
                          minHeight: 6,
                          backgroundColor: color.withValues(alpha: 0.15),
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPrevious,
                    child: const Text('上一词'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onNext,
                    child: const Text('下一词'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}