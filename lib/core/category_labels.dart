/// 词书分类 Tab 固定顺序（由易到难，不含「全部」）。
const bookCategoryOrder = <String>[
  'test',
  'junior',
  'senior',
  'cet4',
  'cet6',
  'kaoyan',
  'ielts',
  'toefl',
  'sat',
  'gre',
  'daily',
  'business',
];

/// 词书 [category] 字段 → 展示文案。未列出的分类原样显示。
const bookCategoryLabels = <String, String>{
  'test': '测试',
  'cet4': '四级',
  'cet6': '六级',
  'kaoyan': '考研',
  'ielts': '雅思',
  'toefl': '托福',
  'sat': 'SAT',
  'gre': 'GRE',
  'daily': '日常',
  'junior': '初中',
  'senior': '高中',
  'business': '商务',
};

String categoryLabel(String category) {
  final trimmed = category.trim();
  if (trimmed.isEmpty) {
    return '未分类';
  }
  return bookCategoryLabels[trimmed] ?? trimmed;
}