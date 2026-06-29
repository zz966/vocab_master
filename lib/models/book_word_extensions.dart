import 'book_model.dart';

extension BookWordCompat on BookWord {
  String get english => word;

  set english(String value) => word = value;

  String get chinese => definitionCn;

  set chinese(String value) => definitionCn = value;

  String? get phonetic {
    if (phoneticUk.isNotEmpty) {
      return phoneticUk;
    }
    if (phoneticUs.isNotEmpty) {
      return phoneticUs;
    }
    return null;
  }

  set phonetic(String? value) {
    final trimmed = value?.trim() ?? '';
    phoneticUk = trimmed;
    phoneticUs = trimmed;
  }

  int get familiarity => masteryLevel;

  set familiarity(int value) => masteryLevel = value;

  DateTime? get nextReview => lastReviewTime;

  set nextReview(DateTime? value) => lastReviewTime = value;

  List<WordExample> get structuredExamples {
    if (structuredExamplesRich != null && structuredExamplesRich!.isNotEmpty) {
      return structuredExamplesRich!;
    }
    if (sentenceExamples.isEmpty) {
      return const [];
    }
    return sentenceExamples
        .map(
          (example) => WordExample(
            english: example.en,
            chinese: example.cn,
            partOfSpeech: partOfSpeech.isEmpty ? null : partOfSpeech,
            meaning: definitionCn.isEmpty ? null : definitionCn,
          ),
        )
        .toList();
  }

  set structuredExamples(List<WordExample>? value) {
    structuredExamplesRich = value;
  }

  List<String>? get examples {
    if (legacyExamples != null) {
      return legacyExamples;
    }
    if (structuredExamplesRich != null && structuredExamplesRich!.isNotEmpty) {
      return structuredExamplesRich!
          .map((item) {
            if (item.chinese.isEmpty) {
              return item.english;
            }
            return '${item.english}: ${item.chinese}';
          })
          .toList();
    }
    if (sentenceExamples.isNotEmpty) {
      return sentenceExamples
          .map((item) {
            if (item.cn.isEmpty) {
              return item.en;
            }
            return '${item.en}: ${item.cn}';
          })
          .toList();
    }
    return null;
  }

  set examples(List<String>? value) {
    legacyExamples = value;
  }

  void attachBookId(String bookId) {
    if (!bookIds.contains(bookId)) {
      bookIds = [...bookIds, bookId];
    }
  }
}