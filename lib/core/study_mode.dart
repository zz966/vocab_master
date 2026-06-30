const levelChallengeModes = <StudyMode>[
  StudyMode.quiz,
  StudyMode.spelling,
  StudyMode.listening,
];

enum StudyMode {
  quiz('选择题', '四选一，英→中'),
  spelling('拼写', '看释义拼写单词'),
  listening('听音选义', '听发音，四选一选中文');

  const StudyMode(this.title, this.subtitle);

  final String title;
  final String subtitle;

  static StudyMode fromId(String id) {
    return StudyMode.values.firstWhere(
      (mode) => mode.name == id,
      orElse: () => StudyMode.quiz,
    );
  }
}