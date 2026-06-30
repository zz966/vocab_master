/// 词书 [category] 字段 → 展示文案。未列出的分类原样显示。
const bookCategoryLabels = <String, String>{
  'test': '测试',
};

String categoryLabel(String category) {
  final trimmed = category.trim();
  if (trimmed.isEmpty) {
    return '未分类';
  }
  return bookCategoryLabels[trimmed] ?? trimmed;
}