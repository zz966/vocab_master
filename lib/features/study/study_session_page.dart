import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/study_mode.dart';
import '../../models/learning_session.dart';
import '../../models/word.dart';
import '../../providers/achievements_provider.dart';
import '../../providers/recent_achievements_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/study_provider.dart';
import '../../providers/word_provider.dart';
import '../../repositories/session_repository.dart';
import '../../repositories/settings_repository.dart';
import '../../utils/achievement_tracker.dart';
import '../achievements/widgets/achievement_unlock_dialog.dart';
import '../../providers/book_provider.dart';
import 'complete_study_page.dart';
import 'flashcard_page.dart';
import 'listening_page.dart';
import 'quiz_page.dart';
import 'spelling_page.dart';
import 'widgets/review_complete_dialog.dart';
import 'widgets/study_complete_dialog.dart';

class _QuizLoader extends ConsumerWidget {
  const _QuizLoader({
    required this.words,
    required this.bookIds,
    required this.session,
    required this.onSessionComplete,
    this.onProgressUpdate,
  });

  final List<Word> words;
  final List<int> bookIds;
  final LearningSession? session;
  final Future<void> Function() onSessionComplete;
  final VoidCallback? onProgressUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(wordRepositoryProvider).getWordsForBooks(bookIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final pool = snapshot.data ?? words;
        return QuizPage(
          words: words,
          bookIds: bookIds,
          wordPool: pool.length >= 4 ? pool : words,
          session: session,
          onSessionComplete: onSessionComplete,
          onProgressUpdate: onProgressUpdate,
        );
      },
    );
  }
}

class _ListeningLoader extends ConsumerWidget {
  const _ListeningLoader({
    required this.words,
    required this.bookIds,
    required this.session,
    required this.onSessionComplete,
    this.onProgressUpdate,
  });

  final List<Word> words;
  final List<int> bookIds;
  final LearningSession? session;
  final Future<void> Function() onSessionComplete;
  final VoidCallback? onProgressUpdate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(wordRepositoryProvider).getWordsForBooks(bookIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final pool = snapshot.data ?? words;
        return ListeningPage(
          words: words,
          bookIds: bookIds,
          wordPool: pool.length >= 4 ? pool : words,
          session: session,
          onSessionComplete: onSessionComplete,
          onProgressUpdate: onProgressUpdate,
        );
      },
    );
  }
}

class StudySessionPage extends ConsumerStatefulWidget {
  const StudySessionPage({
    super.key,
    required this.mode,
    this.reviewOnly = false,
    this.overrideWords,
    this.sessionType,
  });

  final StudyMode mode;
  final bool reviewOnly;
  final List<Word>? overrideWords;
  final String? sessionType;

  @override
  ConsumerState<StudySessionPage> createState() => _StudySessionPageState();
}

