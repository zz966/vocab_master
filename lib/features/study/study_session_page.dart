import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/study_mode.dart';
import '../../models/learning_session.dart';
import '../../models/quiz_session_result.dart';
import '../../models/word.dart';
import '../../providers/repository_providers.dart';
import '../../providers/study_provider.dart';
import '../../utils/level_challenge.dart';
import 'listening_page.dart';
import 'quiz_page.dart';
import 'spelling_page.dart';
import 'widgets/quiz_complete_dialog.dart';

class StudySessionPage extends ConsumerStatefulWidget {
  const StudySessionPage({
    super.key,
    required this.mode,
    required this.words,
    required this.sessionType,
  });

  final StudyMode mode;
  final List<Word> words;
  final String sessionType;

  @override
  ConsumerState<StudySessionPage> createState() => _StudySessionPageState();
}

class _StudySessionPageState extends ConsumerState<StudySessionPage> {
  LearningSession? _session;
  bool _challengeStarEarned = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSession());
  }

  List<String> _bookIdsForSession() {
    final ids = <String>{};
    for (final word in widget.words) {
      ids.addAll(word.bookIds);
    }
    return ids.toList();
  }

  Future<void> _startSession() async {
    final session = await ref.read(sessionRepositoryProvider).startSession(
          sessionType: widget.sessionType,
          bookIds: _bookIdsForSession(),
        );

    if (mounted) {
      setState(() => _session = session);
      ref.read(currentStudySessionProvider.notifier).set(session);
    }
  }

  @override
  void dispose() {
    ref.read(currentStudySessionProvider.notifier).set(null);
    super.dispose();
  }

  Future<void> _completeQuizSession(QuizSessionResult quizResult) async {
    await _finishSession(quizResult: quizResult);
  }

  Future<void> _finishSession({required QuizSessionResult quizResult}) async {
    final session = _session;
    if (session != null) {
      await ref.read(sessionRepositoryProvider).completeSession(session);
    }

    if (!mounted) {
      return;
    }

    _challengeStarEarned = await _awardLevelChallengeStarIfPerfect();

    if (!mounted) {
      return;
    }

    invalidateStudyData(ref);

    if (!mounted) {
      return;
    }

    final action = await showQuizCompleteDialog(
      context,
      result: quizResult,
    );

    if (!mounted) {
      return;
    }

    if (action == QuizCompleteAction.restart) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => StudySessionPage(
            mode: widget.mode,
            words: widget.words,
            sessionType: widget.sessionType,
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop(_challengeStarEarned);
  }

  Future<bool> _awardLevelChallengeStarIfPerfect() async {
    final challenge = parseLevelChallengeSessionType(
      _session?.sessionType ?? widget.sessionType,
    );
    if (challenge == null || widget.words.isEmpty) {
      return false;
    }

    final session = _session;
    if (!isPerfectChallengeScore(
      totalWords: widget.words.length,
      wordsStudied: session?.wordsStudied ?? 0,
      wordsCorrect: session?.wordsCorrect ?? 0,
    )) {
      return false;
    }

    return ref.read(levelChallengeRepositoryProvider).recordPerfectCompletion(
          bookId: challenge.bookId,
          levelIndex: challenge.levelIndex,
          modeName: challenge.mode.name,
        );
  }

  void _onProgressUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final words = widget.words;
    final bookIds = _bookIdsForSession();

    return Scaffold(
      appBar: AppBar(title: Text(widget.mode.title)),
      body: switch (widget.mode) {
        StudyMode.quiz => QuizPage(
            words: words,
            bookIds: bookIds,
            wordPool: words,
            session: _session,
            onQuizComplete: _completeQuizSession,
            onProgressUpdate: _onProgressUpdate,
          ),
        StudyMode.spelling => SpellingPage(
            words: words,
            bookIds: bookIds,
            session: _session,
            onSpellingComplete: _completeQuizSession,
            onProgressUpdate: _onProgressUpdate,
          ),
        StudyMode.listening => ListeningPage(
            words: words,
            bookIds: bookIds,
            wordPool: words,
            session: _session,
            onListeningComplete: _completeQuizSession,
            onProgressUpdate: _onProgressUpdate,
          ),
      },
    );
  }
}