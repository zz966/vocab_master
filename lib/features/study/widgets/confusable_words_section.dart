import 'package:flutter/material.dart';

import '../../../models/word.dart';
import 'highlighted_text.dart';

class ConfusableWordsSection extends StatelessWidget {
  const ConfusableWordsSection({super.key, required this.items});

  final List<ConfusableWord> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('易混淆词', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.word,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(item.explanation),
                  if (item.exampleEnglish != null &&
                      item.exampleEnglish!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    HighlightedText(
                      text: item.exampleEnglish!,
                      highlight: item.word,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                  if (item.exampleChinese != null &&
                      item.exampleChinese!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(item.exampleChinese!),
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