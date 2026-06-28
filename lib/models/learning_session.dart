import 'package:isar/isar.dart';

part 'learning_session.g.dart';

@collection
class LearningSession {
  Id id = Isar.autoIncrement;

  late String sessionType;
  late List<int> bookIds;
  int wordsStudied = 0;
  int wordsCorrect = 0;
  DateTime startedAt = DateTime.now();
  DateTime? completedAt;
}