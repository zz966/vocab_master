// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWordCollection on Isar {
  IsarCollection<Word> get words => this.collection();
}

const WordSchema = CollectionSchema(
  name: r'Word',
  id: 2997905348638732671,
  properties: {
    r'bookIds': PropertySchema(
      id: 0,
      name: r'bookIds',
      type: IsarType.longList,
    ),
    r'chinese': PropertySchema(
      id: 1,
      name: r'chinese',
      type: IsarType.string,
    ),
    r'collocations': PropertySchema(
      id: 2,
      name: r'collocations',
      type: IsarType.objectList,
      target: r'WordPhrase',
    ),
    r'confusableWords': PropertySchema(
      id: 3,
      name: r'confusableWords',
      type: IsarType.objectList,
      target: r'ConfusableWord',
    ),
    r'correctStreak': PropertySchema(
      id: 4,
      name: r'correctStreak',
      type: IsarType.long,
    ),
    r'definitions': PropertySchema(
      id: 5,
      name: r'definitions',
      type: IsarType.objectList,
      target: r'WordDefinition',
    ),
    r'easeFactor': PropertySchema(
      id: 6,
      name: r'easeFactor',
      type: IsarType.double,
    ),
    r'english': PropertySchema(
      id: 7,
      name: r'english',
      type: IsarType.string,
    ),
    r'examples': PropertySchema(
      id: 8,
      name: r'examples',
      type: IsarType.stringList,
    ),
    r'familiarity': PropertySchema(
      id: 9,
      name: r'familiarity',
      type: IsarType.long,
    ),
    r'imageUrl': PropertySchema(
      id: 10,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'inWrongBook': PropertySchema(
      id: 11,
      name: r'inWrongBook',
      type: IsarType.bool,
    ),
    r'isFavorite': PropertySchema(
      id: 12,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'memoryTips': PropertySchema(
      id: 13,
      name: r'memoryTips',
      type: IsarType.object,
      target: r'MemoryTips',
    ),
    r'nextReview': PropertySchema(
      id: 14,
      name: r'nextReview',
      type: IsarType.dateTime,
    ),
    r'partOfSpeech': PropertySchema(
      id: 15,
      name: r'partOfSpeech',
      type: IsarType.string,
    ),
    r'phonetic': PropertySchema(
      id: 16,
      name: r'phonetic',
      type: IsarType.string,
    ),
    r'reviewCount': PropertySchema(
      id: 17,
      name: r'reviewCount',
      type: IsarType.long,
    ),
    r'sm2Interval': PropertySchema(
      id: 18,
      name: r'sm2Interval',
      type: IsarType.double,
    ),
    r'structuredExamples': PropertySchema(
      id: 19,
      name: r'structuredExamples',
      type: IsarType.objectList,
      target: r'WordExample',
    )
  },
  estimateSize: _wordEstimateSize,
  serialize: _wordSerialize,
  deserialize: _wordDeserialize,
  deserializeProp: _wordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'MemoryTips': MemoryTipsSchema,
    r'WordDefinition': WordDefinitionSchema,
    r'WordExample': WordExampleSchema,
    r'WordPhrase': WordPhraseSchema,
    r'ConfusableWord': ConfusableWordSchema
  },
  getId: _wordGetId,
  getLinks: _wordGetLinks,
  attach: _wordAttach,
  version: '3.1.0+1',
);

int _wordEstimateSize(
  Word object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookIds.length * 8;
  bytesCount += 3 + object.chinese.length * 3;
  {
    final list = object.collocations;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[WordPhrase]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              WordPhraseSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.confusableWords;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ConfusableWord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              ConfusableWordSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.definitions;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[WordDefinition]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              WordDefinitionSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  bytesCount += 3 + object.english.length * 3;
  {
    final list = object.examples;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.imageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.memoryTips;
    if (value != null) {
      bytesCount += 3 +
          MemoryTipsSchema.estimateSize(
              value, allOffsets[MemoryTips]!, allOffsets);
    }
  }
  {
    final value = object.partOfSpeech;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phonetic;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.structuredExamples;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[WordExample]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              WordExampleSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  return bytesCount;
}

void _wordSerialize(
  Word object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.bookIds);
  writer.writeString(offsets[1], object.chinese);
  writer.writeObjectList<WordPhrase>(
    offsets[2],
    allOffsets,
    WordPhraseSchema.serialize,
    object.collocations,
  );
  writer.writeObjectList<ConfusableWord>(
    offsets[3],
    allOffsets,
    ConfusableWordSchema.serialize,
    object.confusableWords,
  );
  writer.writeLong(offsets[4], object.correctStreak);
  writer.writeObjectList<WordDefinition>(
    offsets[5],
    allOffsets,
    WordDefinitionSchema.serialize,
    object.definitions,
  );
  writer.writeDouble(offsets[6], object.easeFactor);
  writer.writeString(offsets[7], object.english);
  writer.writeStringList(offsets[8], object.examples);
  writer.writeLong(offsets[9], object.familiarity);
  writer.writeString(offsets[10], object.imageUrl);
  writer.writeBool(offsets[11], object.inWrongBook);
  writer.writeBool(offsets[12], object.isFavorite);
  writer.writeObject<MemoryTips>(
    offsets[13],
    allOffsets,
    MemoryTipsSchema.serialize,
    object.memoryTips,
  );
  writer.writeDateTime(offsets[14], object.nextReview);
  writer.writeString(offsets[15], object.partOfSpeech);
  writer.writeString(offsets[16], object.phonetic);
  writer.writeLong(offsets[17], object.reviewCount);
  writer.writeDouble(offsets[18], object.sm2Interval);
  writer.writeObjectList<WordExample>(
    offsets[19],
    allOffsets,
    WordExampleSchema.serialize,
    object.structuredExamples,
  );
}

Word _wordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Word();
  object.bookIds = reader.readLongList(offsets[0]) ?? [];
  object.chinese = reader.readString(offsets[1]);
  object.collocations = reader.readObjectList<WordPhrase>(
    offsets[2],
    WordPhraseSchema.deserialize,
    allOffsets,
    WordPhrase(),
  );
  object.confusableWords = reader.readObjectList<ConfusableWord>(
    offsets[3],
    ConfusableWordSchema.deserialize,
    allOffsets,
    ConfusableWord(),
  );
  object.correctStreak = reader.readLong(offsets[4]);
  object.definitions = reader.readObjectList<WordDefinition>(
    offsets[5],
    WordDefinitionSchema.deserialize,
    allOffsets,
    WordDefinition(),
  );
  object.easeFactor = reader.readDouble(offsets[6]);
  object.english = reader.readString(offsets[7]);
  object.examples = reader.readStringList(offsets[8]);
  object.familiarity = reader.readLong(offsets[9]);
  object.id = id;
  object.imageUrl = reader.readStringOrNull(offsets[10]);
  object.inWrongBook = reader.readBool(offsets[11]);
  object.isFavorite = reader.readBool(offsets[12]);
  object.memoryTips = reader.readObjectOrNull<MemoryTips>(
    offsets[13],
    MemoryTipsSchema.deserialize,
    allOffsets,
  );
  object.nextReview = reader.readDateTimeOrNull(offsets[14]);
  object.partOfSpeech = reader.readStringOrNull(offsets[15]);
  object.phonetic = reader.readStringOrNull(offsets[16]);
  object.reviewCount = reader.readLong(offsets[17]);
  object.sm2Interval = reader.readDouble(offsets[18]);
  object.structuredExamples = reader.readObjectList<WordExample>(
    offsets[19],
    WordExampleSchema.deserialize,
    allOffsets,
    WordExample(),
  );
  return object;
}

P _wordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readObjectList<WordPhrase>(
        offset,
        WordPhraseSchema.deserialize,
        allOffsets,
        WordPhrase(),
      )) as P;
    case 3:
      return (reader.readObjectList<ConfusableWord>(
        offset,
        ConfusableWordSchema.deserialize,
        allOffsets,
        ConfusableWord(),
      )) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readObjectList<WordDefinition>(
        offset,
        WordDefinitionSchema.deserialize,
        allOffsets,
        WordDefinition(),
      )) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringList(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readObjectOrNull<MemoryTips>(
        offset,
        MemoryTipsSchema.deserialize,
        allOffsets,
      )) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readObjectList<WordExample>(
        offset,
        WordExampleSchema.deserialize,
        allOffsets,
        WordExample(),
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wordGetId(Word object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wordGetLinks(Word object) {
  return [];
}

void _wordAttach(IsarCollection<dynamic> col, Id id, Word object) {
  object.id = id;
}

extension WordQueryWhereSort on QueryBuilder<Word, Word, QWhere> {
  QueryBuilder<Word, Word, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WordQueryWhere on QueryBuilder<Word, Word, QWhereClause> {
  QueryBuilder<Word, Word, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Word, Word, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WordQueryFilter on QueryBuilder<Word, Word, QFilterCondition> {
  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIds',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookIds',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookIds',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bookIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bookIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bookIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bookIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bookIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> bookIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bookIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chinese',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chinese',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chinese',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> chineseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chinese',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'collocations',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'collocations',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collocations',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collocations',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collocations',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collocations',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collocations',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collocations',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> confusableWordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'confusableWords',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> confusableWordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'confusableWords',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> confusableWordsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'confusableWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> confusableWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'confusableWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> confusableWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'confusableWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> confusableWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'confusableWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition>
      confusableWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'confusableWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> confusableWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'confusableWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> correctStreakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> correctStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'correctStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> correctStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'correctStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> correctStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'correctStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'definitions',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'definitions',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'definitions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'definitions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'definitions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'definitions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'definitions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'definitions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> easeFactorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> easeFactorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> easeFactorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'easeFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> easeFactorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'easeFactor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'english',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'english',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'english',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> englishIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'english',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'examples',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'examples',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'examples',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'examples',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'examples',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'examples',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'examples',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'examples',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'examples',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'examples',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'examples',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'examples',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examples',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examples',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examples',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examples',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examples',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> examplesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'examples',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> familiarityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familiarity',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> familiarityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'familiarity',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> familiarityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'familiarity',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> familiarityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'familiarity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> inWrongBookEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'inWrongBook',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> isFavoriteEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> memoryTipsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'memoryTips',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> memoryTipsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'memoryTips',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nextReviewIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextReview',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nextReviewIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextReview',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nextReviewEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextReview',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nextReviewGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextReview',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nextReviewLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextReview',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> nextReviewBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextReview',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partOfSpeech',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partOfSpeech',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partOfSpeech',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partOfSpeech',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partOfSpeech',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> partOfSpeechIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partOfSpeech',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phonetic',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phonetic',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phonetic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phonetic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phonetic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phonetic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phonetic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phonetic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phonetic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phonetic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phonetic',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> phoneticIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phonetic',
        value: '',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> reviewCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> reviewCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reviewCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> reviewCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reviewCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> reviewCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reviewCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> sm2IntervalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sm2Interval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> sm2IntervalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sm2Interval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> sm2IntervalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sm2Interval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> sm2IntervalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sm2Interval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> structuredExamplesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'structuredExamples',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition>
      structuredExamplesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'structuredExamples',
      ));
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition>
      structuredExamplesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'structuredExamples',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> structuredExamplesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'structuredExamples',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition>
      structuredExamplesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'structuredExamples',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition>
      structuredExamplesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'structuredExamples',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition>
      structuredExamplesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'structuredExamples',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition>
      structuredExamplesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'structuredExamples',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension WordQueryObject on QueryBuilder<Word, Word, QFilterCondition> {
  QueryBuilder<Word, Word, QAfterFilterCondition> collocationsElement(
      FilterQuery<WordPhrase> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'collocations');
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> confusableWordsElement(
      FilterQuery<ConfusableWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'confusableWords');
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> definitionsElement(
      FilterQuery<WordDefinition> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'definitions');
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> memoryTips(
      FilterQuery<MemoryTips> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'memoryTips');
    });
  }

  QueryBuilder<Word, Word, QAfterFilterCondition> structuredExamplesElement(
      FilterQuery<WordExample> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'structuredExamples');
    });
  }
}

