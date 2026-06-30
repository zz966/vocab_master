import 'package:flutter/material.dart';

enum StudyQuality {
  again(0, '答错', Colors.red),
  good(2, '答对', Colors.green);

  const StudyQuality(this.value, this.label, this.color);

  final int value;
  final String label;
  final Color color;

  static StudyQuality? fromValue(int value) {
    if (value >= good.value) {
      return good;
    }
    if (value == again.value) {
      return again;
    }
    return null;
  }
}