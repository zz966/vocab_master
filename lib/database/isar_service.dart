import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/learning_session.dart';
import '../models/review_record.dart';
import '../models/user_settings.dart';
import '../models/word.dart';
import '../models/word_book.dart';

class IsarService {
  IsarService._();

  static Isar? _isar;

  static Isar get instance {
    final isar = _isar;
    if (isar == null) {
      throw StateError('Isar has not been initialized. Call init() first.');
    }
    return isar;
  }

  static Future<Isar> init() async {
    if (_isar != null) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        WordBookSchema,
        WordSchema,
        UserSettingsSchema,
        ReviewRecordSchema,
        LearningSessionSchema,
      ],
      directory: dir.path,
      name: 'vocab_master',
    );

    return _isar!;
  }

  static Future<void> seedDefaultSettingsIfNeeded() async {
    final isar = instance;
    if (await isar.userSettings.count() > 0) {
      return;
    }

    final firstBook = await isar.wordBooks.where().anyId().findFirst();
    await isar.writeTxn(() async {
      final settings = UserSettings()
        ..dailyGoal = 20
        ..themeMode = 'system'
        ..defaultBookIds = firstBook != null ? [firstBook.id] : [];
      await isar.userSettings.put(settings);
    });
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }

}