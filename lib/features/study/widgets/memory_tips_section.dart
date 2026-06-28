import 'package:flutter/material.dart';

import '../../../models/word.dart';

class MemoryTipsSection extends StatelessWidget {
  const MemoryTipsSection({super.key, required this.tips});

  final MemoryTips tips;

  @override
  Widget build(BuildContext context) {
    final items = <_TipItem>[
      if (tips.etymology != null && tips.etymology!.trim().isNotEmpty)
        _TipItem(title: '词根词缀', body: tips.etymology!),
      if (tips.mnemonic != null && tips.mnemonic!.trim().isNotEmpty)
        _TipItem(title: '谐音记忆', body: tips.mnemonic!),
      if (tips.association != null && tips.association!.trim().isNotEmpty)
        _TipItem(title: '联想技巧', body: tips.association!),
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('记忆方法提示'),
        subtitle: const Text('词根词缀、谐音与联想'),
        children: [
          for (final item in items)
            ListTile(
              title: Text(item.title),
              subtitle: Text(item.body),
            ),
        ],
      ),
    );
  }
}

class _TipItem {
  const _TipItem({required this.title, required this.body});

  final String title;
  final String body;
}