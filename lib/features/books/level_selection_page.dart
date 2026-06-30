import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/word_book.dart';
import '../../providers/book_provider.dart';
import '../../providers/repository_providers.dart';
import '../../utils/level_utils.dart';
import '../study/word_detail_page.dart';
import 'widgets/book_flow_bottom_nav.dart';
import 'widgets/level_card.dart';
import 'widgets/level_grid.dart';

class LevelSelectionPage extends ConsumerStatefulWidget {
  const LevelSelectionPage({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  final String bookId;
  final String bookTitle;

  @override
  ConsumerState<LevelSelectionPage> createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends ConsumerState<LevelSelectionPage> {
  List<BookLevel> _levels = const [];
  Map<int, int> _levelStudyProgress = const {};
  bool _loading = true;
  WordBook? _book;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    setState(() => _loading = true);

    final bookRepo = ref.read(bookRepositoryProvider);
    final studyRepo = ref.read(levelStudyRepositoryProvider);
    final book = await bookRepo.getBook(widget.bookId);
    final words = await bookRepo.getWordsForBook(widget.bookId);
    final levels = splitWordsIntoLevels(words);
    final levelStudyProgress = await studyRepo.getProgressPercentsForBook(
      bookId: widget.bookId,
      levels: levels,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _book = book;
      _levels = levels;
      _levelStudyProgress = levelStudyProgress;
      _loading = false;
    });
  }

  Future<void> _startStudyLevel(BookLevel level) async {
    final sortedWords = level.words.toList()
      ..sort((a, b) => a.english.compareTo(b.english));
    if (sortedWords.isEmpty) {
      return;
    }

    final studyRepo = ref.read(levelStudyRepositoryProvider);
    final maxWordIndex = await studyRepo.getMaxWordIndex(
      widget.bookId,
      level.index,
    );

    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordDetailPage(
          wordId: sortedWords.first.id,
          wordIds: sortedWords.map((word) => word.id).toList(),
          bookId: widget.bookId,
          bookTitle: widget.bookTitle,
          levelIndex: level.index,
          initialMaxWordIndex: maxWordIndex,
        ),
      ),
    );

    if (mounted) {
      await _loadLevels();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = levelAccentColor(_book?.coverColor);
    final levelStars = ref.watch(levelChallengeStarsProvider(widget.bookId));
    final levelStarCounts = levelStars.valueOrNull ?? const {};

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('关卡列表'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _levels.isEmpty
              ? const Center(child: Text('该单词书暂无单词'))
              : LevelGrid(
                  levels: _levels,
                  levelStars: levelStarCounts,
                  levelStudyProgress: _levelStudyProgress,
                  accentColor: accentColor,
                  onRefresh: _loadLevels,
                  onLevelTap: _startStudyLevel,
                ),
      bottomNavigationBar: const BookFlowBottomNav(),
    );
  }
}