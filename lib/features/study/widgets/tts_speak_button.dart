import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/study_provider.dart';

class TtsSpeakButton extends ConsumerWidget {
  const TtsSpeakButton({
    super.key,
    required this.text,
    this.icon = Icons.volume_up,
    this.iconSize = 22,
    this.tooltip = '发音',
    this.color,
  });

  final String text;
  final IconData icon;
  final double iconSize;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: () => ref.read(ttsServiceProvider).speak(text.trim()),
      icon: Icon(icon, size: iconSize, color: color),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
    );
  }
}