import 'package:flutter/material.dart';

import '../../../models/word.dart';

class CollocationsSection extends StatelessWidget {
  const CollocationsSection({super.key, required this.collocations});

  final List<WordPhrase> collocations;

  @override
  Widget build(BuildContext context) {
    if (collocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('常用词组 / 搭配', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: collocations.map<Widget>((item) {
            return Chip(
              label: Text(item.phrase),
              avatar: const Icon(Icons.link, size: 18),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        ...collocations.take(6).map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.phrase),
                subtitle: Text(item.translation),
              ),
            ),
      ],
    );
  }
}