import '../models/learning_session.dart';
import '../models/review_record.dart';
import '../models/word.dart';
import '../repositories/session_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/word_repository.dart';
import '../utils/sm2_algorithm.dart';
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
    int? bookId,
    LearningSession? session,
  }) async {
    final previousInterval = word.sm2Interval;
    final sm2 = Sm2Algorithm.calculate(
      quality: quality.value,
      repetitions: word.reviewCount,
      easeFactor: word.easeFactor,
      interval: word.sm2Interval,
    );

    word.reviewCount = sm2.repetitions;
    word.easeFactor = sm2.easeFactor;
    word.sm2Interval = sm2.interval;
    word.nextReview = sm2.nextReview;
    word.familiarity =
        Sm2Algorithm.nextFamiliarity(word.familiarity, quality.value);
    word.correctStreak =
        quality.value >= 2 ? word.correctStreak + 1 : 0;

    if (quality == StudyQuality.again) {
      word.inWrongBook = true;
    } else if (quality.value >= 2) {
      word.inWrongBook = false;
    }

    await _wordRepository.saveWord(word);

    final record = ReviewRecord()
      ..wordId = word.id
      ..bookId = bookId
      ..quality = quality.value
      ..reviewedAt = DateTime.now()
      ..previousInterval = previousInterval
      ..newInterval = sm2.interval
      ..easeFactor = sm2.easeFactor;
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