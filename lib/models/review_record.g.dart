// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReviewRecordCollection on Isar {
  IsarCollection<ReviewRecord> get reviewRecords => this.collection();
}

const ReviewRecordSchema = CollectionSchema(
  name: r'ReviewRecord',
  id: 1126049735988195586,
  properties: {
    r'bookId': PropertySchema(
      id: 0,
      name: r'bookId',
      type: IsarType.long,
    ),
    r'easeFactor': PropertySchema(
      id: 1,
      name: r'easeFactor',
      type: IsarType.double,
    ),
    r'newInterval': PropertySchema(
      id: 2,
      name: r'newInterval',
      type: IsarType.double,
    ),
    r'previousInterval': PropertySchema(
      id: 3,
      name: r'previousInterval',
      type: IsarType.double,
    ),
    r'quality': PropertySchema(
      id: 4,
      name: r'quality',
      type: IsarType.long,
    ),
    r'reviewedAt': PropertySchema(
      id: 5,
      name: r'reviewedAt',
      type: IsarType.dateTime,
    ),
    r'wordId': PropertySchema(
      id: 6,
      name: r'wordId',
      type: IsarType.long,
    )
  },
  estimateSize: _reviewRecordEstimateSize,
  serialize: _reviewRecordSerialize,
  deserialize: _reviewRecordDeserialize,
  deserializeProp: _reviewRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _reviewRecordGetId,
  getLinks: _reviewRecordGetLinks,
  attach: _reviewRecordAttach,
  version: '3.1.0+1',
);

int _reviewRecordEstimateSize(
  ReviewRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _reviewRecordSerialize(
  ReviewRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bookId);
  writer.writeDouble(offsets[1], object.easeFactor);
  writer.writeDouble(offsets[2], object.newInterval);
  writer.writeDouble(offsets[3], object.previousInterval);
  writer.writeLong(offsets[4], object.quality);
  writer.writeDateTime(offsets[5], object.reviewedAt);
  writer.writeLong(offsets[6], object.wordId);
}

ReviewRecord _reviewRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReviewRecord();
  object.bookId = reader.readLongOrNull(offsets[0]);
  object.easeFactor = reader.readDouble(offsets[1]);
  object.id = id;
  object.newInterval = reader.readDouble(offsets[2]);
  object.previousInterval = reader.readDouble(offsets[3]);
  object.quality = reader.readLong(offsets[4]);
  object.reviewedAt = reader.readDateTime(offsets[5]);
  object.wordId = reader.readLong(offsets[6]);
  return object;
}

P _reviewRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reviewRecordGetId(ReviewRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reviewRecordGetLinks(ReviewRecord object) {
  return [];
}

void _reviewRecordAttach(
    IsarCollection<dynamic> col, Id id, ReviewRecord object) {
  object.id = id;
}

extension ReviewRecordQueryWhereSort
    on QueryBuilder<ReviewRecord, ReviewRecord, QWhere> {
  QueryBuilder<ReviewRecord, ReviewRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReviewRecordQueryWhere
    on QueryBuilder<ReviewRecord, ReviewRecord, QWhereClause> {
  QueryBuilder<ReviewRecord, ReviewRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterWhereClause> idBetween(
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

extension ReviewRecordQueryFilter
    on QueryBuilder<ReviewRecord, ReviewRecord, QFilterCondition> {
  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      bookIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bookId',
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      bookIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bookId',
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition> bookIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      bookIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      bookIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition> bookIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      easeFactorEqualTo(
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

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      easeFactorGreaterThan(
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

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      easeFactorLessThan(
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

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      easeFactorBetween(
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

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      newIntervalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'newInterval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      newIntervalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'newInterval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      newIntervalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'newInterval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      newIntervalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'newInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      previousIntervalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previousInterval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      previousIntervalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previousInterval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      previousIntervalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previousInterval',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      previousIntervalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previousInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      qualityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quality',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      qualityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quality',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      qualityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quality',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      qualityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quality',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      reviewedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      reviewedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      reviewedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      reviewedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reviewedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition> wordIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      wordIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition>
      wordIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterFilterCondition> wordIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReviewRecordQueryObject
    on QueryBuilder<ReviewRecord, ReviewRecord, QFilterCondition> {}

extension ReviewRecordQueryLinks
    on QueryBuilder<ReviewRecord, ReviewRecord, QFilterCondition> {}

extension ReviewRecordQuerySortBy
    on QueryBuilder<ReviewRecord, ReviewRecord, QSortBy> {
  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      sortByEaseFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByNewInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newInterval', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      sortByNewIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newInterval', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      sortByPreviousInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousInterval', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      sortByPreviousIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousInterval', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      sortByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByWordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordId', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> sortByWordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordId', Sort.desc);
    });
  }
}

extension ReviewRecordQuerySortThenBy
    on QueryBuilder<ReviewRecord, ReviewRecord, QSortThenBy> {
  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookId', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      thenByEaseFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easeFactor', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByNewInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newInterval', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      thenByNewIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newInterval', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      thenByPreviousInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousInterval', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      thenByPreviousIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousInterval', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByQualityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quality', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy>
      thenByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.desc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByWordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordId', Sort.asc);
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QAfterSortBy> thenByWordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordId', Sort.desc);
    });
  }
}

extension ReviewRecordQueryWhereDistinct
    on QueryBuilder<ReviewRecord, ReviewRecord, QDistinct> {
  QueryBuilder<ReviewRecord, ReviewRecord, QDistinct> distinctByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookId');
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QDistinct> distinctByEaseFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'easeFactor');
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QDistinct> distinctByNewInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'newInterval');
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QDistinct>
      distinctByPreviousInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previousInterval');
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QDistinct> distinctByQuality() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quality');
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QDistinct> distinctByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reviewedAt');
    });
  }

  QueryBuilder<ReviewRecord, ReviewRecord, QDistinct> distinctByWordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordId');
    });
  }
}

extension ReviewRecordQueryProperty
    on QueryBuilder<ReviewRecord, ReviewRecord, QQueryProperty> {
  QueryBuilder<ReviewRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReviewRecord, int?, QQueryOperations> bookIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookId');
    });
  }

  QueryBuilder<ReviewRecord, double, QQueryOperations> easeFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'easeFactor');
    });
  }

  QueryBuilder<ReviewRecord, double, QQueryOperations> newIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'newInterval');
    });
  }

  QueryBuilder<ReviewRecord, double, QQueryOperations>
      previousIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previousInterval');
    });
  }

  QueryBuilder<ReviewRecord, int, QQueryOperations> qualityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quality');
    });
  }

  QueryBuilder<ReviewRecord, DateTime, QQueryOperations> reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reviewedAt');
    });
  }

  QueryBuilder<ReviewRecord, int, QQueryOperations> wordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordId');
    });
  }
}
