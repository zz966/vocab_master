const levelChallengeModes = <StudyMode>[
  StudyMode.quiz,
  StudyMode.spelling,
  StudyMode.listening,
];

enum StudyMode {
  flashcard('速刷', '单词、发音和释义快速过一遍'),
  quiz('选择题', '四选一，支持中→英 / 英→中'),
  spelling('拼写', '看释义拼写单词'),
  listening('听音选义', '听发音，四选一选中文');

  const StudyMode(this.title, this.subtitle);

  final String title;
  final String subtitle;

  static StudyMode fromId(String id) {
    return StudyMode.values.firstWhere(
      (mode) => mode.name == id,
      orElse: () => StudyMode.flashcard,
    );
  }
}
