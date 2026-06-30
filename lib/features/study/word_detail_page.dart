import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/word.dart';
import '../../providers/book_provider.dart';
import '../../providers/study_provider.dart';
import '../../providers/repository_providers.dart';
import '../../repositories/book_repository.dart';
import '../../utils/auto_read.dart';
import '../../utils/book_content_utils.dart';
import '../../utils/color_utils.dart';
import '../../utils/level_utils.dart';
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
    this.levelIndex,
    this.initialMaxWordIndex,
  });

  final String wordId;
  final List<String>? wordIds;
  final String? bookId;
  final String? bookTitle;
  final int? levelIndex;
  final int? initialMaxWordIndex;

  @override
  ConsumerState<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends ConsumerState<WordDetailPage> {
  late String _currentWordId;
  late int _maxProgressIndex;
  bool _loading = true;
  Word? _word;
  List<Word> _peerWords = [];
  WordDetailTab _selectedTab = WordDetailTab.examples;

  @override
  void initState() {
    super.initState();
    _currentWordId = widget.wordId;
    _maxProgressIndex = widget.initialMaxWordIndex ?? -1;
    _loadWord(_currentWordId);
  }

  bool get _tracksLevelStudyProgress =>
      widget.bookId != null &&
      widget.levelIndex != null &&
      widget.wordIds != null &&
      widget.wordIds!.length > 1;

  Future<void> _persistMaxProgress(int maxWordIndex) async {
    if (!_tracksLevelStudyProgress) {
      return;
    }

    await ref.read(levelStudyRepositoryProvider).saveMaxProgress(
          bookId: widget.bookId!,
          levelIndex: widget.levelIndex!,
          maxWordIndex: maxWordIndex,
        );
  }

  Future<void> _loadWord(String wordId) async {
    setState(() => _loading = true);

    final wordRepo = ref.read(wordRepositoryProvider);
    final bookRepo = ref.read(bookRepositoryProvider);
    final word = await wordRepo.getWord(
      wordId,
      bookId: widget.bookId,
    );

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

    if (!isRichBookWord(word) &&
        (word.memoryTips == null || word.structuredExamples.isEmpty)) {
      final peerEnglish = peerWords.map((item) => item.english).toList();
      WordEnrichment.apply(word, peerWords: peerEnglish);
      await wordRepo.saveWord(word, bookId: bookId);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
      _word = word;
      _peerWords = peerWords;
    });
    await autoSpeakWordIfEnabled(ref, word);
  }

  String? _primaryBookId(Word word) {
    if (widget.bookId != null) {
      return widget.bookId;
    }
    if (word.bookIds.isEmpty) {
      return null;
    }
    return word.bookIds.first;
  }

  List<String> get _navigationIds {
    if (widget.wordIds != null && widget.wordIds!.isNotEmpty) {
      return widget.wordIds!;
    }
    return [_currentWordId];
  }

  String? get _previousWordId {
    final ids = _navigationIds;
    final index = ids.indexOf(_currentWordId);
    if (index <= 0) {
      return null;
    }
    return ids[index - 1];
  }

  String? get _nextWordId {
    final ids = _navigationIds;
    final index = ids.indexOf(_currentWordId);
    if (index == -1 || index >= ids.length - 1) {
      return null;
    }
    return ids[index + 1];
  }

  int get _currentIndex {
    final index = _navigationIds.indexOf(_currentWordId);
    return index < 0 ? 0 : index;
  }

  /// 进度条：只记录本关最高到达位置，只增不减。
  double? get _sessionProgressBarValue {
    final ids = _navigationIds;
    if (ids.length <= 1) {
      return null;
    }

    if (_tracksLevelStudyProgress) {
      return levelBrowseProgress(
        currentIndex: _maxProgressIndex,
        totalWords: ids.length,
      );
    }

    return levelBrowseProgress(
      currentIndex: _currentIndex,
      totalWords: ids.length,
    );
  }

  void _goToWord(String wordId, {required bool forward}) {
    ref.read(ttsServiceProvider).stop();
    final newIndex = _navigationIds.indexOf(wordId);
    final resolvedIndex = newIndex < 0 ? _currentIndex : newIndex;

    if (_tracksLevelStudyProgress &&
        forward &&
        resolvedIndex > _maxProgressIndex) {
      setState(() {
        _currentWordId = wordId;
        _maxProgressIndex = resolvedIndex;
      });
      unawaited(_persistMaxProgress(resolvedIndex));
    } else {
      setState(() => _currentWordId = wordId);
    }
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
    final sessionProgressBar = _sessionProgressBarValue;
    final navigationTotal = _navigationIds.length;
    final bookProgress =
        bookId != null ? ref.watch(bookProgressProvider(bookId)) : null;
    final bookProgressAsync =
        sessionProgressBar == null ? bookProgress : null;
    final bookCoverColor =
        bookProgress?.valueOrNull?.book.coverColor ?? '#607D8B';

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
              sessionProgress: sessionProgressBar,
              sessionCurrent: sessionProgressBar == null
                  ? null
                  : _currentIndex + 1,
              sessionTotal:
                  sessionProgressBar == null ? null : navigationTotal,
              progressColor: bookCoverColor,
              onPrevious: _previousWordId == null
                  ? null
                  : () => _goToWord(_previousWordId!, forward: false),
              onNext: _nextWordId == null
                  ? null
                  : () => _goToWord(_nextWordId!, forward: true),
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
    this.sessionProgress,
    this.sessionCurrent,
    this.sessionTotal,
    this.progressColor,
  });

  final AsyncValue<BookProgress?>? bookProgressAsync;
  final double? sessionProgress;
  final int? sessionCurrent;
  final int? sessionTotal;
  final String? progressColor;
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
            if (sessionProgress != null)
              _buildProgressSection(
                theme: theme,
                label: '学习进度',
                value: sessionProgress!,
                trailing: '${sessionCurrent ?? 0}/${sessionTotal ?? 0}',
                color: parseHexColor(progressColor ?? '#607D8B'),
              )
            else if (bookProgressAsync != null)
              bookProgressAsync!.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (progress) {
                  if (progress == null) {
                    return const SizedBox.shrink();
                  }
                  return _buildProgressSection(
                    theme: theme,
                    label: '学习进度',
                    value: progress.learnedRate,
                    trailing: '${(progress.learnedRate * 100).round()}%',
                    color: parseHexColor(progress.book.coverColor),
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

  Widget _buildProgressSection({
    required ThemeData theme,
    required String label,
    required double value,
    required String trailing,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            Text(
              trailing,
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
            value: value.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.15),
            color: color,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}