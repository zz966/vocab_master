import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../../utils/level_utils.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.level,
    required this.accentColor,
    required this.onTap,
    this.starCount = 0,
  });

  final BookLevel level;
  final Color accentColor;
  final int starCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                levelDisplayName(level.index),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${level.wordCount} 个单词',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              _LevelStars(stars: starCount, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelStars extends StatelessWidget {
  const _LevelStars({
    required this.stars,
    required this.color,
  });

  final int stars;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        final filled = index < stars;
        return Padding(
          padding: EdgeInsets.only(right: index == 2 ? 0 : 4),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 22,
            color: filled ? color : Theme.of(context).colorScheme.outlineVariant,
          ),
        );
      }),
    );
  }
}

Color levelAccentColor(String? coverColor) {
  return parseHexColor(coverColor, fallback: const Color(0xFF2196F3));
}