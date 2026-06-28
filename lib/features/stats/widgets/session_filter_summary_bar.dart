import 'package:flutter/material.dart';

import '../../../utils/session_filter_summary.dart';

class SessionFilterSummaryBar extends StatelessWidget {
  const SessionFilterSummaryBar({
    super.key,
    required this.chips,
    required this.filteredCount,
    required this.totalCount,
    required this.onRemoveChip,
    required this.onClearAll,
    this.onShare,
  });

  final List<ActiveSessionFilterChip> chips;
  final int filteredCount;
  final int totalCount;
  final ValueChanged<SessionFilterChipKind> onRemoveChip;
  final VoidCallback onClearAll;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.filter_list,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '显示 $filteredCount/$totalCount 条',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (onShare != null)
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 20),
                    tooltip: '分享筛选摘要',
                    visualDensity: VisualDensity.compact,
                    onPressed: onShare,
                  ),
                TextButton(
                  onPressed: onClearAll,
                  child: const Text('全部清除'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: chips
                  .map(
                    (chip) => InputChip(
                      label: Text(chip.label),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => onRemoveChip(chip.kind),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}