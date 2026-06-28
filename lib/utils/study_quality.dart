import 'package:flutter/material.dart';

enum StudyQuality {
  again(0, '忘了', Colors.red),
  hard(1, '模糊', Colors.orange),
  good(2, '记住了', Colors.green),
  easy(3, '太简单', Colors.blue);

  const StudyQuality(this.value, this.label, this.color);

  final int value;
  final String label;
  final Color color;

  static const feedbackValues = [
    StudyQuality.again,
    StudyQuality.hard,
    StudyQuality.good,
  ];

  static StudyQuality? fromValue(int value) {
    for (final quality in StudyQuality.values) {
      if (quality.value == value) {
        return quality;
      }
    }
    return null;
  }
}
