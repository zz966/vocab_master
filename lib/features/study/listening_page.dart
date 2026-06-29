import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/learning_session.dart';
import '../../models/word.dart';
import '../../providers/study_provider.dart';
import '../../utils/quiz_generator.dart';
import '../../utils/study_quality.dart';

class ListeningPage extends ConsumerStatefulWidget {
  const ListeningPage({
    super.key,
    required this.words,
    required this.bookIds,
    required this.wordPool,
    this.session,
    this.onSessionComplete,
    this.onProgressUpdate,
  });

  final List<Word> words;
  final List<String> bookIds;
  final List<Word> wordPool;
  final LearningSession? session;
  final Future<void> Function()? onSessionComplete;
  final VoidCallback? onProgressUpdate;

  @override
  ConsumerState<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends ConsumerState<ListeningPage> {
  late int _currentIndex;
  String? _selected;
  bool? _isCorrect;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  Word get _currentWord => widget.words[_currentIndex];

  String get _correctAnswer => _currentWord.chinese;

  List<String> get _options => QuizGenerator.generateOptions(
        correct: _currentWord,
        pool: widget.wordPool,
        pickEnglish: false,
      );

  Future<void> _speakCurrent() async {
    await ref.read(ttsServiceProvider).speak(_currentWord.english);
  }

  Future<void> _selectOption(String option) async {
    if (_selected != null || _isSubmitting) {
      return;
    }

    final correct = option == _correctAnswer;
    setState(() {
      _selected = option;
      _isCorrect = correct;
    });

    await Future<void>.delayed(const Duration(milliseconds: 800));

    setState(() => _isSubmitting = true);

    final bookId =
        widget.bookIds.length == 1 ? widget.bookIds.first : null;

    await ref.read(studyServiceProvider).rateWord(
          word: _currentWord,
          quality: correct ? StudyQuality.good : StudyQuality.again,
          bookId: bookId,
          session: widget.session,
        );

    invalidateStudyData(ref);
    widget.onProgressUpdate?.call();

    if (!mounted) {
      return;
    }

    if (_currentIndex >= widget.words.length - 1) {
      await widget.onSessionComplete?.call();
      return;
    }

    await ref.read(ttsServiceProvider).stop();

    setState(() {
      _currentIndex += 1;
      _selected = null;
      _isCorrect = null;
      _isSubmitting = false;
    });
    await _speakCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final word = _currentWord;
    final progress = (_currentIndex + 1) / widget.words.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${_currentIndex + 1} / ${widget.words.length}'),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 32),
          Text(
            '听发音，选择正确的中文释义',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            child: InkWell(
              onTap: _selected == null ? _speakCurrent : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.hearing,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '点击重听',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    if (word.phonetic != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        word.phonetic!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final option = _options[index];
                Color? bgColor;
                if (_selected != null) {
                  if (option == _correctAnswer) {
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