import 'package:isar/isar.dart';

part 'word.g.dart';

@embedded
class WordExample {
  String english = '';
  String chinese = '';
  String? partOfSpeech;
  String? meaning;
}

@embedded
class WordPhrase {
  String phrase = '';
  String translation = '';
}

@embedded
class ConfusableWord {
  String word = '';
  String explanation = '';
  String? exampleEnglish;
  String? exampleChinese;
}

@embedded
class MemoryTips {
  String? etymology;
  String? mnemonic;
  String? association;
}

@embedded
class WordDefinition {
  String partOfSpeech = '';
  String meaning = '';
}

@collection
class Word {
  Id id = Isar.autoIncrement;

  late String english;
  late String chinese;
  String? phonetic;
  List<String>? examples;
  String? partOfSpeech;

  String? imageUrl;
  MemoryTips? memoryTips;
  List<WordDefinition>? definitions;
  List<WordExample>? structuredExamples;
  List<WordPhrase>? collocations;
  List<ConfusableWord>? confusableWords;

  late List<int> bookIds;

  int familiarity = 0;
  DateTime? nextReview;
  int reviewCount = 0;
  int correctStreak = 0;
  double easeFactor = 2.5;
  double sm2Interval = 0;
  bool isFavorite = false;
  bool inWrongBook = false;
}