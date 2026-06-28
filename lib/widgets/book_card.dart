import 'package:flutter/material.dart';

import '../core/category_labels.dart';
import '../repositories/book_repository.dart';
import '../utils/color_utils.dart';

/// Reusable grid card for a [BookProgress] entry (built-in or custom).
class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.progress,
    this.selected = false,
    this.onTap,
    this.onLongPress,
  });

  final BookProgress progress;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final book = progress.book;
    final color = parseHexColor(book.coverColor);
    final masteryPercent = (progress.masteryRate * 100).round();

    return Card(
      elevation: selected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: selected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color,
                    child: Text(
                      book.title.isNotEmpty ? book.title[0] : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _BookTypeBadge(isCustom: progress.isCustom),
                  if (selected) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  Chip(
                    label: Text(categoryLabel(book.category)),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  Chip(
                    label: Text(categoryDifficulty(book.category)),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    backgroundColor: color.withValues(alpha: 0.15),
                    labelStyle: TextStyle(color: color, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              Text('${progress.totalWords} 词'),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress.masteryRate,
                backgroundColor: color.withValues(alpha: 0.2),
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 4),
              Text(
                '掌握 $masteryPercent%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookTypeBadge extends StatelessWidget {
  const _BookTypeBadge({required this.isCustom});

  final bool isCustom;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isCustom
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isCustom ? '自定义' : '内置',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isCustom
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}