extension WordQueryLinks on QueryBuilder<Word, Word, QFilterCondition> {}

extension WordQuerySortBy on QueryBuilder<Word, Word, QSortBy> {
  QueryBuilder<Word, Word, QAfterSortBy> sortByChinese() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chinese', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByChineseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chinese', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByCorrectStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctStreak', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByCorrectStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctStreak', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByEaseFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByEnglish() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'english', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByEnglishDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'english', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByFamiliarity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familiarity', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByFamiliarityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familiarity', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByInWrongBook() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inWrongBook', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByInWrongBookDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inWrongBook', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByNextReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReview', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByNextReviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReview', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByPartOfSpeech() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partOfSpeech', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByPartOfSpeechDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partOfSpeech', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByPhonetic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phonetic', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByPhoneticDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phonetic', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByReviewCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewCount', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortByReviewCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewCount', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortBySm2Interval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sm2Interval', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> sortBySm2IntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sm2Interval', Sort.desc);
    });
  }
}

extension WordQuerySortThenBy on QueryBuilder<Word, Word, QSortThenBy> {
  QueryBuilder<Word, Word, QAfterSortBy> thenByChinese() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chinese', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByChineseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chinese', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByCorrectStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctStreak', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByCorrectStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctStreak', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByEaseFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByEnglish() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'english', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByEnglishDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'english', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByFamiliarity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familiarity', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByFamiliarityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familiarity', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByInWrongBook() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inWrongBook', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByInWrongBookDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inWrongBook', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByNextReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReview', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByNextReviewDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReview', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByPartOfSpeech() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partOfSpeech', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByPartOfSpeechDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partOfSpeech', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByPhonetic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phonetic', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByPhoneticDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phonetic', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByReviewCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewCount', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenByReviewCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewCount', Sort.desc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenBySm2Interval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sm2Interval', Sort.asc);
    });
  }

  QueryBuilder<Word, Word, QAfterSortBy> thenBySm2IntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sm2Interval', Sort.desc);
    });
  }
}

