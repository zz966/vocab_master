import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/study_service.dart';
import '../services/tts_service.dart';
import 'book_provider.dart';
import 'points_provider.dart';
import 'repository_providers.dart';
import 'settings_provider.dart';

part 'study_provider.g.dart';

@Riverpod(keepAlive: true)
TtsService ttsService(Ref ref) => TtsService.instance;

@riverpod
StudyService studyService(Ref ref) {
  return StudyService(
    wordRepository: ref.watch(wordRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
  );
}

@riverpod
class NavigationIndex extends _$NavigationIndex {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

void invalidateStudyData(WidgetRef ref) {
  ref.invalidate(booksProvider);
  ref.invalidate(globalOverviewStatsProvider);
  ref.invalidate(levelChallengeStarsProvider);
  ref.invalidate(settingsProvider);
  ref.invalidate(todayStudyCountProvider);
  ref.invalidate(pointsHistoryProvider);
  ref.invalidate(allPointsHistoryProvider);
}