class _StudySessionPageState extends ConsumerState<StudySessionPage> {
  LearningSession? _session;
  int _initialMasteredCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSession());
  }

  List<int> _bookIdsForSession() {
    if (widget.overrideWords != null) {
      final ids = <int>{};
      for (final word in widget.overrideWords!) {
        ids.addAll(word.bookIds);
      }
      return ids.toList();
    }
    return ref.read(selectedBookIdsProvider);
  }

  Future<void> _startSession() async {
    if (widget.reviewOnly) {
      final books = await ref.read(booksProvider.future);
      _initialMasteredCount = books.fold(
        0,
        (sum, item) => sum + item.masteredWords,
      );
    }

    final bookIds = _bookIdsForSession();
    final sessionType =
        widget.sessionType ??
        (widget.reviewOnly
            ? 'review_${widget.mode.name}'
            : widget.overrideWords != null
            ? 'practice_${widget.mode.name}'
            : widget.mode.name);

    final session = await ref
        .read(sessionRepositoryProvider)
        .startSession(sessionType: sessionType, bookIds: bookIds);

    if (mounted) {
      setState(() => _session = session);
      ref.read(currentStudySessionProvider.notifier).state = session;
    }
  }

  @override
  void dispose() {
    ref.read(currentStudySessionProvider.notifier).state = null;
    super.dispose();
  }

  Future<void> _completeSession() async {
    final session = _session;
    if (session != null) {
      await ref.read(sessionRepositoryProvider).completeSession(session);
    }

    if (!mounted) {
      return;
    }

    invalidateStudyData(ref);

    final settingsRepo = ref.read(settingsRepositoryProvider);
    final settings = await settingsRepo.getSettings();
    final snapshot = await ref.read(achievementsProvider.future);
    final newlyUnlocked = await syncUnlockedAchievements(
      settingsRepository: settingsRepo,
      snapshot: snapshot,
      settings: settings,
    );

    if (newlyUnlocked.isNotEmpty && mounted) {
      ref.invalidate(settingsProvider);
      ref.invalidate(recentAchievementsProvider);
      await showAchievementUnlockDialog(context, newlyUnlocked);
    }

    if (!mounted) {
      return;
    }

    final todayCount = await ref.read(todayStudyCountProvider.future);

    if (!mounted) {
      return;
    }

    final totalWords =
        session?.wordsStudied ?? widget.overrideWords?.length ?? 0;
    final correctCount = session?.wordsCorrect ?? 0;

    if (widget.reviewOnly) {
      final books = await ref.read(booksProvider.future);
      final refreshedSettings = await ref
          .read(settingsRepositoryProvider)
          .getSettings();
      if (!mounted) {
        return;
      }
      final masteredNow = books.fold(
        0,
        (sum, item) => sum + item.masteredWords,
      );
      final action = await showReviewCompleteDialog(
        context,
        totalWords: totalWords,
        correctCount: correctCount,
        masteryGained: masteredNow - _initialMasteredCount,
        currentStreak: refreshedSettings.currentStreak,
      );

      if (!mounted) {
        return;
      }

      if (action == ReviewCompleteAction.restart) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => StudySessionPage(
              mode: widget.mode,
              reviewOnly: widget.reviewOnly,
              overrideWords: widget.overrideWords,
              sessionType: widget.sessionType,
            ),
          ),
        );
        return;
      }

      Navigator.of(context).pop();
      return;
    }

    final action = await showStudyCompleteDialog(
      context,
      totalWords: totalWords,
      correctCount: correctCount,
      sessionType: session?.sessionType,
      todayCount: todayCount,
      dailyGoal: settings.dailyGoal,
      currentStreak: settings.currentStreak,
    );

    if (!mounted) {
      return;
    }

    if (action == StudyCompleteAction.restart) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => StudySessionPage(
            mode: widget.mode,
            reviewOnly: widget.reviewOnly,
            overrideWords: widget.overrideWords,
            sessionType: widget.sessionType,
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIds = ref.watch(selectedBookIdsProvider);

    if (widget.overrideWords != null) {
      return _buildScaffold(
        words: widget.overrideWords!,
        bookIds: _bookIdsForSession(),
        goalReached: false,
      );
    }

    final wordsAsync = widget.reviewOnly
        ? ref.watch(reviewWordsProvider(selectedIds))
        : ref.watch(studyWordsProvider(selectedIds));

    if (!widget.reviewOnly) {
      final remainingAsync = ref.watch(dailyQuotaRemainingProvider);
      final dueCountAsync = ref.watch(dueWordsCountProvider(selectedIds));

      return wordsAsync.when(
        loading: () => _loadingScaffold(),
        error: (error, _) => _errorScaffold(error),
        data: (words) {
          final remaining = remainingAsync.value ?? 0;
          final dueCount = dueCountAsync.value ?? 0;
          final goalReached = words.isEmpty && remaining == 0 && dueCount > 0;

          return _buildScaffold(
            words: words,
            bookIds: selectedIds,
            goalReached: goalReached,
          );
        },
      );
    }

    return wordsAsync.when(
      loading: () => _loadingScaffold(),
      error: (error, _) => _errorScaffold(error),
      data: (words) => _buildScaffold(
        words: words,
        bookIds: selectedIds,
        goalReached: false,
      ),
    );
  }

  Widget _loadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reviewOnly ? '复习 · ${widget.mode.title}' : widget.mode.title,
        ),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _errorScaffold(Object error) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reviewOnly ? '复习 · ${widget.mode.title}' : widget.mode.title,
        ),
      ),
      body: Center(child: Text('加载失败: $error')),
    );
  }

  void _onProgressUpdate() => setState(() {});

  PreferredSizeWidget? _sessionProgressBar(int totalWords) {
    if (totalWords == 0) {
      return null;
    }
    final studied = _session?.wordsStudied ?? 0;
    return PreferredSize(
      preferredSize: const Size.fromHeight(32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: studied / totalWords,
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
            ),
            const SizedBox(width: 10),
            Text('$studied/$totalWords'),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffold({
    required List<Word> words,
    required List<int> bookIds,
    required bool goalReached,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reviewOnly ? '复习 · ${widget.mode.title}' : widget.mode.title,
        ),
        bottom: _sessionProgressBar(words.length),
      ),
      body: words.isEmpty
          ? _EmptyStudyBody(
              reviewOnly: widget.reviewOnly,
              goalReached: goalReached,
            )
          : switch (widget.mode) {
              StudyMode.flashcard => FlashcardPage(
                words: words,
                bookIds: bookIds,
                session: _session,
                onSessionComplete: _completeSession,
                onProgressUpdate: _onProgressUpdate,
              ),
              StudyMode.complete => CompleteStudyPage(
                words: words,
                bookIds: bookIds,
                session: _session,
                onSessionComplete: _completeSession,
                onProgressUpdate: _onProgressUpdate,
              ),
              StudyMode.quiz => _QuizLoader(
                words: words,
                bookIds: bookIds,
                session: _session,
                onSessionComplete: _completeSession,
                onProgressUpdate: _onProgressUpdate,
              ),
              StudyMode.spelling => SpellingPage(
                words: words,
                bookIds: bookIds,
                session: _session,
                onSessionComplete: _completeSession,
                onProgressUpdate: _onProgressUpdate,
              ),
              StudyMode.listening => _ListeningLoader(
                words: words,
                bookIds: bookIds,
                session: _session,
                onSessionComplete: _completeSession,
                onProgressUpdate: _onProgressUpdate,
              ),
            },
    );
  }
}

class _EmptyStudyBody extends StatelessWidget {
  const _EmptyStudyBody({required this.reviewOnly, required this.goalReached});

  final bool reviewOnly;
  final bool goalReached;

  @override
  Widget build(BuildContext context) {
    final message = reviewOnly
        ? '暂无待复习单词，太棒了！'
        : goalReached
        ? '今日学习目标已完成，明天继续加油！'
        : '暂无待学习单词';
    final helper = reviewOnly
        ? '可以回首页查看本周学习记录，或者去收藏和错题本加练。'
        : goalReached
        ? '现在适合回首页看一眼今日进度，或者做一轮复习巩固。'
        : '换一本词书，或在设置里打开加练模式。';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              reviewOnly || goalReached ? Icons.celebration : Icons.menu_book,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              helper,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}
