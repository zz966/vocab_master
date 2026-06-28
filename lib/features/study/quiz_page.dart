import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/learning_session.dart';
import '../../models/word.dart';
import '../../providers/settings_provider.dart';
import '../../providers/study_provider.dart';
import '../../repositories/settings_repository.dart';
import '../../utils/quiz_generator.dart';
import '../../utils/study_quality.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({
    super.key,
    required this.words,
    required this.bookIds,
    required this.wordPool,
    this.session,
    this.onSessionComplete,
    this.onProgressUpdate,
  });

  final List<Word> words;
  final List<int> bookIds;
  final List<Word> wordPool;
  final LearningSession? session;
  final Future<void> Function()? onSessionComplete;
  final VoidCallback? onProgressUpdate;

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  late int _currentIndex;
  late bool _pickEnglish;
  String? _selected;
  bool? _isCorrect;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pickEnglish = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = ref.read(settingsProvider).valueOrNull;
    _pickEnglish = settings?.quizPickEnglish ?? true;
  }

  Word get _currentWord => widget.words[_currentIndex];

  String get _correctAnswer =>
      _pickEnglish ? _currentWord.english : _currentWord.chinese;

  List<String> get _options => QuizGenerator.generateOptions(
        correct: _currentWord,
        pool: widget.wordPool,
        pickEnglish: _pickEnglish,
      );

  Future<void> _toggleDirection() async {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings == null) {
      setState(() => _pickEnglish = !_pickEnglish);
      return;
    }
    settings.quizPickEnglish = !_pickEnglish;
    await ref.read(settingsRepositoryProvider).saveSettings(settings);
    ref.invalidate(settingsProvider);
    setState(() => _pickEnglish = !_pickEnglish);
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

    setState(() {
      _currentIndex += 1;
      _selected = null;
      _isCorrect = null;
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = _currentWord;
    final progress = (_currentIndex + 1) / widget.words.length;
    final prompt = _pickEnglish ? word.chinese : word.english;
    final promptHint =
        _pickEnglish ? '选择正确的英文单词' : '选择正确的中文释义';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_currentIndex + 1} / ${widget.words.length}'),
              TextButton.icon(
                onPressed: _selected == null ? _toggleDirection : null,
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: Text(_pickEnglish ? '中→英' : '英→中'),
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
            promptHint,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                prompt,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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