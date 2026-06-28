import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../database/isar_service.dart';
import '../models/learning_session.dart';
import '../utils/study_quality.dart';

class SessionRepository {
  SessionRepository(this._isar);

  final Isar _isar;

  Future<LearningSession> startSession({
    required String sessionType,
    required List<int> bookIds,
  }) async {
    final session = LearningSession()
      ..sessionType = sessionType
      ..bookIds = bookIds
      ..startedAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.learningSessions.put(session);
    });
    return session;
  }

  Future<void> recordResult(
    LearningSession session,
    StudyQuality quality,
  ) async {
    session.wordsStudied += 1;
    if (quality.value >= 2) {
      session.wordsCorrect += 1;
    }
    await _isar.writeTxn(() async {
      await _isar.learningSessions.put(session);
    });
  }

  Future<void> completeSession(LearningSession session) async {
    session.completedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.learningSessions.put(session);
    });
  }

  Future<LearningSession?> getSession(int id) {
    return _isar.learningSessions.get(id);
  }

  Future<List<LearningSession>> getRecentSessions({int limit = 30}) {
    return _isar.learningSessions
        .where()
        .sortByStartedAtDesc()
        .limit(limit)
        .findAll();
  }

  Future<void> deleteSession(int id) async {
    await _isar.writeTxn(() async {
      await _isar.learningSessions.delete(id);
    });
  }

  Future<void> deleteSessions(List<int> ids) async {
    if (ids.isEmpty) {
      return;
    }
    await _isar.writeTxn(() async {
      for (final id in ids) {
        await _isar.learningSessions.delete(id);
      }
    });
  }

  Future<void> clearAllSessions() async {
    await _isar.writeTxn(() async {
      await _isar.learningSessions.clear();
    });
  }

  Future<int> cleanupStaleSessions({
    Duration maxAge = const Duration(hours: 24),
  }) async {
    final cutoff = DateTime.now().subtract(maxAge);
    final stale = await _isar.learningSessions
        .filter()
        .completedAtIsNull()
        .startedAtLessThan(cutoff)
        .findAll();

    if (stale.isEmpty) {
      return 0;
    }

    await _isar.writeTxn(() async {
      for (final session in stale) {
        await _isar.learningSessions.delete(session.id);
      }
    });
    return stale.length;
  }
}

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(IsarService.instance);
});