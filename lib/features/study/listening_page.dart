import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/study_session_progress.dart';
import '../../models/quiz_session_result.dart';
import '../../models/word.dart';
import '../../providers/study_provider.dart';
import '../../utils/auto_read.dart';
import '../../utils/quiz_generator.dart';


class ListeningPage extends ConsumerStatefulWidget {
  const ListeningPage({
    super.key,
    required this.words,
    required this.bookIds,
    required this.wordPool,
    this.progress,
    this.onListeningComplete,
    this.onProgressUpdate,
  });

  final List<Word> words;
  final List<String> bookIds;
  final List<Word> wordPool;
  final StudySessionProgress? progress;
  final Future<void> Function(QuizSessionResult result)? onListeningComplete;
  final VoidCallback? onProgressUpdate;

  @override
  ConsumerState<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends ConsumerState<ListeningPage> {
  static final _shuffleRandom = Random();

  late final List<Word> _quizWords;
  late int _currentIndex;
  late List<String> _currentOptions;
  int _answeredCount = 0;
  int _correctCount = 0;
  final List<QuizWrongAnswer> _wrongAnswers = [];
  String? _selected;
  bool? _isCorrect;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _quizWords = List<Word>.from(widget.words)..shuffle(_shuffleRandom);
    _currentIndex = 0;
    _currentOptions = _buildOptionsForCurrentWord();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  Word get _currentWord => _quizWords[_currentIndex];

  String get _correctAnswer => _currentWord.chinese.trim();

  List<String> _buildOptionsForCurrentWord() {
    final options = QuizGenerator.generateOptions(
      correct: _currentWord,
      pool: widget.wordPool,
      pickEnglish: false,
    );
    assert(
      QuizGenerator.isValidQuizOptions(
        options: options,
        correctAnswer: _correctAnswer,
      ),
    );
    return options;
  }

  Future<void> _speakCurrent() async {
    await autoSpeakWordIfEnabled(ref, _currentWord, force: true);
  }

  Future<void> _selectOption(String option) async {
    if (_selected != null || _isSubmitting) {
      return;
    }

    final correct = QuizGenerator.matchesAnswer(option, _correctAnswer);
    setState(() {
      _selected = option;
      _isCorrect = correct;
      _answeredCount += 1;
      if (correct) {
        _correctCount += 1;
      } else {
        _wrongAnswers.add(
          QuizWrongAnswer(
            word: _currentWord,
            selectedAnswer: option,
            correctAnswer: _correctAnswer,
          ),
        );
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 800));

    setState(() => _isSubmitting = true);

    final bookId =
        widget.bookIds.length == 1 ? widget.bookIds.first : null;

    await ref.read(studyServiceProvider).recordAnswer(
          word: _currentWord,
          isCorrect: correct,
          bookId: bookId,
          progress: widget.progress,
        );

    invalidateStudyData(ref);
    widget.onProgressUpdate?.call();

    if (!mounted) {
      return;
    }

    if (_currentIndex >= _quizWords.length - 1) {
      await widget.onListeningComplete?.call(
        QuizSessionResult(
          totalWords: _quizWords.length,
          correctCount: _correctCount,
          wrongAnswers: List.unmodifiable(_wrongAnswers),
        ),
      );
      return;
    }

    await ref.read(ttsServiceProvider).stop();

    setState(() {
      _currentIndex += 1;
      _selected = null;
      _isCorrect = null;
      _isSubmitting = false;
      _currentOptions = _buildOptionsForCurrentWord();
    });
    await _speakCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final total = _quizWords.length;
    final progress = total == 0 ? 0.0 : _answeredCount / total;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_answeredCount / $total'),
              Text(
                '第 ${_currentIndex + 1} 题',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 32),
          Text(
            '听发音，选择正确的中文释义',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  IconButton(
                    onPressed: _selected == null ? _speakCurrent : null,
                    icon: const Icon(Icons.volume_up_outlined),
                    iconSize: 48,
                    tooltip: '播放发音',
                    color: theme.colorScheme.primary,
                  ),
                  Text(
                    '点击播放',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _currentOptions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final option = _currentOptions[index];
                Color? bgColor;
                if (_selected != null) {
                  if (QuizGenerator.matchesAnswer(option, _correctAnswer)) {
                    bgColor = Colors.green.withValues(alpha: 0.2);
                  } else if (option == _selected) {
                    bgColor = Colors.red.withValues(alpha: 0.2);
                  }
                }

                return Card(
                  color: bgColor,
                  child: ListTile(
                    title: Text(option),
                    trailing: _selected == option
                        ? Icon(
                            _isCorrect! ? Icons.check_circle : Icons.cancel,
                            color: _isCorrect! ? Colors.green : Colors.red,
                          )
                        : null,
                    onTap: _selected == null
                        ? () => _selectOption(option)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}