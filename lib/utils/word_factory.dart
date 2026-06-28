import '../models/word.dart';
import 'book_export.dart';
import 'word_enrichment.dart';

class WordFactory {
  WordFactory._();

  static Word fromImport(
    WordImportData data, {
    required List<int> bookIds,
    List<String>? peerWords,
  }) {
    final word = Word()
      ..english = data.english.trim()
      ..chinese = data.chinese.trim()
      ..phonetic = data.phonetic?.trim()
      ..partOfSpeech = data.partOfSpeech?.trim()
      ..examples = data.examples
      ..definitions = data.definitions
          ?.map(
            (item) => WordDefinition()
              ..partOfSpeech = item.partOfSpeech
              ..meaning = item.meaning,
          )
          .toList()
      ..structuredExamples = data.structuredExamples
          ?.map(
            (item) => WordExample()
              ..english = item.english
              ..chinese = item.chinese
              ..partOfSpeech = item.partOfSpeech
              ..meaning = item.meaning,
          )
          .toList()
      ..collocations = data.collocations
          ?.map(
            (item) => WordPhrase()
              ..phrase = item.phrase
              ..translation = item.translation,
          )
          .toList()
      ..memoryTips = data.memoryTips == null
          ? null
          : (MemoryTips()
            ..etymology = data.memoryTips!.etymology
            ..mnemonic = data.memoryTips!.mnemonic
            ..association = data.memoryTips!.association)
      ..bookIds = bookIds;

    WordEnrichment.apply(word, peerWords: peerWords);
    return word;
  }
}