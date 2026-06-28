import 'package:share_plus/share_plus.dart';

import '../repositories/book_repository.dart';

String formatBookStatsShareText(BookProgress progress) {
  final book = progress.book;
  final masteryPercent = (progress.masteryRate * 100).round();

  return [
    '📖 VocabMaster 单词书统计',
    book.title,
    '掌握 $masteryPercent%',
    '已学 ${progress.learnedWords}/${progress.totalWords} 词',
    '掌握 ${progress.masteredWords} 词',
  ].join(' · ');
}

Future<void> shareBookStats(BookProgress progress) async {
  final text = formatBookStatsShareText(progress);
  await Share.share(text, subject: 'VocabMaster · ${progress.book.title}');
}