import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router.dart';
import '../../models/word.dart';
import '../../providers/repository_providers.dart';
import '../../providers/study_provider.dart';
import '../../utils/quick_browse_utils.dart';
import '../study/word_detail_page.dart';
import 'widgets/quick_browse_word_item.dart';

class QuickBrowsePage extends ConsumerStatefulWidget {
  const QuickBrowsePage({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  final String bookId;
  final String bookTitle;

  @override
  ConsumerState<QuickBrowsePage> createState() => _QuickBrowsePageState();
}

class _QuickBrowsePageState extends ConsumerState<QuickBrowsePage> {
  final _pageInputController = TextEditingController();
  final _listScrollController = ScrollController();

  List<Word> _allWords = const [];
  int _currentPage = 1;
  String? _selectedWordId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  void dispose() {
    _pageInputController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    setState(() => _loading = true);

    final words =
        await ref.read(bookRepositoryProvider).getWordsForBook(widget.bookId);
    final sorted = sortWordsForQuickBrowse(words);

    if (!mounted) {
      return;
    }

    setState(() {
      _allWords = sorted;
      _currentPage = clampQuickBrowsePage(
        _currentPage,
        wordCount: sorted.length,
      );
      _loading = false;
    });
    _syncPageInput();
  }

  int get _totalPages => quickBrowseTotalPages(_allWords.length);

  List<Word> get _pageWords => quickBrowsePageWords(
        _allWords,
        page: _currentPage,
      );

  List<String> get _allWordIds => _allWords.map((word) => word.id).toList();

  void _syncPageInput() {
    _pageInputController.text = '$_currentPage';
  }

  void _goToPage(int page) {
    final nextPage = clampQuickBrowsePage(
      page,
      wordCount: _allWords.length,
    );
    if (nextPage == _currentPage) {
      _syncPageInput();
      return;
    }

    setState(() {
      _currentPage = nextPage;
      _selectedWordId = null;
    });
    _syncPageInput();
    if (_listScrollController.hasClients) {
      _listScrollController.jumpTo(0);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _goToPage(_currentPage - 1);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      _goToPage(_currentPage + 1);
    }
  }

  void _jumpToInputPage() {
    final raw = _pageInputController.text.trim();
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效页码')),
      );
      _syncPageInput();
      return;
    }

    final clamped = clampQuickBrowsePage(
      parsed,
      wordCount: _allWords.length,
    );
    if (parsed != clamped) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('页码已调整为 $clamped（共 $_totalPages 页）')),
      );
    }
    _goToPage(clamped);
  }

  void _returnToBooksPage() {
    ref.read(navigationIndexProvider.notifier).setIndex(AppTab.books);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _openWordDetail(Word word) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordDetailPage(
          wordId: word.id,
          wordIds: _allWordIds,
          bookId: widget.bookId,
          bookTitle: widget.bookTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _returnToBooksPage),
        centerTitle: true,
        title: Text(widget.bookTitle),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _allWords.isEmpty
              ? const Center(child: Text('该单词书暂无单词'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _listScrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _pageWords.length,
                        itemBuilder: (context, index) {
                          final word = _pageWords[index];
                          return QuickBrowseWordItem(
                            word: word,
                            selected: _selectedWordId == word.id,
                            onTap: () {
                              setState(() => _selectedWordId = word.id);
                            },
                            onOpenDetail: () => _openWordDetail(word),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    _QuickBrowsePaginationBar(
                      currentPage: _currentPage,
                      totalPages: _totalPages,
                      pageInputController: _pageInputController,
                      onPrevious: _currentPage > 1 ? _goToPreviousPage : null,
                      onNext: _currentPage < _totalPages ? _goToNextPage : null,
                      onJump: _jumpToInputPage,
                      theme: theme,
                    ),
                  ],
                ),
    );
  }
}

class _QuickBrowsePaginationBar extends StatelessWidget {
  const _QuickBrowsePaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.pageInputController,
    required this.onPrevious,
    required this.onNext,
    required this.onJump,
    required this.theme,
  });

  final int currentPage;
  final int totalPages;
  final TextEditingController pageInputController;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onJump;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$currentPage / $totalPages',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPrevious,
                    child: const Text('上一页'),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 72,
                  child: TextField(
                    controller: pageInputController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => onJump(),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onJump,
                  child: const Text('跳转'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onNext,
                    child: const Text('下一页'),
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