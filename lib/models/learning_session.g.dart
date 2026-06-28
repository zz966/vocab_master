// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLearningSessionCollection on Isar {
  IsarCollection<LearningSession> get learningSessions => this.collection();
}

const LearningSessionSchema = CollectionSchema(
  name: r'LearningSession',
  id: 8239719336843205505,
  properties: {
    r'bookIds': PropertySchema(
      id: 0,
      name: r'bookIds',
      type: IsarType.longList,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'sessionType': PropertySchema(
      id: 2,
      name: r'sessionType',
      type: IsarType.string,
    ),
    r'startedAt': PropertySchema(
      id: 3,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'wordsCorrect': PropertySchema(
      id: 4,
      name: r'wordsCorrect',
      type: IsarType.long,
    ),
    r'wordsStudied': PropertySchema(
      id: 5,
      name: r'wordsStudied',
      type: IsarType.long,
    )
  },
  estimateSize: _learningSessionEstimateSize,
  serialize: _learningSessionSerialize,
  deserialize: _learningSessionDeserialize,
  deserializeProp: _learningSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _learningSessionGetId,
  getLinks: _learningSessionGetLinks,
  attach: _learningSessionAttach,
  version: '3.1.0+1',
);

int _learningSessionEstimateSize(
  LearningSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookIds.length * 8;
  bytesCount += 3 + object.sessionType.length * 3;
  return bytesCount;
}

void _learningSessionSerialize(
  LearningSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.bookIds);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeString(offsets[2], object.sessionType);
  writer.writeDateTime(offsets[3], object.startedAt);
  writer.writeLong(offsets[4], object.wordsCorrect);
  writer.writeLong(offsets[5], object.wordsStudied);
}

LearningSession _learningSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LearningSession();
  object.bookIds = reader.readLongList(offsets[0]) ?? [];
  object.completedAt = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.sessionType = reader.readString(offsets[2]);
  object.startedAt = reader.readDateTime(offsets[3]);
  object.wordsCorrect = reader.readLong(offsets[4]);
  object.wordsStudied = reader.readLong(offsets[5]);
  return object;
}

P _learningSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _learningSessionGetId(LearningSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _learningSessionGetLinks(LearningSession object) {
  return [];
}

void _learningSessionAttach(
    IsarCollection<dynamic> col, Id id, LearningSession object) {
  object.id = id;
}

extension LearningSessionQueryWhereSort
    on QueryBuilder<LearningSession, LearningSession, QWhere> {
  QueryBuilder<LearningSession, LearningSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LearningSessionQueryWhere
    on QueryBuilder<LearningSession, LearningSession, QWhereClause> {
  QueryBuilder<LearningSession, LearningSession, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<LearningSession, LearningSession, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterWhereClause> idBetween(
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

extension LearningSessionQueryFilter
    on QueryBuilder<LearningSession, LearningSession, QFilterCondition> {
  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIds',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsElementGreaterThan(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsElementLessThan(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsElementBetween(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsLengthEqualTo(int length) {
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsIsEmpty() {
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsIsNotEmpty() {
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsLengthLessThan(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsLengthGreaterThan(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      bookIdsLengthBetween(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sessionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sessionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionType',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      sessionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sessionType',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      startedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      startedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      wordsCorrectEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordsCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      wordsCorrectGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordsCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      wordsCorrectLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordsCorrect',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      wordsCorrectBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordsCorrect',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      wordsStudiedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordsStudied',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      wordsStudiedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordsStudied',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      wordsStudiedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordsStudied',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterFilterCondition>
      wordsStudiedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordsStudied',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LearningSessionQueryObject
    on QueryBuilder<LearningSession, LearningSession, QFilterCondition> {}

extension LearningSessionQueryLinks
    on QueryBuilder<LearningSession, LearningSession, QFilterCondition> {}

extension LearningSessionQuerySortBy
    on QueryBuilder<LearningSession, LearningSession, QSortBy> {
  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortBySessionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionType', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortBySessionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionType', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortByWordsCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsCorrect', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortByWordsCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsCorrect', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortByWordsStudied() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsStudied', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      sortByWordsStudiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsStudied', Sort.desc);
    });
  }
}

extension LearningSessionQuerySortThenBy
    on QueryBuilder<LearningSession, LearningSession, QSortThenBy> {
  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenBySessionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionType', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenBySessionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionType', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenByWordsCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsCorrect', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenByWordsCorrectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsCorrect', Sort.desc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenByWordsStudied() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsStudied', Sort.asc);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QAfterSortBy>
      thenByWordsStudiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordsStudied', Sort.desc);
    });
  }
}

extension LearningSessionQueryWhereDistinct
    on QueryBuilder<LearningSession, LearningSession, QDistinct> {
  QueryBuilder<LearningSession, LearningSession, QDistinct>
      distinctByBookIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookIds');
    });
  }

  QueryBuilder<LearningSession, LearningSession, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<LearningSession, LearningSession, QDistinct>
      distinctBySessionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningSession, LearningSession, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<LearningSession, LearningSession, QDistinct>
      distinctByWordsCorrect() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordsCorrect');
    });
  }

  QueryBuilder<LearningSession, LearningSession, QDistinct>
      distinctByWordsStudied() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordsStudied');
    });
  }
}

extension LearningSessionQueryProperty
    on QueryBuilder<LearningSession, LearningSession, QQueryProperty> {
  QueryBuilder<LearningSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LearningSession, List<int>, QQueryOperations> bookIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookIds');
    });
  }

  QueryBuilder<LearningSession, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<LearningSession, String, QQueryOperations>
      sessionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionType');
    });
  }

  QueryBuilder<LearningSession, DateTime, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<LearningSession, int, QQueryOperations> wordsCorrectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordsCorrect');
    });
  }

  QueryBuilder<LearningSession, int, QQueryOperations> wordsStudiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordsStudied');
    });
  }
}
