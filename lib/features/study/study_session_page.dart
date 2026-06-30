import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/study_mode.dart';
import '../../models/quiz_session_result.dart';
import '../../models/study_session_progress.dart';
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
  late final StudySessionProgress _progress;
  bool _challengeStarEarned = false;

  @override
  void initState() {
    super.initState();
    _progress = StudySessionProgress(sessionType: widget.sessionType);
  }

  List<String> _bookIdsForSession() {
    final ids = <String>{};
    for (final word in widget.words) {
      ids.addAll(word.bookIds);
    }
    return ids.toList();
  }

  Future<void> _completeQuizSession(QuizSessionResult quizResult) async {
    await _finishSession(quizResult: quizResult);
  }

  Future<void> _finishSession({required QuizSessionResult quizResult}) async {
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
    final challenge = parseLevelChallengeSessionType(_progress.sessionType);
    if (challenge == null || widget.words.isEmpty) {
      return false;
    }

    if (!isPerfectChallengeScore(
      totalWords: widget.words.length,
      wordsStudied: _progress.wordsStudied,
      wordsCorrect: _progress.wordsCorrect,
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
            progress: _progress,
            onQuizComplete: _completeQuizSession,
            onProgressUpdate: _onProgressUpdate,
          ),
        StudyMode.spelling => SpellingPage(
            words: words,
            bookIds: bookIds,
            progress: _progress,
            onSpellingComplete: _completeQuizSession,
            onProgressUpdate: _onProgressUpdate,
          ),
        StudyMode.listening => ListeningPage(
            words: words,
            bookIds: bookIds,
            wordPool: words,
            progress: _progress,
            onListeningComplete: _completeQuizSession,
            onProgressUpdate: _onProgressUpdate,
          ),
      },
    );
  }
}