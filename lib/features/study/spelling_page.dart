import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/study_session_progress.dart';
import '../../models/quiz_session_result.dart';
import '../../models/word.dart';
import '../../providers/study_provider.dart';
import '../../utils/auto_read.dart';


class SpellingPage extends ConsumerStatefulWidget {
  const SpellingPage({
    super.key,
    required this.words,
    required this.bookIds,
    this.progress,
    this.onSpellingComplete,
    this.onProgressUpdate,
  });

  final List<Word> words;
  final List<String> bookIds;
  final StudySessionProgress? progress;
  final Future<void> Function(QuizSessionResult result)? onSpellingComplete;
  final VoidCallback? onProgressUpdate;

  @override
  ConsumerState<SpellingPage> createState() => _SpellingPageState();
}

class _SpellingPageState extends ConsumerState<SpellingPage> {
  static final _shuffleRandom = Random();

  late final List<Word> _quizWords;
  late int _currentIndex;
  final _controller = TextEditingController();
  int _answeredCount = 0;
  int _correctCount = 0;
  final List<QuizWrongAnswer> _wrongAnswers = [];
  bool? _isCorrect;
  bool _isSubmitting = false;
  bool _hintShown = false;

  @override
  void initState() {
    super.initState();
    _quizWords = List<Word>.from(widget.words)..shuffle(_shuffleRandom);
    _currentIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoSpeakCurrent());
  }

  Future<void> _autoSpeakCurrent() async {
    await autoSpeakWordIfEnabled(ref, _currentWord);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Word get _currentWord => _quizWords[_currentIndex];

  void _showHint() {
    if (_isCorrect != null) {
      return;
    }
    final word = _currentWord.english;
    if (word.isEmpty) {
      return;
    }
    setState(() {
      _hintShown = true;
      _controller.text = word[0];
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting || _isCorrect != null) {
      return;
    }

    final input = _controller.text.trim();
    final normalizedInput = input.toLowerCase();
    final normalizedAnswer = _currentWord.english.trim().toLowerCase();
    final correct = normalizedInput == normalizedAnswer;

    setState(() {
      _isCorrect = correct;
      _answeredCount += 1;
      if (correct) {
        _correctCount += 1;
      } else {
        _wrongAnswers.add(
          QuizWrongAnswer(
            word: _currentWord,
            selectedAnswer: input.isEmpty ? '（未填写）' : input,
            correctAnswer: _currentWord.english.trim(),
          ),
        );
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 900));

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
      await widget.onSpellingComplete?.call(
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
      _controller.clear();
      _isCorrect = null;
      _isSubmitting = false;
      _hintShown = false;
    });
    await _autoSpeakCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final word = _currentWord;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '根据释义拼写英文单词',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _isCorrect == null ? _showHint : null,
                icon: const Icon(Icons.lightbulb_outline, size: 18),
                label: const Text('提示'),
              ),
            ],
          ),
          if (_hintShown && _isCorrect == null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '首字母：${_currentWord.english[0].toUpperCase()}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(
                    word.chinese,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (word.partOfSpeech.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      word.partOfSpeech,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            enabled: _isCorrect == null,
            decoration: InputDecoration(
              labelText: '输入英文',
              border: const OutlineInputBorder(),
              errorText: _isCorrect == false ? '正确答案: ${word.english}' : null,
              suffixIcon: _isCorrect == true
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _isCorrect == null ? _submit : null,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}