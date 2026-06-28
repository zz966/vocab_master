import 'package:flutter/material.dart';

enum FeedbackType { success, error, info }

void showFeedbackBanner(
  BuildContext context, {
  required String message,
  FeedbackType type = FeedbackType.success,
}) {
  final scheme = Theme.of(context).colorScheme;
  final (icon, color) = switch (type) {
    FeedbackType.success => (Icons.check_circle_rounded, scheme.primary),
    FeedbackType.error => (Icons.error_outline_rounded, scheme.error),
    FeedbackType.info => (Icons.info_outline_rounded, scheme.secondary),
  };

  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      duration: const Duration(milliseconds: 2200),
      content: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: 0.85 + scale * 0.15,
            child: child,
          );
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}