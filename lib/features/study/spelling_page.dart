import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/learning_session.dart';
import '../../models/word.dart';
import '../../providers/study_provider.dart';
import '../../utils/study_quality.dart';

class SpellingPage extends ConsumerStatefulWidget {
  const SpellingPage({
    super.key,
    required this.words,
    required this.bookIds,
    this.session,
    this.onSessionComplete,
    this.onProgressUpdate,
  });

  final List<Word> words;
  final List<String> bookIds;
  final LearningSession? session;
  final Future<void> Function()? onSessionComplete;
  final VoidCallback? onProgressUpdate;

  @override
  ConsumerState<SpellingPage> createState() => _SpellingPageState();
}

class _SpellingPageState extends ConsumerState<SpellingPage> {
  late int _currentIndex;
  final _controller = TextEditingController();
  bool? _isCorrect;
  bool _isSubmitting = false;
  bool _hintShown = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Word get _currentWord => widget.words[_currentIndex];

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

    final input = _controller.text.trim().toLowerCase();
    final correct =
        input == _currentWord.english.trim().toLowerCase();

    setState(() => _isCorrect = correct);

    await Future<void>.delayed(const Duration(milliseconds: 900));

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
      _controller.clear();
      _isCorrect = null;
      _isSubmitting = false;
      _hintShown = false;
    });
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '根据释义拼写英文单词',
                style: Theme.of(context).textTheme.titleMedium,
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (word.partOfSpeech != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      word.partOfSpeech!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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