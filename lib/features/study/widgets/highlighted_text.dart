import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.highlight,
    this.style,
  });

  final String text;
  final String highlight;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final lowerText = text.toLowerCase();
    final lowerHighlight = highlight.toLowerCase().trim();
    final index = lowerHighlight.isEmpty ? -1 : lowerText.indexOf(lowerHighlight);

    if (index == -1) {
      return Text(text, style: style);
    }

    final baseStyle = style ?? Theme.of(context).textTheme.bodyLarge;
    final highlightStyle = baseStyle?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      backgroundColor:
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
    );

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          if (index > 0) TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + lowerHighlight.length),
            style: highlightStyle,
          ),
          if (index + lowerHighlight.length < text.length)
            TextSpan(text: text.substring(index + lowerHighlight.length)),
        ],
      ),
    );
  }
}