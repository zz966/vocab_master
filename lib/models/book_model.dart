import 'package:hive_flutter/hive_flutter.dart';

part 'book_model.g.dart';

@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  String bookId;

  @HiveField(1)
  String bookName;

  @HiveField(2)
  String description;

  @HiveField(3)
  int totalWords;

  @HiveField(4)
  String cover;

  @HiveField(5)
  String category;

  @HiveField(6)
  String difficulty;

  @HiveField(7)
  List<BookWord> words;

  @HiveField(8)
  String coverColor;

  @HiveField(9)
  DateTime createdAt;

  Book({
    required this.bookId,
    required this.bookName,
    this.description = '',
    this.totalWords = 0,
    this.cover = '',
    this.category = '',
    this.difficulty = '',
    List<BookWord>? words,
    this.coverColor = '#607D8B',
    DateTime? createdAt,
  })  : words = words ?? [],
        createdAt = createdAt ?? DateTime.now();

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        bookId: json['bookId'] as String,
        bookName: json['bookName'] as String,
        description: json['description'] as String? ?? '',
        totalWords: json['totalWords'] as int? ?? 0,
        cover: json['cover'] as String? ?? '',
        category: json['category'] as String? ?? '',
        difficulty: json['difficulty'] as String? ?? '',
        coverColor: json['coverColor'] as String? ?? '#607D8B',
        words: (json['words'] as List<dynamic>? ?? const [])
            .map((word) => BookWord.fromJson(word as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'bookId': bookId,
        'bookName': bookName,
        'description': description,
        'totalWords': totalWords,
        'cover': cover,
        'category': category,
        'difficulty': difficulty,
        'coverColor': coverColor,
        'words': words.map((word) => word.toJson()).toList(),
      };

  String get id => bookId;

  String get title => bookName;

  set title(String value) => bookName = value;
}

@HiveType(typeId: 1)
class BookWord {
  @HiveField(0)
  String id;

  @HiveField(1)
  String word;

  @HiveField(2)
  String phoneticUk;

  @HiveField(3)
  String phoneticUs;

  @HiveField(4)
  String partOfSpeech;

  @HiveField(5)
  String definitionCn;

  @HiveField(6)
  List<BookWordExample> sentenceExamples;

  @HiveField(7)
  List<String> synonyms;

  @HiveField(8)
  String root;

  @HiveField(9)
  int masteryLevel;

  @HiveField(10)
  DateTime? lastReviewTime;

  @HiveField(11)
  int reviewCount;

  @HiveField(12)
  int correctStreak;

  @HiveField(17)
  String? imageUrl;

  @HiveField(18)
  List<WordDefinition>? definitions;

  @HiveField(19)
  List<WordExample>? structuredExamplesRich;

  @HiveField(20)
  List<WordPhrase>? collocations;

  @HiveField(21)
  List<ConfusableWord>? confusableWords;

  @HiveField(22)
  MemoryTips? memoryTips;

  @HiveField(23)
  List<String> bookIds;

  @HiveField(24)
  List<String>? legacyExamples;

  @HiveField(25)
  List<WordDefinition>? englishDefinitions;

  @HiveField(26)
  List<ConfusableWord>? synonymDetails;

  BookWord({
    required this.id,
    required this.word,
    this.phoneticUk = '',
    this.phoneticUs = '',
    this.partOfSpeech = '',
    this.definitionCn = '',
    List<BookWordExample>? sentenceExamples,
    this.synonyms = const [],
    this.root = '',
    this.masteryLevel = 0,
    this.lastReviewTime,
    this.reviewCount = 0,
    this.correctStreak = 0,
    this.imageUrl,
    this.definitions,
    this.structuredExamplesRich,
    this.collocations,
    this.confusableWords,
    this.memoryTips,
    List<String>? bookIds,
    this.legacyExamples,
    this.englishDefinitions,
    this.synonymDetails,
  })  : sentenceExamples = sentenceExamples ?? [],
        bookIds = bookIds ?? [];

