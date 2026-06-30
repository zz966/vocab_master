import 'package:flutter/material.dart';

import '../../../utils/level_utils.dart';
import 'level_card.dart';

class LevelGrid extends StatelessWidget {
  const LevelGrid({
    super.key,
    required this.levels,
    required this.levelStars,
    required this.accentColor,
    required this.onRefresh,
    required this.onLevelTap,
    this.levelStudyProgress = const {},
  });

  final List<BookLevel> levels;
  final Map<int, int> levelStars;
  final Map<int, int> levelStudyProgress;
  final Color accentColor;
  final Future<void> Function() onRefresh;
  final ValueChanged<BookLevel> onLevelTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.92,
        ),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          final level = levels[index];
          return LevelCard(
            level: level,
            starCount: levelStars[level.index] ?? 0,
            studyProgressPercent: levelStudyProgress[level.index],
            accentColor: accentColor,
            onTap: () => onLevelTap(level),
          );
        },
      ),
    );
  }
}