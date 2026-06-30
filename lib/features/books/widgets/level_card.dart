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
    this.studyProgressPercent,
  });

  final BookLevel level;
  final Color accentColor;
  final int starCount;
  final int? studyProgressPercent;
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                levelDisplayName(level.index),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${level.wordCount} 个单词',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (studyProgressPercent != null) ...[
                const SizedBox(height: 8),
                _StudyProgressBadge(
                  percent: studyProgressPercent!,
                  color: accentColor,
                ),
              ],
              const SizedBox(height: 12),
              _LevelStars(stars: starCount, color: accentColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyProgressBadge extends StatelessWidget {
  const _StudyProgressBadge({
    required this.percent,
    required this.color,
  });

  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$percent%',
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
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
      mainAxisAlignment: MainAxisAlignment.center,
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