  factory BookWord.fromJson(Map<String, dynamic> json) {
    final synonymDetails = _synonymDetailsFromJson(json['synonyms']);
    return BookWord(
        id: json['id'] as String,
        word: json['word'] as String,
        phoneticUk: json['phoneticUk'] as String? ?? '',
        phoneticUs: json['phoneticUs'] as String? ?? '',
        partOfSpeech: json['partOfSpeech'] as String? ?? '',
        definitionCn: json['definitionCn'] as String,
        sentenceExamples: (json['examples'] as List<dynamic>? ?? const [])
            .map(
              (e) => BookWordExample.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        synonyms: synonymDetails
                ?.map((item) => item.word)
                .where((item) => item.trim().isNotEmpty)
                .toList() ??
            List<String>.from(json['synonyms'] ?? const []),
        synonymDetails: synonymDetails,
        root: json['root'] as String? ?? '',
        masteryLevel: json['masteryLevel'] as int? ?? 0,
        lastReviewTime: json['lastReviewTime'] == null
            ? null
            : DateTime.tryParse(json['lastReviewTime'].toString()),
        reviewCount: json['reviewCount'] as int? ?? 0,
        correctStreak: json['correctStreak'] as int? ?? 0,
        imageUrl: json['imageUrl'] as String?,
        bookIds: List<String>.from(json['bookIds'] ?? const []),
        definitions: _definitionsFromJson(json['definitions']),
        englishDefinitions: _definitionsFromJson(json['englishDefinitions']),
        collocations: _collocationsFromJson(json['collocations']),
        memoryTips: _memoryTipsFromJson(json['memoryTips']),
      );
  }

  static List<ConfusableWord>? _synonymDetailsFromJson(dynamic raw) {
    if (raw is! List<dynamic>) {
      return null;
    }

    final details = <ConfusableWord>[];
    for (final entry in raw) {
      if (entry is String) {
        final word = entry.trim();
        if (word.isEmpty) {
          continue;
        }
        details.add(
          ConfusableWord()
            ..word = word
            ..explanation = '',
        );
        continue;
      }

      if (entry is Map<String, dynamic>) {
        final word = (entry['word'] as String? ?? '').trim();
        if (word.isEmpty) {
          continue;
        }
        details.add(
          ConfusableWord()
            ..word = word
            ..explanation = (entry['meaning'] as String? ??
                    entry['chinese'] as String? ??
                    '')
                .trim(),
        );
      }
    }

    return details.isEmpty ? null : details;
  }

  static List<WordDefinition>? _definitionsFromJson(dynamic raw) {
    if (raw is! List<dynamic>) {
      return null;
    }
    final definitions = raw
        .map((entry) {
          final map = entry as Map<String, dynamic>;
          final meaning = map['meaning'] as String? ?? '';
          if (meaning.trim().isEmpty) {
            return null;
          }
          return WordDefinition(
            partOfSpeech: map['partOfSpeech'] as String? ?? '',
            meaning: meaning.trim(),
          );
        })
        .whereType<WordDefinition>()
        .toList();
    return definitions.isEmpty ? null : definitions;
  }

  static List<WordPhrase>? _collocationsFromJson(dynamic raw) {
    if (raw is! List<dynamic>) {
      return null;
    }
    final phrases = raw
        .map((entry) {
          final map = entry as Map<String, dynamic>;
          final phrase = map['phrase'] as String? ?? '';
          if (phrase.trim().isEmpty) {
            return null;
          }
          final example = map['example'];
          String? exampleEnglish;
          String? exampleChinese;
          if (example is Map<String, dynamic>) {
            exampleEnglish = example['en'] as String?;
            exampleChinese = example['cn'] as String?;
          } else {
            exampleEnglish = map['exampleEnglish'] as String?;
            exampleChinese = map['exampleChinese'] as String?;
          }

          return WordPhrase(
            phrase: phrase.trim(),
            translation: map['translation'] as String? ?? '',
            exampleEnglish: exampleEnglish?.trim(),
            exampleChinese: exampleChinese?.trim(),
          );
        })
        .whereType<WordPhrase>()
        .toList();
    return phrases.isEmpty ? null : phrases;
  }

  static MemoryTips? _memoryTipsFromJson(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }
    final tips = MemoryTips(
      etymology: raw['etymology'] as String?,
      mnemonic: raw['mnemonic'] as String?,
      association: raw['association'] as String?,
    );
    if ((tips.etymology ?? '').trim().isEmpty &&
        (tips.mnemonic ?? '').trim().isEmpty &&
        (tips.association ?? '').trim().isEmpty) {
      return null;
    }
    return tips;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'phoneticUk': phoneticUk,
        'phoneticUs': phoneticUs,
        'partOfSpeech': partOfSpeech,
        'definitionCn': definitionCn,
        'examples': sentenceExamples.map((e) => e.toJson()).toList(),
        'synonyms': synonymDetails != null && synonymDetails!.isNotEmpty
            ? synonymDetails!
                .map(
                  (item) => {
                    'word': item.word,
                    'meaning': item.explanation,
                  },
                )
                .toList()
            : synonyms,
        'root': root,
        'masteryLevel': masteryLevel,
        'lastReviewTime': lastReviewTime?.toIso8601String(),
        'reviewCount': reviewCount,
        'correctStreak': correctStreak,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (bookIds.isNotEmpty) 'bookIds': bookIds,
        if (definitions != null && definitions!.isNotEmpty)
          'definitions': definitions!
              .map(
                (item) => {
                  'partOfSpeech': item.partOfSpeech,
                  'meaning': item.meaning,
                },
              )
              .toList(),
        if (englishDefinitions != null && englishDefinitions!.isNotEmpty)
          'englishDefinitions': englishDefinitions!
              .map(
                (item) => {
                  'partOfSpeech': item.partOfSpeech,
                  'meaning': item.meaning,
                },
              )
              .toList(),
        if (collocations != null && collocations!.isNotEmpty)
          'collocations': collocations!
              .map(
                (item) => {
                  'phrase': item.phrase,
                  'translation': item.translation,
                  if (item.exampleEnglish != null &&
                      item.exampleEnglish!.trim().isNotEmpty)
                    'example': {
                      'en': item.exampleEnglish,
                      'cn': item.exampleChinese ?? '',
                    },
                },
              )
              .toList(),
        if (memoryTips != null)
          'memoryTips': {
            if (memoryTips!.etymology != null)
              'etymology': memoryTips!.etymology,
            if (memoryTips!.mnemonic != null) 'mnemonic': memoryTips!.mnemonic,
            if (memoryTips!.association != null)
              'association': memoryTips!.association,
          },
      };

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

@HiveType(typeId: 2)
class BookWordExample {
  @HiveField(0)
  final String en;

