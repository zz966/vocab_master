import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/book_repository.dart';
import '../repositories/level_challenge_repository.dart';
import '../repositories/level_study_repository.dart';
import '../repositories/points_repository.dart';

import '../repositories/settings_repository.dart';
import '../repositories/word_repository.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
BookRepository bookRepository(Ref ref) => BookRepository();

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => SettingsRepository();

@Riverpod(keepAlive: true)
WordRepository wordRepository(Ref ref) => WordRepository();

@Riverpod(keepAlive: true)
LevelChallengeRepository levelChallengeRepository(Ref ref) =>
    LevelChallengeRepository();

@Riverpod(keepAlive: true)
LevelStudyRepository levelStudyRepository(Ref ref) => LevelStudyRepository();

@Riverpod(keepAlive: true)
PointsRepository pointsRepository(Ref ref) =>
    PointsRepository(ref.watch(settingsRepositoryProvider));