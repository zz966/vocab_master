import 'package:flutter/material.dart';

import '../../../models/word.dart';
import 'example_sentence_row.dart';
import 'highlighted_text.dart';

class WordExamplesSection extends StatefulWidget {
  const WordExamplesSection({
    super.key,
    required this.word,
    this.examples,
  });

  final Word word;
  final List<WordExample>? examples;

  @override
  State<WordExamplesSection> createState() => _WordExamplesSectionState();
}

class _WordExamplesSectionState extends State<WordExamplesSection> {
  String? _selectedPartOfSpeech;

  @override
  Widget build(BuildContext context) {
    final examples = widget.examples ?? widget.word.structuredExamples ?? [];
    if (examples.isEmpty) {
      return const SizedBox.shrink();
    }

    final grouped = <String, List<WordExample>>{};
    for (final example in examples) {
      final key = example.partOfSpeech?.trim().isNotEmpty == true
          ? example.partOfSpeech!.trim()
          : '例句';
      grouped.putIfAbsent(key, () => []).add(example);
    }

    final parts = grouped.keys.toList();
    final selected = _selectedPartOfSpeech ?? parts.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('例句', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (parts.length > 1)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: parts.map((part) {
              return ChoiceChip(
                label: Text(part),
                selected: selected == part,
                onSelected: (_) => setState(() => _selectedPartOfSpeech = part),
              );
            }).toList(),
          ),
        if (parts.length > 1) const SizedBox(height: 12),
        ...grouped[selected]!.map(
          (example) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (example.meaning != null &&
                      example.meaning!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        example.meaning!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: HighlightedText(
                          text: example.english,
                          highlight: widget.word.english,
                        ),
                      ),
                      const SizedBox(width: 4),
                      ExampleSentenceRow(
                        example: example.english,
                        showText: false,
                      ),
                    ],
                  ),
                  if (example.chinese.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      example.chinese,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}