  @HiveField(1)
  final String cn;

  BookWordExample({
    required this.en,
    required this.cn,
  });

  factory BookWordExample.fromJson(Map<String, dynamic> json) => BookWordExample(
        en: json['en'] as String? ?? '',
        cn: json['cn'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'en': en,
        'cn': cn,
      };
}

@HiveType(typeId: 3)
class MemoryTips {
  @HiveField(0)
  String? etymology;

  @HiveField(1)
  String? mnemonic;

  @HiveField(2)
  String? association;

  MemoryTips({this.etymology, this.mnemonic, this.association});
}

@HiveType(typeId: 4)
class WordDefinition {
  @HiveField(0)
  String partOfSpeech;

  @HiveField(1)
  String meaning;

  WordDefinition({this.partOfSpeech = '', this.meaning = ''});
}

@HiveType(typeId: 5)
class WordExample {
  @HiveField(0)
  String english;

  @HiveField(1)
  String chinese;

  @HiveField(2)
  String? partOfSpeech;

  @HiveField(3)
  String? meaning;

  WordExample({
    this.english = '',
    this.chinese = '',
    this.partOfSpeech,
    this.meaning,
  });
}

@HiveType(typeId: 6)
class WordPhrase {
  @HiveField(0)
  String phrase;

  @HiveField(1)
  String translation;

  @HiveField(2)
  String? exampleEnglish;

  @HiveField(3)
  String? exampleChinese;

  WordPhrase({
    this.phrase = '',
    this.translation = '',
    this.exampleEnglish,
    this.exampleChinese,
  });
}

@HiveType(typeId: 7)
class ConfusableWord {
  @HiveField(0)
  String word;

  @HiveField(1)
  String explanation;

  @HiveField(2)
  String? exampleEnglish;

  @HiveField(3)
  String? exampleChinese;

  ConfusableWord({
    this.word = '',
    this.explanation = '',
    this.exampleEnglish,
    this.exampleChinese,
  });
}