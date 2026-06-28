import 'package:share_plus/share_plus.dart';

import '../models/word.dart';
import '../models/word_book.dart';

String formatWordShareText(Word word, {List<WordBook>? books}) {
  final parts = <String>[
    '📚 VocabMaster 单词',
    word.english,
    word.chinese,
  ];

  if (word.phonetic != null && word.phonetic!.isNotEmpty) {
    parts.add(word.phonetic!);
  }

  if (word.partOfSpeech != null && word.partOfSpeech!.isNotEmpty) {
    parts.add(word.partOfSpeech!);
  }

  if (word.examples != null && word.examples!.isNotEmpty) {
    parts.add('例句: ${word.examples!.first}');
  }

  if (books != null && books.isNotEmpty) {
    parts.add('来自 ${books.map((book) => book.title).join('、')}');
  }

  return parts.join(' · ');
}

Future<void> shareWord(Word word, {List<WordBook>? books}) async {
  final text = formatWordShareText(word, books: books);
  await Share.share(text, subject: 'VocabMaster · ${word.english}');
}