extension WordQueryWhereDistinct on QueryBuilder<Word, Word, QDistinct> {
  QueryBuilder<Word, Word, QDistinct> distinctByBookIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookIds');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByChinese(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chinese', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByCorrectStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctStreak');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'easeFactor');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByEnglish(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'english', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByExamples() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'examples');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByFamiliarity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'familiarity');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByInWrongBook() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inWrongBook');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByNextReview() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextReview');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByPartOfSpeech(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partOfSpeech', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByPhonetic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phonetic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctByReviewCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reviewCount');
    });
  }

  QueryBuilder<Word, Word, QDistinct> distinctBySm2Interval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sm2Interval');
    });
  }
}

extension WordQueryProperty on QueryBuilder<Word, Word, QQueryProperty> {
  QueryBuilder<Word, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Word, List<int>, QQueryOperations> bookIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookIds');
    });
  }

  QueryBuilder<Word, String, QQueryOperations> chineseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chinese');
    });
  }

  QueryBuilder<Word, List<WordPhrase>?, QQueryOperations>
      collocationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collocations');
    });
  }

  QueryBuilder<Word, List<ConfusableWord>?, QQueryOperations>
      confusableWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confusableWords');
    });
  }

  QueryBuilder<Word, int, QQueryOperations> correctStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctStreak');
    });
  }

  QueryBuilder<Word, List<WordDefinition>?, QQueryOperations>
      definitionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'definitions');
    });
  }

  QueryBuilder<Word, double, QQueryOperations> easeFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'easeFactor');
    });
  }

  QueryBuilder<Word, String, QQueryOperations> englishProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'english');
    });
  }

  QueryBuilder<Word, List<String>?, QQueryOperations> examplesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'examples');
    });
  }

  QueryBuilder<Word, int, QQueryOperations> familiarityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'familiarity');
    });
  }

  QueryBuilder<Word, String?, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<Word, bool, QQueryOperations> inWrongBookProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inWrongBook');
    });
  }

  QueryBuilder<Word, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<Word, MemoryTips?, QQueryOperations> memoryTipsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memoryTips');
    });
  }

  QueryBuilder<Word, DateTime?, QQueryOperations> nextReviewProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextReview');
    });
  }

  QueryBuilder<Word, String?, QQueryOperations> partOfSpeechProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partOfSpeech');
    });
  }

  QueryBuilder<Word, String?, QQueryOperations> phoneticProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phonetic');
    });
  }

  QueryBuilder<Word, int, QQueryOperations> reviewCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reviewCount');
    });
  }

  QueryBuilder<Word, double, QQueryOperations> sm2IntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sm2Interval');
    });
  }

  QueryBuilder<Word, List<WordExample>?, QQueryOperations>
      structuredExamplesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'structuredExamples');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const WordExampleSchema = Schema(
  name: r'WordExample',
  id: 1955377837531411831,
  properties: {
    r'chinese': PropertySchema(
      id: 0,
      name: r'chinese',
      type: IsarType.string,
    ),
    r'english': PropertySchema(
      id: 1,
      name: r'english',
      type: IsarType.string,
    ),
    r'meaning': PropertySchema(
      id: 2,
      name: r'meaning',
      type: IsarType.string,
    ),
    r'partOfSpeech': PropertySchema(
      id: 3,
      name: r'partOfSpeech',
      type: IsarType.string,
    )
  },
  estimateSize: _wordExampleEstimateSize,
  serialize: _wordExampleSerialize,
  deserialize: _wordExampleDeserialize,
  deserializeProp: _wordExampleDeserializeProp,
);

