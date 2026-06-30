// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      bookId: fields[0] as String,
      bookName: fields[1] as String,
      description: fields[2] as String,
      totalWords: fields[3] as int,
      cover: fields[4] as String,
      category: fields[5] as String,
      difficulty: fields[6] as String,
      words: (fields[7] as List?)?.cast<BookWord>(),
      coverColor: fields[8] as String,
      createdAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.bookName)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.totalWords)
      ..writeByte(4)
      ..write(obj.cover)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.difficulty)
      ..writeByte(7)
      ..write(obj.words)
      ..writeByte(8)
      ..write(obj.coverColor)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookWordAdapter extends TypeAdapter<BookWord> {
  @override
  final int typeId = 1;

  @override
  BookWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookWord(
      id: fields[0] as String,
      word: fields[1] as String,
      phoneticUk: fields[2] as String,
      phoneticUs: fields[3] as String,
      partOfSpeech: fields[4] as String,
      definitionCn: fields[5] as String,
      sentenceExamples: (fields[6] as List?)?.cast<BookWordExample>(),
      root: fields[7] as String,
      learned: fields[8] as bool,
      definitions: (fields[9] as List?)?.cast<WordDefinition>(),
      collocations: (fields[10] as List?)?.cast<WordPhrase>(),
      memoryTips: fields[11] as MemoryTips?,
      bookIds: (fields[12] as List?)?.cast<String>(),
      englishDefinitions: (fields[13] as List?)?.cast<WordDefinition>(),
      synonymDetails: (fields[14] as List?)?.cast<ConfusableWord>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookWord obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.phoneticUk)
      ..writeByte(3)
      ..write(obj.phoneticUs)
      ..writeByte(4)
      ..write(obj.partOfSpeech)
      ..writeByte(5)
      ..write(obj.definitionCn)
      ..writeByte(6)
      ..write(obj.sentenceExamples)
      ..writeByte(7)
      ..write(obj.root)
      ..writeByte(8)
      ..write(obj.learned)
      ..writeByte(9)
      ..write(obj.definitions)
      ..writeByte(10)
      ..write(obj.collocations)
      ..writeByte(11)
      ..write(obj.memoryTips)
      ..writeByte(12)
      ..write(obj.bookIds)
      ..writeByte(13)
      ..write(obj.englishDefinitions)
      ..writeByte(14)
      ..write(obj.synonymDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookWordExampleAdapter extends TypeAdapter<BookWordExample> {
  @override
  final int typeId = 2;

  @override
  BookWordExample read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookWordExample(
      en: fields[0] as String,
      cn: fields[1] as String,
      partOfSpeech: fields[2] as String?,
      meaning: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookWordExample obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.en)
      ..writeByte(1)
      ..write(obj.cn)
      ..writeByte(2)
      ..write(obj.partOfSpeech)
      ..writeByte(3)
      ..write(obj.meaning);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookWordExampleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MemoryTipsAdapter extends TypeAdapter<MemoryTips> {
  @override
  final int typeId = 3;

  @override
  MemoryTips read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemoryTips(
      etymology: fields[0] as String?,
      mnemonic: fields[1] as String?,
      association: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MemoryTips obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.etymology)
      ..writeByte(1)
      ..write(obj.mnemonic)
      ..writeByte(2)
      ..write(obj.association);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryTipsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordDefinitionAdapter extends TypeAdapter<WordDefinition> {
  @override
  final int typeId = 4;

  @override
  WordDefinition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordDefinition(
      partOfSpeech: fields[0] as String,
      meaning: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordDefinition obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.partOfSpeech)
      ..writeByte(1)
      ..write(obj.meaning);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordDefinitionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordExampleAdapter extends TypeAdapter<WordExample> {
  @override
  final int typeId = 5;

  @override
  WordExample read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordExample(
      english: fields[0] as String,
      chinese: fields[1] as String,
      partOfSpeech: fields[2] as String?,
      meaning: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WordExample obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.english)
      ..writeByte(1)
      ..write(obj.chinese)
      ..writeByte(2)
      ..write(obj.partOfSpeech)
      ..writeByte(3)
      ..write(obj.meaning);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordExampleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordPhraseAdapter extends TypeAdapter<WordPhrase> {
  @override
  final int typeId = 6;

  @override
  WordPhrase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordPhrase(
      phrase: fields[0] as String,
      translation: fields[1] as String,
      exampleEnglish: fields[2] as String?,
      exampleChinese: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WordPhrase obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.phrase)
      ..writeByte(1)
      ..write(obj.translation)
      ..writeByte(2)
      ..write(obj.exampleEnglish)
      ..writeByte(3)
      ..write(obj.exampleChinese);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordPhraseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConfusableWordAdapter extends TypeAdapter<ConfusableWord> {
  @override
  final int typeId = 7;

  @override
  ConfusableWord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfusableWord(
      word: fields[0] as String,
      explanation: fields[1] as String,
      exampleEnglish: fields[2] as String?,
      exampleChinese: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ConfusableWord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.explanation)
      ..writeByte(2)
      ..write(obj.exampleEnglish)
      ..writeByte(3)
      ..write(obj.exampleChinese);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfusableWordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
