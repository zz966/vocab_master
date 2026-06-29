import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router.dart';
import '../../models/word_book.dart';
import '../../providers/study_provider.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/level_challenge_repository.dart';
import '../../utils/level_challenge.dart';
import '../../utils/level_utils.dart';
import '../study/study_session_page.dart';
import '../study/word_detail_page.dart';
import 'widgets/challenge_mode_picker_sheet.dart';
import 'widgets/level_card.dart';

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

class _LevelSelectionPageState extends ConsumerState<LevelSelectionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<BookLevel> _levels = const [];
  Map<int, int> _levelStars = const {};
  bool _loading = true;
  WordBook? _book;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLevels();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLevels() async {
    setState(() => _loading = true);

    final bookRepo = ref.read(bookRepositoryProvider);
    final challengeRepo = ref.read(levelChallengeRepositoryProvider);
    final book = await bookRepo.getBook(widget.bookId);
    final words = await bookRepo.getWordsForBook(widget.bookId);
    final levelStars = await challengeRepo.getStarCountsForBook(widget.bookId);

    if (!mounted) {
      return;
    }

    setState(() {
      _book = book;
      _levels = splitWordsIntoLevels(words);
      _levelStars = levelStars;
      _loading = false;
    });
  }

  Future<void> _startStudyLevel(BookLevel level) async {
    ref.read(selectedBookIdsProvider.notifier).setAll([widget.bookId]);

    final sortedWords = level.words.toList()
      ..sort((a, b) => a.english.compareTo(b.english));
    if (sortedWords.isEmpty) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WordDetailPage(
          wordId: sortedWords.first.id,
          wordIds: sortedWords.map((word) => word.id).toList(),
          bookId: widget.bookId,
          bookTitle: widget.bookTitle,
        ),
      ),
    );

    if (mounted) {
      await _loadLevels();
    }
  }

  Future<void> _startChallengeLevel(BookLevel level) async {
    final mode = await showChallengeModePicker(context);
    if (mode == null || !mounted) {
      return;
    }

    ref.read(selectedBookIdsProvider.notifier).setAll([widget.bookId]);

    final challengeRef = LevelChallengeRef(
      bookId: widget.bookId,
      levelIndex: level.index,
      mode: mode,
    );

    final starEarned = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => StudySessionPage(
          mode: mode,
          overrideWords: level.words,
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
    ref.read(navigationIndexProvider.notifier).state = index;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = levelAccentColor(_book?.coverColor);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('关卡列表'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '学习'),
            Tab(text: '测试'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _levels.isEmpty
              ? const Center(child: Text('该单词书暂无单词'))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _LevelGrid(
                      levels: _levels,
                      levelStars: _levelStars,
                      accentColor: accentColor,
                      onRefresh: _loadLevels,
                      onLevelTap: _startStudyLevel,
                    ),
                    _LevelGrid(
                      levels: _levels,
                      levelStars: _levelStars,
                      accentColor: accentColor,
                      onRefresh: _loadLevels,
                      onLevelTap: _startChallengeLevel,
                    ),
                  ],
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
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: '单词训练',
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

class _LevelGrid extends StatelessWidget {
  const _LevelGrid({
    required this.levels,
    required this.levelStars,
    required this.accentColor,
    required this.onRefresh,
    required this.onLevelTap,
  });

  final List<BookLevel> levels;
  final Map<int, int> levelStars;
  final Color accentColor;
  final Future<void> Function() onRefresh;
  final ValueChanged<BookLevel> onLevelTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.92,
        ),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          return LevelCard(
            level: level,
            starCount: levelStars[level.index] ?? 0,
            accentColor: accentColor,
            onTap: () => onLevelTap(level),
          );
        },
      ),
    );
  }
}