int _wordExampleEstimateSize(
  WordExample object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chinese.length * 3;
  bytesCount += 3 + object.english.length * 3;
  {
    final value = object.meaning;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.partOfSpeech;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _wordExampleSerialize(
  WordExample object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chinese);
  writer.writeString(offsets[1], object.english);
  writer.writeString(offsets[2], object.meaning);
  writer.writeString(offsets[3], object.partOfSpeech);
}

WordExample _wordExampleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WordExample();
  object.chinese = reader.readString(offsets[0]);
  object.english = reader.readString(offsets[1]);
  object.meaning = reader.readStringOrNull(offsets[2]);
  object.partOfSpeech = reader.readStringOrNull(offsets[3]);
  return object;
}

P _wordExampleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension WordExampleQueryFilter
    on QueryBuilder<WordExample, WordExample, QFilterCondition> {
  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> chineseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      chineseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> chineseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> chineseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chinese',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      chineseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> chineseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> chineseContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> chineseMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chinese',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      chineseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chinese',
        value: '',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      chineseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chinese',
        value: '',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> englishEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      englishGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> englishLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> englishBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'english',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      englishStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> englishEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> englishContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'english',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> englishMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'english',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      englishIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'english',
        value: '',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      englishIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'english',
        value: '',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      meaningIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'meaning',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      meaningIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'meaning',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> meaningEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      meaningGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> meaningLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> meaningBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'meaning',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      meaningStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> meaningEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> meaningContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition> meaningMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'meaning',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      meaningIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meaning',
        value: '',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      meaningIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'meaning',
        value: '',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partOfSpeech',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partOfSpeech',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partOfSpeech',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partOfSpeech',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partOfSpeech',
        value: '',
      ));
    });
  }

  QueryBuilder<WordExample, WordExample, QAfterFilterCondition>
      partOfSpeechIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partOfSpeech',
        value: '',
      ));
    });
  }
}

