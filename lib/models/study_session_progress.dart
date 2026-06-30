/// 当前进行中的一轮练习进度（仅内存，不写入 Hive）。
class StudySessionProgress {
  StudySessionProgress({required this.sessionType});

  final String sessionType;
  int wordsStudied = 0;
  int wordsCorrect = 0;

  void recordResult(bool isCorrect) {
    wordsStudied += 1;
    if (isCorrect) {
      wordsCorrect += 1;
    }
  }
}