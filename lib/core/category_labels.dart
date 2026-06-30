const bookCategoryLabels = <String, String>{
  'basic': '基础',
  'cet4': '四级',
  'cet6': '六级',
  'ielts': '雅思',
  'toefl': '托福',
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
};

String categoryDifficulty(String category) =>
    bookDifficultyLabels[category] ?? '通用';

const bookCategories = [
  'basic',
  'cet4',
  'cet6',
  'ielts',
  'toefl',
  'test',
];