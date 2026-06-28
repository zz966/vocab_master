import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/learning_session.dart';
import '../models/review_record.dart';
import '../models/word.dart';
import '../repositories/session_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/word_repository.dart';

class SessionWordEntry {
  const SessionWordEntry({
    required this.word,
    required this.record,
  });

  final Word word;
  final ReviewRecord record;
}

class SessionDetail {
  const SessionDetail({
    required this.session,
    required this.entries,
  });

  final LearningSession session;
  final List<SessionWordEntry> entries;
}

final sessionDetailProvider =
    FutureProvider.family<SessionDetail?, int>((ref, sessionId) async {
  final session =
      await ref.watch(sessionRepositoryProvider).getSession(sessionId);
  if (session == null) {
    return null;
  }

  final records = await ref
      .watch(settingsRepositoryProvider)
      .getReviewRecordsForSession(session);
  final wordRepo = ref.watch(wordRepositoryProvider);
  final entries = <SessionWordEntry>[];

  for (final record in records) {
    final word = await wordRepo.getWord(record.wordId);
    if (word != null) {
      entries.add(SessionWordEntry(word: word, record: record));
    }
  }

  return SessionDetail(session: session, entries: entries);
});