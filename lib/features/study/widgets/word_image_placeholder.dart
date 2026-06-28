import 'package:flutter/material.dart';

import '../../../models/word.dart';

class WordImagePlaceholder extends StatelessWidget {
  const WordImagePlaceholder({
    super.key,
    required this.word,
    this.height = 180,
  });

  final Word word;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = _colorForWord(word.english);
    final label = word.english.isNotEmpty
        ? word.english[0].toUpperCase()
        : '?';

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                Color.alphaBlend(
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
                  color,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 56,
                color: Colors.white.withValues(alpha: 0.35),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      '联想图片',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _colorForWord(String english) {
    final hash = english.toLowerCase().codeUnits.fold<int>(
          0,
          (value, code) => value + code,
        );
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1, hue, 0.45, 0.48).toColor();
  }
}