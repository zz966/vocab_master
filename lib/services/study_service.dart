import '../core/hive/hive_service.dart';
import '../models/learning_session.dart';
import '../models/review_record.dart';
import '../models/word.dart';
import '../repositories/session_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/word_repository.dart';
import '../utils/study_progress.dart';
import '../utils/study_quality.dart';

class StudyService {
  StudyService({
    required this._wordRepository,
    required this._settingsRepository,
    required this._sessionRepository,
  });

  final WordRepository _wordRepository;
  final SettingsRepository _settingsRepository;
  final SessionRepository _sessionRepository;

  Future<void> rateWord({
    required Word word,
    required StudyQuality quality,
    String? bookId,
    LearningSession? session,
  }) async {
    final previousInterval = word.sm2Interval;
    StudyProgress.applyRating(word, quality);

    await _wordRepository.saveWord(word, bookId: bookId);

    final record = ReviewRecord(
      id: HiveService.nextId('review'),
      wordId: word.id,
      bookId: bookId,
      quality: quality.value,
      reviewedAt: DateTime.now(),
      previousInterval: previousInterval,
      newInterval: word.sm2Interval,
      easeFactor: word.easeFactor,
    );
    await _settingsRepository.addReviewRecord(record);

    final settings = await _settingsRepository.getSettings();
    await _settingsRepository.recordStudyDay(settings);

    if (session != null) {
      await _sessionRepository.recordResult(session, quality);
    }
  }

  Future<void> toggleFavorite(Word word) {
    return _wordRepository.toggleFavorite(word);
  }

  Future<void> removeFromWrongBook(Word word) {
    return _wordRepository.removeFromWrongBook(word);
  }

  Future<void> toggleWrongBook(Word word) {
    return _wordRepository.toggleWrongBook(word);
  }

  Future<void> addToWrongBook(Word word) {
    return _wordRepository.addToWrongBook(word);
  }
}