import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../repositories/book_repository.dart';
import '../../../utils/color_utils.dart';

/// Horizontal list row for a vocabulary book on [BooksPage].
class BookListItem extends StatelessWidget {
  const BookListItem({
    super.key,
    required this.progress,
    this.onTap,
  });

  final BookProgress progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final book = progress.book;
    final color = parseHexColor(book.coverColor);
    final progressPercent = (progress.learnedRate * 100).round();
    final wordCount = NumberFormat('#,###').format(progress.totalWords);
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BookCover(
              title: book.title,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$wordCount 词',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.learnedRate,
                      minHeight: 6,
                      backgroundColor: color.withValues(alpha: 0.15),
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$progressPercent% 已完成',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({
    required this.title,
    required this.color,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final initial = title.isNotEmpty ? title[0] : '?';

    return Container(
      width: 72,
      height: 96,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 8,
            bottom: 8,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(2),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}