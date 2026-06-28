class BuiltInBookDefinition {
  const BuiltInBookDefinition({
    required this.assetPath,
    required this.title,
    required this.description,
    required this.category,
    required this.coverColor,
  });

  final String assetPath;
  final String title;
  final String description;
  final String category;
  final String coverColor;
}

/// Built-in vocabulary books sourced from KyleBing/english-vocabulary.
class BuiltInBooks {
  BuiltInBooks._();

  static const books = <BuiltInBookDefinition>[
    BuiltInBookDefinition(
      assetPath: 'assets/vocab/Level4_1.json',
      title: '基础1000词',
      description: '最常用的英语基础词汇',
      category: 'basic',
      coverColor: '#4CAF50',
    ),
    BuiltInBookDefinition(
      assetPath: 'assets/vocab/CET4_1.json',
      title: 'CET4 核心词汇',
      description: '大学英语四级考试核心词汇',
      category: 'cet4',
      coverColor: '#2196F3',
    ),
    BuiltInBookDefinition(
      assetPath: 'assets/vocab/CET6_1.json',
      title: 'CET6 核心词汇',
      description: '大学英语六级考试核心词汇',
      category: 'cet6',
      coverColor: '#9C27B0',
    ),
    BuiltInBookDefinition(
      assetPath: 'assets/vocab/IELTS_2.json',
      title: '雅思高频词汇',
      description: 'IELTS 考试高频核心词汇',
      category: 'ielts',
      coverColor: '#FF9800',
    ),
    BuiltInBookDefinition(
      assetPath: 'assets/vocab/TOEFL_2.json',
      title: 'TOEFL 高频词汇',
      description: '托福考试高频核心词汇',
      category: 'toefl',
      coverColor: '#F44336',
    ),
  ];
}