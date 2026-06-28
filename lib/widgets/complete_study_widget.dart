import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/study/widgets/add_to_custom_book_sheet.dart';
import '../features/study/widgets/word_learning_card.dart';
import '../utils/word_enrichment.dart';
import '../models/learning_session.dart';
import '../models/word.dart';
import '../providers/settings_provider.dart';
import '../providers/study_provider.dart';
import '../utils/study_quality.dart';
import 'feedback_banner.dart';

/// Full word study UI with memory tips, examples, phrases, confusables,
/// and SM-2 rating buttons.
class CompleteStudyWidget extends ConsumerStatefulWidget {
  const CompleteStudyWidget({
    super.key,
    required this.words,
    required this.bookIds,
    this.session,
    this.onSessionComplete,
    this.onProgressUpdate,
  });

  final List<Word> words;
  final List<int> bookIds;
  final LearningSession? session;
  final Future<void> Function()? onSessionComplete;
  final VoidCallback? onProgressUpdate;

  @override
  ConsumerState<CompleteStudyWidget> createState() =>
      _CompleteStudyWidgetState();
}

class _CompleteStudyWidgetState extends ConsumerState<CompleteStudyWidget> {
  late int _currentIndex;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureEnriched(_currentWord);
      _syncProgress();
      _maybeAutoRead();
    });
  }

  @override
  void dispose() {
    ref.read(studySessionProgressProvider.notifier).state = null;
    super.dispose();
  }

  void _syncProgress() {
    ref
        .read(studySessionProgressProvider.notifier)
        .state = StudySessionProgress(
      currentIndex: _currentIndex,
      totalWords: widget.words.length,
    );
  }

  Word get _currentWord => widget.words[_currentIndex];

  void _ensureEnriched(Word word) {
    if (word.memoryTips != null && word.structuredExamples != null) {
      return;
    }
    WordEnrichment.apply(
      word,
      peerWords: widget.words.map((item) => item.english).toList(),
    );
  }

  Future<void> _maybeAutoRead() async {
    final settings = ref.read(settingsProvider).valueOrNull;
    if (settings?.autoReadEnabled ?? true) {
      await ref.read(ttsServiceProvider).speak(_currentWord.english);
    }
  }

  Future<void> _rate(StudyQuality quality) async {
    if (_isSubmitting) {
      return;
    }
    setState(() => _isSubmitting = true);

    final bookId = widget.bookIds.length == 1 ? widget.bookIds.first : null;

    await ref
        .read(studyServiceProvider)
        .rateWord(
          word: _currentWord,
          quality: quality,
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
      _isSubmitting = false;
    });
    _ensureEnriched(_currentWord);
    _syncProgress();
    await _maybeAutoRead();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return const Center(child: Text('没有可学习的单词'));
    }

    final word = _currentWord;
    final progress = (_currentIndex + 1) / widget.words.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_currentIndex + 1} / ${widget.words.length}'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => showAddToCustomBookSheet(
                          context,
                          ref,
                          _currentWord,
                        ),
                        icon: const Icon(Icons.library_add_outlined),
                        tooltip: '加入自定义书',
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(studyServiceProvider)
                              .toggleWrongBook(_currentWord);
                          invalidateStudyData(ref);
                          if (!context.mounted) {
                            return;
                          }
                          setState(() {});
                          showFeedbackBanner(
                            context,
                            message: _currentWord.inWrongBook
                                ? '已加入错题本'
                                : '已从错题本移除',
                            type: FeedbackType.info,
                          );
                        },
                        icon: Icon(
                          _currentWord.inWrongBook
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
                          color: _currentWord.inWrongBook
                              ? Theme.of(context).colorScheme.tertiary
                              : null,
                        ),
                        tooltip: '错题本',
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(studyServiceProvider)
                              .toggleFavorite(_currentWord);
                          invalidateStudyData(ref);
                          if (!context.mounted) {
                            return;
                          }
                          setState(() {});
                          showFeedbackBanner(
                            context,
                            message: _currentWord.isFavorite
                                ? '已加入收藏夹'
                                : '已取消收藏',
                          );
                        },
                        icon: Icon(
                          _currentWord.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _currentWord.isFavorite ? Colors.red : null,
                        ),
                        tooltip: '收藏',
                      ),
                    ],
                  ),
                ],
              ),
              LinearProgressIndicator(
                value: progress,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [WordLearningCard(word: word)],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Row(
            children: StudyQuality.feedbackValues.map((quality) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : () => _rate(quality),
                    style: FilledButton.styleFrom(
                      backgroundColor: quality.color,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      quality.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
