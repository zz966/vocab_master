

import '../core/hive/hive_service.dart';
import '../models/learning_session.dart';
import '../utils/study_quality.dart';

class SessionRepository {
  Future<LearningSession> startSession({
    required String sessionType,
    required List<String> bookIds,
  }) async {
    final session = LearningSession(
      id: HiveService.nextId('session'),
      sessionType: sessionType,
      bookIds: bookIds,
      startedAt: DateTime.now(),
    );

    await HiveService.saveSession(session);
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
    await HiveService.saveSession(session);
  }

  Future<void> completeSession(LearningSession session) async {
    session.completedAt = DateTime.now();
    await HiveService.saveSession(session);
  }

  Future<LearningSession?> getSession(String id) async {
    return HiveService.getSession(id);
  }

  Future<List<LearningSession>> getRecentSessions({int limit = 30}) async {
    return HiveService.getAllSessions().take(limit).toList();
  }

  Future<void> deleteSession(String id) async {
    await HiveService.deleteSession(id);
  }

  Future<void> deleteSessions(List<String> ids) async {
    for (final id in ids) {
      await HiveService.deleteSession(id);
    }
  }

  Future<void> clearAllSessions() async {
    await HiveService.clearSessions();
  }

  Future<int> cleanupStaleSessions({
    Duration maxAge = const Duration(hours: 24),
  }) async {
    final cutoff = DateTime.now().subtract(maxAge);
    final stale = HiveService.getAllSessions()
        .where(
          (session) =>
              session.completedAt == null && session.startedAt.isBefore(cutoff),
        )
        .toList();

    for (final session in stale) {
      await HiveService.deleteSession(session.id);
    }
    return stale.length;
  }
}

