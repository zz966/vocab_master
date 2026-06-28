import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/review_record.dart';
import '../../models/word.dart';
import '../../models/word_book.dart';
import '../../providers/study_provider.dart';
import '../../providers/word_provider.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/settings_repository.dart';
import '../../utils/study_quality.dart';
import '../../utils/word_enrichment.dart';
import '../../utils/word_share.dart';
import 'widgets/word_learning_card.dart';
import 'widgets/word_review_chart.dart';

class WordDetailPage extends ConsumerStatefulWidget {
  const WordDetailPage({
    super.key,
    required this.wordId,
    this.wordIds,
  });

  final int wordId;
  final List<int>? wordIds;

  @override
  ConsumerState<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends ConsumerState<WordDetailPage> {
  late int _currentWordId;
  bool _loading = true;
  Word? _word;
  List<WordBook> _books = [];
  List<ReviewRecord> _reviewHistory = [];

  @override
  void initState() {
    super.initState();
    _currentWordId = widget.wordId;
    _loadWord(_currentWordId);
  }

  Future<void> _loadWord(int wordId) async {
    setState(() => _loading = true);

    final wordRepo = ref.read(wordRepositoryProvider);
    final bookRepo = ref.read(bookRepositoryProvider);
    final word = await wordRepo.getWord(wordId);

    if (!mounted) {
      return;
    }

    if (word == null) {
      setState(() {
        _loading = false;
        _word = null;
        _books = [];
        _reviewHistory = [];
      });
      return;
    }

    if (word.memoryTips == null || word.structuredExamples == null) {
      final peerWords = (await wordRepo.getWordsForBooks(word.bookIds))
          .map((item) => item.english)
          .toList();
      WordEnrichment.apply(word, peerWords: peerWords);
      await wordRepo.saveWord(word);
    }

    final books = await bookRepo.getBooksForWord(word);
    final reviewHistory = await ref
        .read(settingsRepositoryProvider)
        .getReviewRecordsForWord(word.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
      _word = word;
      _books = books;
      _reviewHistory = reviewHistory;
    });
  }

  List<int> get _navigationIds {
    if (widget.wordIds != null && widget.wordIds!.isNotEmpty) {
      return widget.wordIds!;
    }
    return [_currentWordId];
  }

  int? get _previousWordId {
    final ids = _navigationIds;
    final index = ids.indexOf(_currentWordId);
    if (index <= 0) {
      return null;
    }
    return ids[index - 1];
  }

  int? get _nextWordId {
    final ids = _navigationIds;
    final index = ids.indexOf(_currentWordId);
    if (index == -1 || index >= ids.length - 1) {
      return null;
    }
    return ids[index + 1];
  }

  void _goToWord(int wordId) {
    setState(() => _currentWordId = wordId);
    _loadWord(wordId);
  }

  Future<void> _toggleFavorite(Word word) async {
    final wasFavorite = word.isFavorite;
    await ref.read(studyServiceProvider).toggleFavorite(word);
    invalidateStudyData(ref);
    if (!mounted) {
      return;
    }
    await _loadWord(word.id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(wasFavorite ? '已取消收藏' : '已加入收藏'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final word = _word;

    return Scaffold(
      appBar: AppBar(
        title: Text(word?.english ?? '单词详情'),
        actions: [
          if (word != null) ...[
            IconButton(
              tooltip: '分享单词',
              onPressed: () => shareWord(word, books: _books),
              icon: const Icon(Icons.share_outlined),
            ),
            IconButton(
              onPressed: () => _toggleFavorite(word),
              icon: Icon(
                word.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: word.isFavorite ? Colors.red : null,
              ),
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : word == null
              ? const Center(child: Text('单词不存在'))
              : _WordDetailBody(
                  word: word,
                  books: _books,
                  reviewHistory: _reviewHistory,
                ),
      bottomNavigationBar: _loading || word == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _previousWordId == null
                            ? null
                            : () => _goToWord(_previousWordId!),
                        icon: const Icon(Icons.chevron_left),
                        label: const Text('上一个'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _nextWordId == null
                            ? null
                            : () => _goToWord(_nextWordId!),
                        icon: const Icon(Icons.chevron_right),
                        label: const Text('下一个'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _WordDetailBody extends StatelessWidget {
  const _WordDetailBody({
    required this.word,
    required this.books,
    required this.reviewHistory,
  });

  final Word word;
  final List<WordBook> books;
  final List<ReviewRecord> reviewHistory;

  @override
  Widget build(BuildContext context) {
    final nextReviewLabel = word.nextReview == null
        ? '未安排'
        : DateFormat('yyyy-MM-dd HH:mm').format(word.nextReview!);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        WordLearningCard(word: word),
        const SizedBox(height: 24),
        if (books.isNotEmpty) ...[
          Text(
            '所属单词书',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: books.map((book) => Chip(label: Text(book.title))).toList(),
          ),
          const SizedBox(height: 24),
        ],
        Text('熟悉度', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: word.familiarity / 5,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${word.familiarity} / 5',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoRow(label: '复习次数', value: '${word.reviewCount}'),
        _InfoRow(label: '下次复习', value: nextReviewLabel),
        if (word.inWrongBook)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Chip(
              avatar: const Icon(Icons.bookmark, size: 16),
              label: const Text('在错题本中'),
            ),
          ),
        if (reviewHistory.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            '复习记录',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          WordReviewChart(records: reviewHistory),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                for (final record in reviewHistory.take(10))
                  ListTile(
                    dense: true,
                    title: Text(
                      DateFormat('M/d HH:mm').format(record.reviewedAt),
                    ),
                    trailing: _ReviewQualityChip(record: record),
                  ),
                if (reviewHistory.length > 10)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '共 ${reviewHistory.length} 条记录',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }
}

class _ReviewQualityChip extends StatelessWidget {
  const _ReviewQualityChip({required this.record});

  final ReviewRecord record;

  @override
  Widget build(BuildContext context) {
    final quality = StudyQuality.fromValue(record.quality);
    if (quality == null) {
      return const SizedBox.shrink();
    }
    return Chip(
      label: Text(
        quality.label,
        style: TextStyle(color: quality.color, fontSize: 12),
      ),
      backgroundColor: quality.color.withValues(alpha: 0.12),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}