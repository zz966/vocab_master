import '../models/word.dart';
import 'book_export.dart';
import 'word_enrichment.dart';

class WordFactory {
  WordFactory._();

  static Word fromImport(
    WordImportData data, {
    required String bookId,
    required int wordIndex,
    List<String>? peerWords,
  }) {
    final word = BookWord(
      id: '${bookId}_$wordIndex',
      word: data.english.trim(),
      definitionCn: data.chinese.trim(),
      phoneticUk: data.phonetic?.trim() ?? '',
      phoneticUs: data.phonetic?.trim() ?? '',
      partOfSpeech: data.partOfSpeech?.trim() ?? '',
      legacyExamples: data.examples,
      imageUrl: data.imageUrl,
      definitions: data.definitions
          ?.map(
            (item) => WordDefinition(
              partOfSpeech: item.partOfSpeech,
              meaning: item.meaning,
            ),
          )
          .toList(),
      structuredExamplesRich: data.structuredExamples
          ?.map(
            (item) => WordExample(
              english: item.english,
              chinese: item.chinese,
              partOfSpeech: item.partOfSpeech,
              meaning: item.meaning,
            ),
          )
          .toList(),
      collocations: data.collocations
          ?.map(
            (item) => WordPhrase(
              phrase: item.phrase,
              translation: item.translation,
            ),
          )
          .toList(),
      memoryTips: data.memoryTips == null
          ? null
          : MemoryTips(
              etymology: data.memoryTips!.etymology,
              mnemonic: data.memoryTips!.mnemonic,
              association: data.memoryTips!.association,
            ),
      bookIds: [bookId],
    );

    WordEnrichment.apply(word, peerWords: peerWords);
    return word;
  }
}