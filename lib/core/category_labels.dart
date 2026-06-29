const bookCategoryLabels = <String, String>{
  'basic': '高考',
  'cet4': 'CET4',
  'cet6': 'CET6',
  'ielts': '雅思',
  'toefl': '考研',
  'custom': '自定义',
  'test': '测试',
};

String categoryLabel(String category) =>
    bookCategoryLabels[category] ?? category.toUpperCase();

const bookDifficultyLabels = <String, String>{
  'basic': '入门',
  'cet4': '中级',
  'cet6': '中高级',
  'ielts': '高级',
  'toefl': '高级',
  'custom': '自定义',
};

String categoryDifficulty(String category) =>
    bookDifficultyLabels[category] ?? '通用';

const bookCategories = [
  'basic',
  'cet4',
  'cet6',
  'ielts',
  'toefl',
  'custom',
  'test',
];