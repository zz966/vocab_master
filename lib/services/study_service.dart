import '../models/study_session_progress.dart';
import '../models/word.dart';
import '../repositories/settings_repository.dart';
import '../repositories/word_repository.dart';

class StudyService {
  StudyService({
    required this._wordRepository,
    required this._settingsRepository,
  });

  final WordRepository _wordRepository;
  final SettingsRepository _settingsRepository;

  Future<void> recordAnswer({
    required Word word,
    required bool isCorrect,
    String? bookId,
    StudySessionProgress? progress,
  }) async {
    if (isCorrect) {
      word.learned = true;
    }

    await _wordRepository.saveWord(word, bookId: bookId);

    await _settingsRepository.upsertTodayAnswerRecord(
      wordId: word.id,
      bookId: bookId,
    );

    final settings = await _settingsRepository.getSettings();
    await _settingsRepository.recordStudyDay(settings);

    progress?.recordResult(isCorrect);
  }
}