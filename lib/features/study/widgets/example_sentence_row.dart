import 'package:flutter/material.dart';

import 'tts_speak_button.dart';

class ExampleSentenceRow extends StatelessWidget {
  const ExampleSentenceRow({
    super.key,
    required this.example,
    this.style,
    this.compact = false,
    this.showText = true,
  });

  final String example;
  final TextStyle? style;
  final bool compact;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    if (example.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    if (compact || !showText) {
      return TtsSpeakButton(
        text: example,
        tooltip: '朗读例句',
        icon: Icons.volume_up,
        iconSize: 22,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              example,
              style: style ?? Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TtsSpeakButton(
            text: example,
            tooltip: '朗读例句',
            icon: Icons.volume_up,
            iconSize: 22,
          ),
        ],
      ),
    );
  }
}