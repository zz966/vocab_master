import 'package:flutter/material.dart';

import '../../../models/word.dart';
import 'collocations_section.dart';
import 'confusable_words_section.dart';
import 'memory_tips_section.dart';
import 'word_examples_section.dart';
import 'word_header_section.dart';
import 'word_image_placeholder.dart';

class WordLearningCard extends StatelessWidget {
  const WordLearningCard({
    super.key,
    required this.word,
    this.showImage = true,
    this.showMemoryTips = true,
    this.showExamples = true,
    this.showCollocations = true,
    this.showConfusableWords = true,
    this.compact = false,
  });

  final Word word;
  final bool showImage;
  final bool showMemoryTips;
  final bool showExamples;
  final bool showCollocations;
  final bool showConfusableWords;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showImage) ...[
          WordImagePlaceholder(
            word: word,
            height: compact ? 140 : 200,
          ),
          const SizedBox(height: 16),
        ],
        WordHeaderSection(word: word),
        if (showMemoryTips && word.memoryTips != null) ...[
          const SizedBox(height: 16),
          MemoryTipsSection(tips: word.memoryTips!),
        ],
        if (showExamples) ...[
          const SizedBox(height: 20),
          WordExamplesSection(word: word),
        ],
        if (showCollocations && word.collocations != null) ...[
          const SizedBox(height: 20),
          CollocationsSection(collocations: word.collocations!),
        ],
        if (showConfusableWords && word.confusableWords != null) ...[
          const SizedBox(height: 20),
          ConfusableWordsSection(items: word.confusableWords!),
        ],
      ],
    );
  }
}