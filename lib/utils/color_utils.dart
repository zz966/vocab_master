import 'package:flutter/material.dart';

Color parseHexColor(String? hex, {Color fallback = Colors.indigo}) {
  if (hex == null || hex.isEmpty) {
    return fallback;
  }
  final value = hex.replaceFirst('#', '');
  if (value.length != 6) {
    return fallback;
  }
  return Color(int.parse('FF$value', radix: 16));
}