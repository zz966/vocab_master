import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/achievements.dart';
import '../models/learning_session.dart';
import 'session_date_filter.dart';

enum SessionFilter { all, study, review, practice }

extension SessionFilterLabel on SessionFilter {
  String get label => switch (this) {
        SessionFilter.all => '全部',
        SessionFilter.study => '新词学习',
        SessionFilter.review => '复习',
        SessionFilter.practice => '专项',
      };
}

bool matchesSessionTypeFilter(LearningSession session, SessionFilter filter) {
  return switch (filter) {
    SessionFilter.all => true,
    SessionFilter.study => studyModeTypes.contains(session.sessionType),
    SessionFilter.review => session.sessionType.startsWith('review_'),
    SessionFilter.practice =>
      session.sessionType == 'wrong_book' ||
          session.sessionType == 'favorites' ||
          session.sessionType.startsWith('practice_'),
  };
}

class SessionFilterState {
  const SessionFilterState({
    required this.typeFilter,
    required this.dateRange,
    this.bookId,
    this.customRange,
  });

  final SessionFilter typeFilter;
  final SessionDateRange dateRange;
  final String? bookId;
  final DateTimeRange? customRange;
}

class SessionFilterPrefs {
  static const _typeKey = 'session_type_filter';
  static const _dateRangeKey = 'session_date_range';
  static const _bookIdKey = 'session_book_filter';
  static const _customStartKey = 'session_custom_start';
  static const _customEndKey = 'session_custom_end';

  static Future<SessionFilterState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final typeName = prefs.getString(_typeKey);
    final dateName = prefs.getString(_dateRangeKey);

    if (typeName == null &&
        dateName == null &&
        !prefs.containsKey(_bookIdKey)) {
      return null;
    }

    final typeFilter = _parseTypeFilter(typeName) ?? SessionFilter.all;
    final dateRange = _parseDateRange(dateName) ?? SessionDateRange.all;
    final bookId =
        prefs.containsKey(_bookIdKey) ? prefs.getString(_bookIdKey) : null;

    DateTimeRange? customRange;
    final customStart = prefs.getString(_customStartKey);
    final customEnd = prefs.getString(_customEndKey);
    if (customStart != null && customEnd != null) {
      customRange = DateTimeRange(
        start: DateTime.parse(customStart),
        end: DateTime.parse(customEnd),
      );
    }

    return SessionFilterState(
      typeFilter: typeFilter,
      dateRange: dateRange,
      bookId: bookId,
      customRange: customRange,
    );
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_typeKey);
    await prefs.remove(_dateRangeKey);
    await prefs.remove(_bookIdKey);
    await prefs.remove(_customStartKey);
    await prefs.remove(_customEndKey);
  }

  static Future<void> save({
    required SessionFilter typeFilter,
    required SessionDateRange dateRange,
    String? bookId,
    DateTimeRange? customRange,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_typeKey, typeFilter.name);
    await prefs.setString(_dateRangeKey, dateRange.name);

    if (bookId == null) {
      await prefs.remove(_bookIdKey);
    } else {
      await prefs.setString(_bookIdKey, bookId);
    }

    if (dateRange == SessionDateRange.custom && customRange != null) {
      await prefs.setString(
        _customStartKey,
        customRange.start.toIso8601String(),
      );
      await prefs.setString(
        _customEndKey,
        customRange.end.toIso8601String(),
      );
    } else {
      await prefs.remove(_customStartKey);
      await prefs.remove(_customEndKey);
    }
  }

  static SessionFilter? _parseTypeFilter(String? name) {
    if (name == null) {
      return null;
    }
    for (final value in SessionFilter.values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }

  static SessionDateRange? _parseDateRange(String? name) {
    if (name == null) {
      return null;
    }
    for (final value in SessionDateRange.values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }
}