extension WordExampleQueryObject
    on QueryBuilder<WordExample, WordExample, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const WordPhraseSchema = Schema(
  name: r'WordPhrase',
  id: -5306580719556847254,
  properties: {
    r'phrase': PropertySchema(
      id: 0,
      name: r'phrase',
      type: IsarType.string,
    ),
    r'translation': PropertySchema(
      id: 1,
      name: r'translation',
      type: IsarType.string,
    )
  },
  estimateSize: _wordPhraseEstimateSize,
  serialize: _wordPhraseSerialize,
  deserialize: _wordPhraseDeserialize,
  deserializeProp: _wordPhraseDeserializeProp,
);

int _wordPhraseEstimateSize(
  WordPhrase object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.phrase.length * 3;
  bytesCount += 3 + object.translation.length * 3;
  return bytesCount;
}

void _wordPhraseSerialize(
  WordPhrase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.phrase);
  writer.writeString(offsets[1], object.translation);
}

WordPhrase _wordPhraseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WordPhrase();
  object.phrase = reader.readString(offsets[0]);
  object.translation = reader.readString(offsets[1]);
  return object;
}

P _wordPhraseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension WordPhraseQueryFilter
    on QueryBuilder<WordPhrase, WordPhrase, QFilterCondition> {
  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phrase',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phrase',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition> phraseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phrase',
        value: '',
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      phraseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phrase',
        value: '',
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translation',
        value: '',
      ));
    });
  }

  QueryBuilder<WordPhrase, WordPhrase, QAfterFilterCondition>
      translationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translation',
        value: '',
      ));
    });
  }
}

