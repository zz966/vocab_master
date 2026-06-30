import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router.dart';
import '../../models/word_book.dart';
import '../../providers/book_provider.dart';
import '../../providers/repository_providers.dart';
import '../../providers/study_provider.dart';
import '../../utils/level_challenge.dart';
import '../../utils/level_utils.dart';
import '../study/study_session_page.dart';
import 'widgets/challenge_mode_picker_sheet.dart';
import 'widgets/level_card.dart';
import 'widgets/level_grid.dart';

class ChallengeLevelsPage extends ConsumerStatefulWidget {
  const ChallengeLevelsPage({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  final String bookId;
  final String bookTitle;

  @override
  ConsumerState<ChallengeLevelsPage> createState() =>
      _ChallengeLevelsPageState();
}

class _ChallengeLevelsPageState extends ConsumerState<ChallengeLevelsPage> {
  List<BookLevel> _levels = const [];
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
    final book = await bookRepo.getBook(widget.bookId);
    final words = await bookRepo.getWordsForBook(widget.bookId);

    if (!mounted) {
      return;
    }

    setState(() {
      _book = book;
      _levels = splitWordsIntoLevels(words);
      _loading = false;
    });
  }

  Future<void> _startChallengeLevel(BookLevel level) async {
    final mode = await showChallengeModePicker(context);
    if (mode == null || !mounted) {
      return;
    }

    final challengeRef = LevelChallengeRef(
      bookId: widget.bookId,
      levelIndex: level.index,
      mode: mode,
    );

    final starEarned = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => StudySessionPage(
          mode: mode,
          words: level.words,
          sessionType: challengeRef.sessionType,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    await _loadLevels();

    if (starEarned == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${mode.title} 满分通关，获得 1 颗星！')),
      );
    }
  }

  void _onBottomNavSelected(int index) {
    ref.read(navigationIndexProvider.notifier).setIndex(index);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = levelAccentColor(_book?.coverColor);
    final levelStars = ref.watch(levelChallengeStarsProvider(widget.bookId));
    final levelStarCounts = levelStars.valueOrNull ?? const {};

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('挑战模式'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _levels.isEmpty
              ? const Center(child: Text('该单词书暂无单词'))
              : LevelGrid(
                  levels: _levels,
                  levelStars: levelStarCounts,
                  accentColor: accentColor,
                  onRefresh: _loadLevels,
                  onLevelTap: _startChallengeLevel,
                ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: AppTab.books,
        onDestinationSelected: _onBottomNavSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: '单词书',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: '查单词',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}