class BatchWordLine {
  const BatchWordLine({
    required this.english,
    required this.chinese,
  });

  final String english;
  final String chinese;
}

List<BatchWordLine> parseBatchWordLines(String text) {
  final lines = <BatchWordLine>[];
  for (final raw in text.split('\n')) {
    final line = raw.trim();
    if (line.isEmpty) {
      continue;
    }

    String? english;
    String? chinese;

    if (line.contains('\t')) {
      final parts = line.split('\t');
      if (parts.length >= 2) {
        english = parts[0].trim();
        chinese = parts[1].trim();
      }
    } else if (line.contains(',')) {
      final commaIndex = line.indexOf(',');
      english = line.substring(0, commaIndex).trim();
      chinese = line.substring(commaIndex + 1).trim();
    } else if (line.contains(' - ')) {
      final parts = line.split(' - ');
      if (parts.length >= 2) {
        english = parts[0].trim();
        chinese = parts[1].trim();
      }
    }

    if (english != null &&
        chinese != null &&
        english.isNotEmpty &&
        chinese.isNotEmpty) {
      lines.add(BatchWordLine(english: english, chinese: chinese));
    }
  }
  return lines;
}