extension WordPhraseQueryObject
    on QueryBuilder<WordPhrase, WordPhrase, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ConfusableWordSchema = Schema(
  name: r'ConfusableWord',
  id: -4481739779438313234,
  properties: {
    r'exampleChinese': PropertySchema(
      id: 0,
      name: r'exampleChinese',
      type: IsarType.string,
    ),
    r'exampleEnglish': PropertySchema(
      id: 1,
      name: r'exampleEnglish',
      type: IsarType.string,
    ),
    r'explanation': PropertySchema(
      id: 2,
      name: r'explanation',
      type: IsarType.string,
    ),
    r'word': PropertySchema(
      id: 3,
      name: r'word',
      type: IsarType.string,
    )
  },
  estimateSize: _confusableWordEstimateSize,
  serialize: _confusableWordSerialize,
  deserialize: _confusableWordDeserialize,
  deserializeProp: _confusableWordDeserializeProp,
);

int _confusableWordEstimateSize(
  ConfusableWord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.exampleChinese;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.exampleEnglish;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.explanation.length * 3;
  bytesCount += 3 + object.word.length * 3;
  return bytesCount;
}

void _confusableWordSerialize(
  ConfusableWord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.exampleChinese);
  writer.writeString(offsets[1], object.exampleEnglish);
  writer.writeString(offsets[2], object.explanation);
  writer.writeString(offsets[3], object.word);
}

ConfusableWord _confusableWordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ConfusableWord();
  object.exampleChinese = reader.readStringOrNull(offsets[0]);
  object.exampleEnglish = reader.readStringOrNull(offsets[1]);
  object.explanation = reader.readString(offsets[2]);
  object.word = reader.readString(offsets[3]);
  return object;
}

P _confusableWordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ConfusableWordQueryFilter
    on QueryBuilder<ConfusableWord, ConfusableWord, QFilterCondition> {
  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exampleChinese',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exampleChinese',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exampleChinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exampleChinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exampleChinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exampleChinese',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exampleChinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exampleChinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exampleChinese',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exampleChinese',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exampleChinese',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleChineseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exampleChinese',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exampleEnglish',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exampleEnglish',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exampleEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exampleEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exampleEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exampleEnglish',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'exampleEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'exampleEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'exampleEnglish',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'exampleEnglish',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exampleEnglish',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      exampleEnglishIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'exampleEnglish',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'explanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'explanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'explanation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'explanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'explanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'explanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'explanation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explanation',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      explanationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'explanation',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'word',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'word',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'word',
        value: '',
      ));
    });
  }

  QueryBuilder<ConfusableWord, ConfusableWord, QAfterFilterCondition>
      wordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'word',
        value: '',
      ));
    });
  }
}

extension ConfusableWordQueryObject
    on QueryBuilder<ConfusableWord, ConfusableWord, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MemoryTipsSchema = Schema(
  name: r'MemoryTips',
  id: -1365990873070991661,
  properties: {
    r'association': PropertySchema(
      id: 0,
      name: r'association',
      type: IsarType.string,
    ),
    r'etymology': PropertySchema(
      id: 1,
      name: r'etymology',
      type: IsarType.string,
    ),
    r'mnemonic': PropertySchema(
      id: 2,
      name: r'mnemonic',
      type: IsarType.string,
    )
  },
  estimateSize: _memoryTipsEstimateSize,
  serialize: _memoryTipsSerialize,
  deserialize: _memoryTipsDeserialize,
  deserializeProp: _memoryTipsDeserializeProp,
);

int _memoryTipsEstimateSize(
  MemoryTips object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.association;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.etymology;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mnemonic;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _memoryTipsSerialize(
  MemoryTips object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.association);
  writer.writeString(offsets[1], object.etymology);
  writer.writeString(offsets[2], object.mnemonic);
}

MemoryTips _memoryTipsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MemoryTips();
  object.association = reader.readStringOrNull(offsets[0]);
  object.etymology = reader.readStringOrNull(offsets[1]);
  object.mnemonic = reader.readStringOrNull(offsets[2]);
  return object;
}

P _memoryTipsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MemoryTipsQueryFilter
    on QueryBuilder<MemoryTips, MemoryTips, QFilterCondition> {
  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'association',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'association',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'association',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'association',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'association',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'association',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'association',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'association',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'association',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'association',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'association',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      associationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'association',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      etymologyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'etymology',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      etymologyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'etymology',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> etymologyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etymology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      etymologyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'etymology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> etymologyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'etymology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> etymologyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'etymology',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      etymologyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'etymology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> etymologyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'etymology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> etymologyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'etymology',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> etymologyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'etymology',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      etymologyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'etymology',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      etymologyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'etymology',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> mnemonicIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mnemonic',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      mnemonicIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mnemonic',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> mnemonicEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mnemonic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      mnemonicGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mnemonic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> mnemonicLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mnemonic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> mnemonicBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mnemonic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      mnemonicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mnemonic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> mnemonicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mnemonic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> mnemonicContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mnemonic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition> mnemonicMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mnemonic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      mnemonicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mnemonic',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryTips, MemoryTips, QAfterFilterCondition>
      mnemonicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mnemonic',
        value: '',
      ));
    });
  }
}

extension MemoryTipsQueryObject
    on QueryBuilder<MemoryTips, MemoryTips, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const WordDefinitionSchema = Schema(
  name: r'WordDefinition',
  id: 6586057825204788504,
  properties: {
    r'meaning': PropertySchema(
      id: 0,
      name: r'meaning',
      type: IsarType.string,
    ),
    r'partOfSpeech': PropertySchema(
      id: 1,
      name: r'partOfSpeech',
      type: IsarType.string,
    )
  },
  estimateSize: _wordDefinitionEstimateSize,
  serialize: _wordDefinitionSerialize,
  deserialize: _wordDefinitionDeserialize,
  deserializeProp: _wordDefinitionDeserializeProp,
);

int _wordDefinitionEstimateSize(
  WordDefinition object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.meaning.length * 3;
  bytesCount += 3 + object.partOfSpeech.length * 3;
  return bytesCount;
}

void _wordDefinitionSerialize(
  WordDefinition object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.meaning);
  writer.writeString(offsets[1], object.partOfSpeech);
}

WordDefinition _wordDefinitionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WordDefinition();
  object.meaning = reader.readString(offsets[0]);
  object.partOfSpeech = reader.readString(offsets[1]);
  return object;
}

P _wordDefinitionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension WordDefinitionQueryFilter
    on QueryBuilder<WordDefinition, WordDefinition, QFilterCondition> {
  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'meaning',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'meaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'meaning',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'meaning',
        value: '',
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      meaningIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'meaning',
        value: '',
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partOfSpeech',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partOfSpeech',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partOfSpeech',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partOfSpeech',
        value: '',
      ));
    });
  }

  QueryBuilder<WordDefinition, WordDefinition, QAfterFilterCondition>
      partOfSpeechIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partOfSpeech',
        value: '',
      ));
    });
  }
}

extension WordDefinitionQueryObject
    on QueryBuilder<WordDefinition, WordDefinition, QFilterCondition> {}
